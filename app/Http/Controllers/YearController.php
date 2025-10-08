<?php

namespace App\Http\Controllers;

use App\Models\Year;
use Illuminate\Http\Request;
use Inertia\Inertia;

class YearController extends Controller
{
    // display dashboard
    public function display() {
        // get only id and campus columns from the campuses table
        $years = Year::select('id', 'year')
            ->orderBy('created_at', 'desc') // order by latest to oldest
            ->get();


        return Inertia::render('Year/YearIndex', [
            'years' => $years,
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'year' => [
                'required',
                'digits:4',        // must have exactly 4 digits
                'integer',
                'min:1900',        // must be >= 1900
                'max:' . date('Y'), // must not exceed the current year
            ],
        ]);        

        try {

            // Save proposal record
            $year = Year::create([
                'year' => $validated['year'],
            ]);

            return redirect()
            ->route('years.display')
            ->with('success', 'Year added successfully.');

        } catch (\Exception $e) {
            return redirect()
                ->route('years.display')
                ->with('error', 'Failed to add year. Please try again.');
        }
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'year' => [
                'required',
                'digits:4',        // must have exactly 4 digits
                'integer',
                'min:1900',        // must be >= 1900
                'max:' . date('Y'), // must not exceed the current year
            ],
        ]);        

        try {

            $enterprise = Year::findOrFail($id);

            $enterprise->update([
                'year' => $validated['year'],
            ]);

            return redirect()
            ->route('years.display')
            ->with('success', 'Year updated successfully.');

        } catch (\Exception $e) {
            return redirect()
                ->route('years.display')
                ->with('error', 'Failed to updated year. Please try again.');
        }
    }
}
