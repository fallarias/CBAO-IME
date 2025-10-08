<?php

namespace App\Http\Controllers;

use App\Models\Campus;
use App\Models\Enterprise;
use App\Models\Income;
use App\Models\UserLogs;
use App\Models\Year;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;

class IncomeController extends Controller
{
    // display list of income
    public function display()
    {
        $user = Auth::user();
        // get all campuses
        $campuses = Campus::select('id', 'campus')->get();

        $query = Income::query()
            ->with([
                'campus:id,campus', // get campus name
                'updatedBy:id,first_name,last_name' // get updated_by name
            ])
            ->select([
                'id',
                'year_id',
                'campus_id',
                'enterprise_id',
                'continuing',
                'january',
                'february',
                'march',
                'april',
                'may',
                'june',
                'july',
                'august',
                'september',
                'october',
                'november',
                'december',
                'current',
                'created_at',
                'updated_at',
                'updated_by',
            ])
            ->orderBy('created_at', 'desc');

        // 🔒 Filter if user role is "User"
        if ($user->role === 'User') {
            $query->where('campus_id', $user->campus_id);
        }

        // 🧾 Fetch data
        $incomes = $query->get()->map(function ($item, $key) {
            
            return [
                'number' => $key + 1,
                'id' => $item->id,
                'year_id' => $item->year_id,
                'campus_id' => $item->campus_id,
                'campus' => $item->campus->campus ?? 'N/A',
                'enterprise_id' => $item->enterprise_id,
                'enterprise' => $item->enterprise->enterprise ?? 'N/A',
                'continuing' => $item->continuing,
                'january' => $item->january,
                'february' => $item->february,
                'march' => $item->march,
                'april' => $item->april,
                'may' => $item->may,
                'june' => $item->june,
                'july' => $item->july,
                'august' => $item->august,
                'september' => $item->september,
                'october' => $item->october,
                'november' => $item->november,
                'december' => $item->december,
                'current' => $item->current,
                'date' => optional(
                    $item->updated_at ?? $item->created_at
                )?->timezone('Asia/Manila')->format('Y-m-d \a\t h:i A') ?? '—',                
                // 'date' => $item->created_at,
                'updated_by' => $item->updatedBy
                    ? $item->updatedBy->first_name . ' ' . $item->updatedBy->last_name
                    : 'Unknown',
            ];
        });

        // 📅 Also get years (latest to oldest)
        $years = Year::select('id', 'year')
            ->orderBy('year', 'desc')
            ->get();

        $enterprisesQuery = Enterprise::select('id', 'enterprise');

        // 🧠 If user is "User" → only enterprises from their campus
        if ($user->role === 'User') {
            $enterprisesQuery->where('campus_id', $user->campus_id);
        }
    
        $enterprises = $enterprisesQuery
            ->orderBy('enterprise', 'asc')
            ->get();

        return Inertia::render('Income/IncomeEnterpriseList', [
            'years' => $years,
            'incomes' => $incomes,
            'campuses' => $campuses,
            'enterprises' => $enterprises
        ]);
    }

    // add
    public function store() {
        return Inertia::render('Income/IncomeEnterpriseList');
    }

    // update
    public function update(Request $request, $id) {
        
        try {
            // 🧩 Validate input (adjust rules based on your income table columns)
            $validated = $request->validate([
                'enterprise_id' => 'required|exists:enterprises,id',
                'continuing' => 'nullable|numeric|min:0',
                'january' => 'nullable|numeric|min:0',
                'february' => 'nullable|numeric|min:0',
                'march' => 'nullable|numeric|min:0',
                'april' => 'nullable|numeric|min:0',
                'may' => 'nullable|numeric|min:0',
                'june' => 'nullable|numeric|min:0',
                'july' => 'nullable|numeric|min:0',
                'august' => 'nullable|numeric|min:0',
                'september' => 'nullable|numeric|min:0',
                'october' => 'nullable|numeric|min:0',
                'november' => 'nullable|numeric|min:0',
                'december' => 'nullable|numeric|min:0',
                'current' => 'nullable|numeric|min:0',
            ]);
    
            // Find the record
            $income = Income::findOrFail($id);
    
            // $income->update($validated);
            $income->continuing = $validated['continuing'] ?? $income->continuing;
            $income->january = $validated['january'] ?? $income->january;
            $income->february = $validated['february'] ?? $income->february;
            $income->march = $validated['march'] ?? $income->march;
            $income->april = $validated['april'] ?? $income->april;
            $income->may = $validated['may'] ?? $income->may;
            $income->june = $validated['june'] ?? $income->june;
            $income->july = $validated['july'] ?? $income->july;
            $income->august = $validated['august'] ?? $income->august;
            $income->september = $validated['september'] ?? $income->september;
            $income->october = $validated['october'] ?? $income->october;
            $income->november = $validated['november'] ?? $income->november;
            $income->december = $validated['december'] ?? $income->december;
            $income->current = $validated['current'] ?? $income->current;
            $income->updated_by = Auth::user()->id;
            $income->save();

            UserLogs::create([
                'user_id' => Auth::user()->id,
                'action' => 'Updated Income Record',
                'description' => "User " . Auth::user()->first_name . " " . Auth::user()->last_name . " updated income record for enterprise {$income->enterprise->enterprise}.",
            ]);

            // Success flash message
            return redirect()->back()->with('success', 'Income record updated successfully.');
    
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            // ⚠️ Record not found
            return redirect()->back()->with('error', 'Income record not found.');
        } catch (\Throwable $e) {
    
            return redirect()->back()->with('error', 'An unexpected error occurred while updating the income record.');
        }
    }

    // import enterprises
    public function import(Request $request)
    {
        $validated = $request->validate([
            'campus_id' => 'required|exists:campuses,id',
        ]);

        $user = Auth::user();

        try {
            // 🧾 Get all existing enterprise IDs in incomes table
            $existingIncomeEnterpriseIds = Income::pluck('enterprise_id')->toArray();

            // 🏢 Base query: Enterprises in the selected campus and not yet in incomes
            $query = Enterprise::select('id', 'enterprise')
                ->where('campus_id', $validated['campus_id'])
                ->whereNotIn('id', $existingIncomeEnterpriseIds);

            // 🔒 If user role is "User", restrict to their campus
            if ($user->role === 'User' && $user->campus_id != $validated['campus_id']) {
                return redirect()->back()->with('error', 'Unauthorized campus selection.');
            }

            // ✅ Retrieve enterprises (alphabetically)
            $income_enterprises = $query->orderBy('enterprise', 'asc')->get();

            if ($income_enterprises->isEmpty()) {
                return redirect()->back()->with('info', 'No new enterprises. All enterprises have already been imported.');
            }            

            // 🗓️ Get current year record
            $currentYear = Year::where('year', date('Y'))->first();

            if (!$currentYear) {
                return redirect()->back()->with('error', 'Current year not found in database.');
            }

            // 🧩 Insert each enterprise into incomes table
            foreach ($income_enterprises as $enterprise) {
                Income::create([
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
                'description' => "User {$user->first_name} {$user->last_name} imported enterprises for campus {$campusName}.",
            ]);

            return redirect()->back()->with([
                'success' => 'Business enterprises imported and added to incomes successfully.'
            ]);
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Failed to import enterprises: ' . $e->getMessage());
        }
    }


    // display list of products
    public function view() {
        return Inertia::render('Income/CreditorsList');
    }
}
