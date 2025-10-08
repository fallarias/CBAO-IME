<?php

namespace App\Http\Controllers;

use App\Models\Campus;
use App\Models\Enterprise;
use App\Models\Inventory;
use App\Models\User;
use App\Models\UserLogs;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\Rule;
use Inertia\Inertia;

class InventoryController extends Controller
{
    // display list of products
    public function display()
    {
        $user = Auth::user();
        $campuses = Campus::select('id', 'campus')->get();
        $campus_id = $user->campus->id;

        // ✅ Base query with relationships
        $query = Inventory::with([
            'enterprise:id,enterprise',
            'campus:id,campus',
            'updatedByUser:id,first_name,last_name',
        ])->orderBy('created_at', 'desc');;

        // ✅ If role is "User", filter by campus_id
        if ($user->role === 'User') {
            $query->where('campus_id', $campus_id);
        }

        $inventories = $query->get()->map(function ($item, $key) {
            return [
                'id' => $item->id,
                'number' => $key + 1,
                'image' => $item->image,
                'campus' => [
                    'id' => $item->campus_id,
                    'name' => $item->campus->campus ?? 'N/A',
                ],
                'enterprise_name' => $item->enterprise->enterprise ?? 'N/A',
                'quantity' => $item->quantity,
                'price' => number_format($item->price, 2),
                'unit' => $item->unit ?? '--',
                'enterprise_status' => $item->status,
                'date' => $item->created_at->eq($item->updated_at)
                    ? $item->created_at->timezone('Asia/Manila')->format('Y-m-d \a\t h:i A')
                    : $item->updated_at->timezone('Asia/Manila')->format('Y-m-d \a\t h:i A'),
                'updated_by' => $item->updatedByUser
                    ? $item->updatedByUser->first_name . ' ' . $item->updatedByUser->last_name
                    : 'Unknown',
            ];
        });

        return Inertia::render('Inventory/InventoryList', [
            'inventories' => $inventories,
            'campuses' => $campuses,
        ]);
    }


    public function store(Request $request)
    {
        $validated = $request->validate([
            'enterprise_id' => ['required', 'integer', 'min:0'],
            'enterprise_name' => [
                'nullable',
                'string',
                'max:255',
                Rule::requiredIf($request->enterprise_id == 0),
                Rule::excludeIf($request->enterprise_id != 0),
            ],

            'enterprise_category' => [
                'nullable',
                'string',
                'max:255',
                Rule::requiredIf($request->enterprise_id == 0),
                Rule::excludeIf($request->enterprise_id != 0),
            ],
            'quantity' => ['required', 'numeric', 'min:0'],
            'unit' => ['required', 'string', Rule::in(['pc', 'kg', 'm', 'l'])],
            'price' => [
                'required',
                'numeric',
                'min:0',
                'regex:/^\d+(\.\d{1,2})?$/'
            ],
        ]);

        // Determine the enterprise_id
        if ($validated['enterprise_id'] == 0) {
            // Create new enterprise
            $enterprise = Enterprise::create([
                'enterprise' => strtoupper($validated['enterprise_name']),
                'category' => $validated['enterprise_category'],
                'campus_id' => Auth::user()->campus_id, // Optional if enterprise table is campus-specific
            ]);

            $enterprise_id = $enterprise->id;
        } else {
            $enterprise_id = $validated['enterprise_id'];
        }

        // Save to inventories table
        Inventory::create([
            'enterprise_id' => $enterprise_id,
            'quantity' => $validated['quantity'],
            'unit' => $validated['unit'],
            'price' => $validated['price'],
            'campus_id' => Auth::user()->campus_id,
        ]);

        return redirect()->back()->with('success', 'Enterprise was successfully added to the inventory.');
    }

    // import enterprises
    public function import(Request $request)
    {
        $validated = $request->validate([
            'campus_id' => 'required|exists:campuses,id',
        ]);

        $user = Auth::user();

        try {
            // 🧾 Get all existing enterprise IDs in inventories table
            $existingInventoryEnterpriseIds = Inventory::pluck('enterprise_id')->toArray();

            // 🏢 Base query: Enterprises in the selected campus with inventory = 1 and not yet in inventories
            $query = Enterprise::select('id', 'enterprise', 'campus_id')
                ->where('campus_id', $validated['campus_id'])
                ->where('inventory', 1)
                ->whereNotIn('id', $existingInventoryEnterpriseIds);

            // 🔒 Restrict "User" role to their own campus
            if ($user->role === 'User' && $user->campus_id != $validated['campus_id']) {
                return redirect()->back()->with('error', 'Unauthorized campus selection.');
            }

            // ✅ Retrieve enterprises (alphabetically)
            $inventoryEnterprises = $query->orderBy('enterprise', 'asc')->get();

            // 🧩 If no new enterprises, return info message
            if ($inventoryEnterprises->isEmpty()) {
                return redirect()
                    ->back()
                    ->with('info', 'No new enterprises to import. All are already in the inventory.');
            }

            // 🗂️ Insert each enterprise into inventories table
            foreach ($inventoryEnterprises as $enterprise) {
                Inventory::create([
                    'campus_id' => $enterprise->campus_id,
                    'enterprise_id' => $enterprise->id,
                    'updated_by' => $user->id,
                ]);
            }

            // 🏫 Get campus name
            $campusName = Campus::where('id', $validated['campus_id'])->value('campus');

            // 🧾 Log user action
            UserLogs::create([
                'user_id' => $user->id,
                'action' => 'Imported Business Enterprises to Inventory',
                'description' => "User {$user->first_name} {$user->last_name} imported enterprises with inventories for campus {$campusName}.",
            ]);

            return redirect()->back()->with('success', 'Enterprises with inventory were successfully imported.');
        } catch (\Exception $e) {
            // \Log::error('Inventory import failed: ' . $e->getMessage());

            return redirect()
                ->back()
                ->with('error', 'Failed to import enterprises: ' . $e->getMessage());
        }
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'quantity' => ['required', 'numeric', 'min:0'],
            'unit' => ['required', 'string', Rule::in(['pc', 'kg', 'm', 'l'])],
            'price' => [
                'required',
                'numeric',
                'min:0',
                'regex:/^\d+(\.\d{1,2})?$/'
            ],
            'enterprise_status' => ['required', 'string', Rule::in(['Available', 'Not Available'])],
        ]);

        // dd($validated['enterprise_status']);

        try {
            $inventory = Inventory::findOrFail($id);

            $inventory->update([
                'quantity' => $validated['quantity'],
                'unit' => $validated['unit'],
                'price' => $validated['price'],
                'status' => $validated['enterprise_status'],
                'updated_by' => Auth::user()->id,
            ]);

            UserLogs::create([
                'user_id' => Auth::user()->id,
                'action' => 'Updated Inventory Item',
                'description' => 'User ' . Auth::user()->first_name . ' ' . Auth::user()->last_name . ' updated inventory item for enterprise: ' . ($inventory->enterprise->enterprise ?? 'N/A') . '.',
            ]);

            return redirect()->back()->with('success', 'Inventory updated successfully.');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Failed to update inventory: ' . $e->getMessage());
        }
    }

    // display list of products
    public function view() {
        return Inertia::render('Inventory/InventorySalesPerProduct');
    }
}
