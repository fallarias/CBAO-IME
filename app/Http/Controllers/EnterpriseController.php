<?php

namespace App\Http\Controllers;

use App\Models\Campus;
use App\Models\Enterprise;
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
        $enterprisesQuery = Enterprise::with('campus:id,campus') // eager load campus name
            ->when($user->role !== 'Admin', function ($query) use ($user) {
                $query->where('campus_id', $user->campus->id);
            })
            ->orderBy('enterprise', 'asc');

        $enterprises = $enterprisesQuery->get();

        // All enterprises (cloned + add number)
        $all_enterprises = $enterprises
            ->map(fn ($item) => clone $item)
            ->values()
            ->map(function ($item, $key) {
                $item->number = $key + 1;
                // flatten campus name for easier access in Vue
                $item->campus_name = $item->campus->campus ?? null;
                return $item;
            });

        // Agri-based
        $agri_based = $enterprises
            ->where('category', 'Agri-based')
            ->map(fn ($item) => clone $item)
            ->values()
            ->map(function ($item, $key) {
                $item->number = $key + 1;
                $item->campus_name = $item->campus->campus ?? null;
                return $item;
            });

        // Non-agri-based
        $non_agri_based = $enterprises
            ->where('category', 'Non agri-based')
            ->map(fn ($item) => clone $item)
            ->values()
            ->map(function ($item, $key) {
                $item->number = $key + 1;
                $item->campus_name = $item->campus->campus ?? null;
                return $item;
            });

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
        $request->validate([
            'enterprise' => 'required|string|max:255',
            'category' => 'required|string|in:Agri-based,Non agri-based',
        ]);

        try {
            Enterprise::create([
                'campus_id' => Auth::user()->campus->id,
                'enterprise' => $request->enterprise,
                'category' => $request->category,
            ]);

            return redirect()->back()->with('success', 'Business enterprise added successfully.');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Failed to add enterprise: ' . $e->getMessage());
        }
    }

    public function update(Request $request, $id)
    {
        $request->validate([
            'enterprise' => 'required|string|max:255',
            'category' => 'required|string|in:Agri-based,Non agri-based',
        ]);

        try {
            $enterprise = Enterprise::findOrFail($id);

            $enterprise->update([
                'enterprise' => $request->enterprise,
                'category' => $request->category,
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
