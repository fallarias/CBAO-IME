<?php

namespace App\Http\Controllers;

use App\Models\Campus;
use App\Models\Creditor;
use App\Models\Enterprise;
use App\Models\Expense;
use App\Models\ExpenseBudgetParticular;
use App\Models\User;
use App\Models\UserLogs;
use App\Models\Year;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class ExpenseController extends Controller
{
    // display list of products
    public function display()
    {
        $campuses = Campus::select('id', 'campus')->get();
        $years = Year::select('id', 'year')->get();

        $expenses = Expense::select(
            'expenses.id',
            'expenses.year_id',
            'expenses.campus_id',
            'expenses.enterprise_id',
            DB::raw('COALESCE(expenses.budgeted_amount, 0.00) as budgeted_amount'),
            DB::raw('COALESCE(expenses.january, 0.00) as january'),
            DB::raw('COALESCE(expenses.february, 0.00) as february'),
            DB::raw('COALESCE(expenses.march, 0.00) as march'),
            DB::raw('COALESCE(expenses.april, 0.00) as april'),
            DB::raw('COALESCE(expenses.may, 0.00) as may'),
            DB::raw('COALESCE(expenses.june, 0.00) as june'),
            DB::raw('COALESCE(expenses.july, 0.00) as july'),
            DB::raw('COALESCE(expenses.august, 0.00) as august'),
            DB::raw('COALESCE(expenses.september, 0.00) as september'),
            DB::raw('COALESCE(expenses.october, 0.00) as october'),
            DB::raw('COALESCE(expenses.november, 0.00) as november'),
            DB::raw('COALESCE(expenses.december, 0.00) as december'),
            DB::raw('COALESCE(expenses.total_mooe, 0.00) as total_mooe'),
            DB::raw('COALESCE(expenses.total_co, 0.00) as total_co'),
            'campuses.campus as campus_name',
            'enterprises.enterprise as enterprise_name',
            DB::raw('(COALESCE(expenses.total_mooe, 0.00) + COALESCE(expenses.total_co, 0.00)) as overall_total')
        )
        ->leftJoin('campuses', 'expenses.campus_id', '=', 'campuses.id')
        ->leftJoin('enterprises', 'expenses.enterprise_id', '=', 'enterprises.id')
        ->with(['budgetParticulars:id,expense_id,particular_name,amount'])
        ->get();

        return Inertia::render('Expenses/ExpensesEnterpriseList', [
            'campuses' => $campuses,
            'years' => $years,
            'expenses' => $expenses,
        ]);
    }

    public function update(Request $request, $id)
    {
        // ✅ Validate incoming data
        $validated = $request->validate([
            'expense_id' => 'required|integer|exists:expenses,id',
            'budgeted_amount' => 'required|numeric|min:0',
            'particulars' => 'required|array|min:1',
            'particulars.*.particular' => 'required|string|max:255',
            'particulars.*.amount' => 'required|numeric|min:0',
        ]);

        DB::beginTransaction();

        try {
            // 🧾 Step 1: Update Expense main data
            $expense = Expense::findOrFail($id);
            $expense->budgeted_amount = $validated['budgeted_amount'];
            $expense->save();

            foreach ($validated['particulars'] as $item) {
                ExpenseBudgetParticular::create([
                    'expense_id' => $expense->id,
                    'particular_name' => $item['particular'],
                    'amount' => $item['amount'],
                ]);
            }

            UserLogs::create([
                'user_id' => Auth::id(),
                'action' => 'Updated Expense and Budgetary Particulars',
                'description' => "User " . Auth::user()->first_name . " " . Auth::user()->last_name . " updated expense ID {$expense->id} with new budgeted amount and particulars.",
            ]);

            DB::commit();

            return back()->with('success', 'Expense and budgetary particulars have been successfully updated.');
        } catch (\Throwable $th) {
            DB::rollBack();
            return back()->with('error', 'An error occurred while updating the expense: ' . $th->getMessage());
        }
    }

    // display list of products
    public function view($id)
    {
        $user = Auth::user();

        // 🧩 Step 1: If user’s role is "User", verify campus
        if ($user->role === 'User') {
            $expense = Expense::select('id', 'campus_id')->findOrFail($id);

            if ($expense->campus_id !== $user->campus_id) {
                // Redirect instead of aborting
                return redirect()
                    ->route('expenses.display')
                    ->with('error', 'Unauthorized access: You can only view expenses from your campus.');
            }
        }

        // 🧾 Step 2: Retrieve creditors and related UACS data
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
        ->with(['uacsData'])
        ->get();

        // 🧩 Step 3: Render Inertia page
        return Inertia::render('Expenses/CreditorsList', [
            'expense_id' => $id,
            'creditors' => $creditors,
        ]);
    }

    // import enterprises
    public function import(Request $request)
    {
        $validated = $request->validate([
            'campus_id' => 'required|exists:campuses,id',
        ]);

        $user = Auth::user();

        try {
            // 🧾 Get all existing enterprise IDs in expenses table
            $existingExpenseEnterpriseIds = Expense::pluck('enterprise_id')->toArray();

            // 🏢 Base query: Enterprises in the selected campus and not yet in expenses
            $query = Enterprise::select('id', 'enterprise')
                ->where('campus_id', $validated['campus_id'])
                ->whereNotIn('id', $existingExpenseEnterpriseIds);

            // 🔒 If user role is "User", restrict to their campus
            if ($user->role === 'User' && $user->campus_id != $validated['campus_id']) {
                return redirect()->back()->with('error', 'Unauthorized campus selection.');
            }

            // ✅ Retrieve enterprises (alphabetically)
            $expenses_enterprises = $query->orderBy('enterprise', 'asc')->get();

            if ($expenses_enterprises->isEmpty()) {
                return redirect()->back()->with('info', 'No new enterprises. All enterprises have already been imported.');
            }            

            // 🗓️ Get current year record
            $currentYear = Year::where('year', date('Y'))->first();

            if (!$currentYear) {
                return redirect()->back()->with('error', 'Current year not found in database.');
            }

            // 🧩 Insert each enterprise into expenses table
            foreach ($expenses_enterprises as $enterprise) {
                Expense::create([
                    'year_id' => $currentYear->id,
                    'campus_id' => $validated['campus_id'],
                    'enterprise_id' => $enterprise->id,
                    'updated_by' => $user->id,
                ]);
            }

            // 🏫 Get campus name
            $campusName = Campus::where('id', $validated['campus_id'])->value('campus');

            // 🧾 Optional user log
            UserLogs::create([
                'user_id' => $user->id,
                'action' => 'Imported Business Enterprises',
                'description' => "User {$user->first_name} {$user->last_name} imported enterprises for campus {$campusName} in Expenses table.",
            ]);

            return redirect()->back()->with([
                'success' => 'Business enterprises imported and added to expenses successfully.'
            ]);
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Failed to import enterprises: ' . $e->getMessage());
        }
    }

    public function delete($id)
    {
        $expense = Expense::find($id);

        if (!$expense) {
            return redirect()->back()->with('error', 'Expense record not found.');
        }

        try {
            $expense->delete();

            // Optional: Log the deletion action
            $user = Auth::user();
            UserLogs::create([
                'user_id' => $user->id,
                'action' => 'Deleted Expense Record',
                'description' => "User {$user->first_name} {$user->last_name} deleted expense record ID {$id}.",
            ]);

            return redirect()->back()->with('success', 'Expense record deleted successfully.');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Failed to delete expense record: ' . $e->getMessage());
        }
    }
}
