<?php

namespace App\Http\Controllers;

use App\Models\Creditor;
use App\Models\CreditorHasUacs;
use App\Models\Enterprise;
use App\Models\Expense;
use App\Models\Uacs;
use App\Models\UacsGroup;
use App\Models\UacsType;
use App\Models\UserLogs;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;
use Carbon\Carbon;
use Illuminate\Support\Facades\Schema;


class CreditorController extends Controller
{
    // display list of creditors
    public function display($id)
    {
        $user = Auth::user();

        // 🧩 Step 1: Verify user campus if role is "User"
        if ($user->role === 'User') {
            $expense = Expense::select('id', 'campus_id', 'enterprise_id')->findOrFail($id);

            if ($expense->campus_id !== $user->campus_id) {
                return redirect()
                    ->route('expenses.display')
                    ->with('error', 'Unauthorized access: You can only view expenses from your campus.');
            }
        } else {
            $expense = Expense::select('id', 'campus_id', 'enterprise_id')->findOrFail($id);
        }

        // 🧾 Step 2: Retrieve creditors and their base data
        $creditors = Creditor::select(
            'creditors.id',
            'creditors.expenses_id',
            'creditors.creditor_name',
            'creditors.reference_date',
            'creditors.reference_serial_number',
            DB::raw('COALESCE(creditors.utilization, 0.00) as utilization'),
            DB::raw('COALESCE(creditors.disbursements, 0.00) as disbursements'),
            DB::raw('COALESCE(creditors.uu_due_and_demandable, 0.00) as uu_due_and_demandable'),
            DB::raw('COALESCE(creditors.uu_not_yet_due_and_demandable, 0.00) as uu_not_yet_due_and_demandable'),
            'creditors.check_number',
            'creditors.check_date',
            'creditors.particulars',
            DB::raw('COALESCE(creditors.total_mooe, 0.00) as total_mooe'),
            DB::raw('COALESCE(creditors.total_co, 0.00) as total_co'),
            DB::raw('COALESCE(creditors.overall_total, 0.00) as overall_total'),
            'creditors.updated_by'
        )
        ->where('creditors.expenses_id', $id)
        ->get();

        // 🧩 Step 3: Attach UACS details for each creditor
        foreach ($creditors as $creditor) {
            $uacsRecords = DB::table('creditor_has_uacs')
                ->join('uacs', 'creditor_has_uacs.uacs_id', '=', 'uacs.id')
                ->join('uacs_groups', 'uacs.uacs_group_id', '=', 'uacs_groups.id')
                ->join('uacs_types', 'uacs_groups.uacs_type_id', '=', 'uacs_types.id')
                ->select(
                    'creditor_has_uacs.amount',
                    'uacs.id as uacs_id',
                    'uacs.uacs_code',
                    'uacs.object_code',
                    'uacs.sub_object_code',
                    'uacs_groups.name as uacs_group_name',
                    'uacs_types.name as uacs_type_name'
                )
                ->where('creditor_has_uacs.creditor_id', $creditor->id)
                ->get();

            $creditor->uacs_codes = $uacsRecords;
        }

        // 🧩 Step 4: Retrieve enterprise name
        $enterpriseName = null;
        if ($expense->enterprise_id) {
            $enterpriseName = Enterprise::where('id', $expense->enterprise_id)->value('enterprise');
        }

        // 🧩 Step 5: Get UACS hierarchy data for dropdowns
        $uacsTypes = UacsType::select('id', 'name')->get();
        $uacsGroups = UacsGroup::select('id', 'uacs_type_id', 'name')->get();

        $uacsList = DB::table('uacs')
            ->select(
                'uacs.id',
                'uacs.uacs_group_id',
                'uacs.uacs_code',
                'uacs.object_code',
                'uacs.sub_object_code',
                'uacs_groups.uacs_type_id',
                'uacs_types.name as uacs_type_name'
            )
            ->leftJoin('uacs_groups', 'uacs.uacs_group_id', '=', 'uacs_groups.id')
            ->leftJoin('uacs_types', 'uacs_groups.uacs_type_id', '=', 'uacs_types.id')
            ->get();

        // 🧩 Step 6: Render Inertia page
        return Inertia::render('Expenses/CreditorsList', [
            'expense_id' => $id,
            'creditors' => $creditors,
            'enterprise' => $enterpriseName,
            'uacs_types' => $uacsTypes,
            'uacs_groups' => $uacsGroups,
            'uacs' => $uacsList,
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'expenses_id' => 'required|integer|exists:expenses,id',
            'creditor_name' => 'required|string|max:255',
            'reference_date' => 'nullable|date',
            'reference_serial_number' => 'nullable|string|max:255',
            'utilization' => 'numeric|min:0',
            'disbursements' => 'numeric|min:0',
            'uu_due_and_demandable' => 'numeric|min:0',
            'uu_not_yet_due_and_demandable' => 'numeric|min:0',
            'check_number' => 'nullable|string|max:255',
            'check_date' => 'nullable|date',
            'particulars' => 'nullable|string',
            'selected_uacs' => 'required|array|min:1',
            'selected_uacs.*.uacs_id' => 'required|integer|exists:uacs,id',
            'selected_uacs.*.amount' => 'required|numeric|min:0',
            'total_mooe' => 'numeric|min:0',
            'total_co' => 'numeric|min:0',
        ]);
    
        DB::beginTransaction();
    
        try {
            // Initialize totals
            $totalMooe = 0;
            $totalCo = 0;

            // 🧮 Step 1: Compute totals based on UACS hierarchy
            foreach ($validated['selected_uacs'] as $uacsItem) {
                $uacs = Uacs::select('uacs_group_id')->find($uacsItem['uacs_id']);

                if ($uacs) {
                    $uacsGroup = UacsGroup::select('uacs_type_id')->find($uacs->uacs_group_id);
                    if ($uacsGroup) {
                        $uacsType = UacsType::select('name')->find($uacsGroup->uacs_type_id);

                        if ($uacsType) {
                            $typeName = strtolower(trim($uacsType->name));
                            if ($typeName === 'mooe') {
                                $totalMooe += $uacsItem['amount'];
                            } elseif (in_array($typeName, ['capital outlay', 'co'])) {
                                $totalCo += $uacsItem['amount'];
                            }
                        }
                    }
                }
            }

            // 🧾 Step 1: Create the Creditor record
            $creditor = Creditor::create([
                'expenses_id' => $validated['expenses_id'],
                'creditor_name' => $validated['creditor_name'],
                'reference_date' => $validated['reference_date'] ?? null,
                'reference_serial_number' => $validated['reference_serial_number'] ?? null,
                'utilization' => $totalMooe + $totalCo,
                'disbursements' => $validated['disbursements'] ?? 0,
                'uu_due_and_demandable' => $validated['uu_due_and_demandable'] ?? 0,
                'uu_not_yet_due_and_demandable' => $validated['uu_not_yet_due_and_demandable'] ?? 0,
                'check_number' => $validated['check_number'] ?? null,
                'check_date' => $validated['check_date'] ?? null,
                'particulars' => $validated['particulars'] ?? null,
                'total_mooe' => $totalMooe,
                'total_co' => $totalCo,
                'overall_total' => $totalMooe + $totalCo,
                'updated_by' => Auth::user()->id,
            ]);
    
            // 🧮 Step 2: Insert UACS items related to the creditor
            foreach ($validated['selected_uacs'] as $uacs) {
                CreditorHasUacs::create([
                    'creditor_id' => $creditor->id,
                    'uacs_id' => $uacs['uacs_id'],
                    'amount' => $uacs['amount'],
                    'updated_by' => Auth::user()->id,
                ]);
            }

            // 🗓️ Step 3: Update corresponding columns in the Expenses table
            if (!empty($validated['reference_date'])) {
                $monthName = strtolower(Carbon::parse($validated['reference_date'])->format('F')); // e.g. "october"

                // Make sure the column exists before updating
                if (Schema::hasColumn('expenses', $monthName)) {
                    $expenses = Expense::find($validated['expenses_id']);

                    if ($expenses) {
                        // === 1️⃣ Update month column (overall_total) ===
                        $currentMonthValue = $expenses->{$monthName} ?? 0.00;
                        $expenses->{$monthName} = $currentMonthValue + ($creditor->overall_total ?? 0.00);

                        // === 2️⃣ Update total_mooe column ===
                        $currentTotalMooe = $expenses->total_mooe ?? 0.00;
                        $expenses->total_mooe = $currentTotalMooe + ($creditor->total_mooe ?? 0.00);

                        // === 3️⃣ Update total_co column ===
                        $currentTotalCo = $expenses->total_co ?? 0.00;
                        $expenses->total_co = $currentTotalCo + ($creditor->total_co ?? 0.00);

                        $expenses->save();
                    }
                }
            }

            UserLogs::create([
                'user_id' => Auth::id(),
                'action' => 'Added Creditor Record',
                'description' => "User " . Auth::user()->first_name . " " . Auth::user()->last_name . " added a new creditor record.",
            ]);
    
            DB::commit();
    
            return back()->with('success', 'Creditor record successfully added.');
        } catch (\Exception $e) {
            DB::rollBack();
            return back()->with('error', 'Failed to add creditor record: ' . $e->getMessage());
        }
    }
}
