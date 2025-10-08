<?php

namespace App\Http\Controllers;

use App\Models\Campus;
use App\Models\Enterprise;
use App\Models\Inventory;
use App\Models\UserLogs;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;

class EnterpriseController extends Controller
{
    // display list of enterprises
    public function display() {
        $user = Auth::user();
        $user_campus = Auth::user()->campus->id;

        // get all campuses
        $campuses = Campus::select('id', 'campus')->get();

        // Enterprises query with campus relationship
        $enterprisesQuery = Enterprise::with('campus:id,campus') // eager load campus name only
            ->select('id', 'campus_id', 'user_id', 'enterprise', 'category', 'inventory', 'created_at', 'updated_at', 'updated_by')
            ->when($user->role !== 'Admin', function ($query) use ($user) {
                $query->where('campus_id', $user->campus->id);
            })
            ->orderBy('created_at', 'desc');

        $enterprises = $enterprisesQuery->get();


        // Helper closure for transformation
        $transformEnterprise = function ($collection) {
            return $collection
                ->values()
                ->map(function ($item, $key) {
                    $item->number = $key + 1;
                    $item->campus_name = $item->campus->campus ?? null;
                    $item->inventory = (bool) $item->inventory;
                    $item->added_by = $item->user
                        ? ($item->user->first_name . ' ' . $item->user->last_name)
                        : 'Admin';
                    $item->added_at = $item->created_at->format('Y-m-d \a\t h:i A');
                    return $item;
                });
        };

        // Transform each group
        $all_enterprises   = $transformEnterprise($enterprises);
        $agri_based        = $transformEnterprise($enterprises->where('category', 'Agri-based'));
        $non_agri_based    = $transformEnterprise($enterprises->where('category', 'Non agri-based'));

        // Totals
        $enterprises_total = [
            'overall_total' => $all_enterprises->count(),
            'agri_based_total' => $agri_based->count(),
            'non_agri_based_total' => $non_agri_based->count(),
        ];

        return Inertia::render('Enterprises/EnterpriseList', [
            'campuses' => $campuses,
            'all_enterprises' => $all_enterprises,
            'agri_based' => $agri_based,
            'non_agri_based' => $non_agri_based,
            'enterprises_total' => $enterprises_total,
        ]);
    }

    // add new bsusiness enterprise
    public function store(Request $request)
    {
        $validated = $request->validate([
            'enterprise' => 'required|string|max:255',
            'category' => 'required|string|in:Agri-based,Non agri-based',
            'inventory' => 'nullable|boolean',
            'campus_id' => 'required|integer|exists:campuses,id',
        ]);

        // $campus_id = Auth::user()->campus->id;
        // if (Auth::user()->role != 'User'){
        //     $campus_id = $request->campus_id;
        // }

        try {
            $enterprise = Enterprise::create([
                'campus_id' => $validated['campus_id'],
                'enterprise' => $validated['enterprise'],
                'category' => $validated['category'],
                'inventory' => $validated['inventory'],
                'user_id' => Auth::user()->id
            ]);

            if ($validated['inventory'] == true) {
                Inventory::create([
                    'campus_id' => $validated['campus_id'],
                    'enterprise_id' => $enterprise->id,
                    'updated_by' => Auth::user()->id
                ]);
            }
            
            UserLogs::create([
                'user_id' => Auth::user()->id,
                'action' => 'Added Business Enterprise',
                'description' => 'User ' . Auth::user()->first_name . ' ' . Auth::user()->last_name . ' added a new business enterprise: ' . $validated['enterprise'] . '.',
            ]);


            return redirect()->back()->with('success', 'Business enterprise added successfully.');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Failed to add enterprise: ' . $e->getMessage());
        }
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'enterprise' => 'required|string|max:255',
            'category' => 'required|string|in:Agri-based,Non agri-based',
            'inventory' => 'nullable|boolean',
            'campus_id' => 'required|integer|exists:campuses,id',
        ]);

        // $campus_id = Auth::user()->campus->id;
        // if (Auth::user()->role != 'User'){
        //     $campus_id = $request->campus_id;
        // }

        try {
            $enterprise = Enterprise::findOrFail($id);

            $enterprise->update([
                'campus_id' => $validated['campus_id'],
                'enterprise' => $validated['enterprise'],
                'category' => $validated['category'],
                'inventory' => $validated['inventory'],
                'updated_by' => Auth::user()->id
            ]);

            UserLogs::create([
                'user_id' => Auth::user()->id,
                'action' => 'Updated a business enterprise',
                'description' => 'User ' . Auth::user()->first_name . ' ' . Auth::user()->last_name . ' has updated the business enterprise: ' . $validated['enterprise'] . '.',
            ]);

            return redirect()->back()->with('success', 'Business enterprise updated successfully.');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Failed to update enterprise: ' . $e->getMessage());
        }
    }

    // display list of account ledgers
    public function view() {
        return Inertia::render('Enterprises/AccountLedgers');
    }

    // display list of transaction history of clients
    public function fetch() {
        return Inertia::render('Enterprises/ClientTransactionHistory');
    }
}
