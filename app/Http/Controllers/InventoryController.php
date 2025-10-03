<?php

namespace App\Http\Controllers;

use App\Models\Enterprise;
use App\Models\Inventory;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\Rule;
use Inertia\Inertia;

class InventoryController extends Controller
{
    // display list of products
    public function display() {
        // $user = User::with('campus:id,campus')->find(Auth::id()); // eager load campus with only needed columns
        $campus_id = Auth::user()->campus->id;
        // $campus_name = Auth::user()->campus->campus ?? 'N/A';

        $inventories = Inventory::with('enterprise:id,enterprise') // only select id and enterprise name
            ->where('campus_id', $campus_id)
            ->get()
            ->map(function ($item, $key) {
                return [
                    'number'        => $key + 1,
                    'image' => $item->image,
                    'enterprise_name' => $item->enterprise->enterprise ?? 'N/A',
                    'quantity' => $item->quantity,
                    'price' => number_format($item->price, 2),
                    'unit' => $item->unit,
                    'enterprise_status' => $item->status, // assumes `status` is a column in inventories table
                    'date' => $item->created_at->eq($item->updated_at)
                        ? Carbon::parse($item->created_at)->timezone('Asia/Manila')->format('Y-m-d \a\t h:i A')
                        : Carbon::parse($item->updated_at)->timezone('Asia/Manila')->format('Y-m-d \a\t h:i A'),
                    'updated_by' => $item->updatedByUser
                        ? $item->updatedByUser->first_name . ' ' . $item->updatedByUser->last_name
                        : 'Unknown',
                ];
            });

        return Inertia::render('Inventory/InventoryList', [
            'inventories' => $inventories,
            // 'campus_name' => $campus_name
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

    // display list of products
    public function view() {
        return Inertia::render('Inventory/InventorySalesPerProduct');
    }
}
