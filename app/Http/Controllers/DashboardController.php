<?php

namespace App\Http\Controllers;

use App\Models\Campus;
use App\Models\Income;
use App\Models\Year;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    // display dashboard
    public function display()
{
    $campuses = Campus::select('id', 'campus')->get();
    $years = Year::all();
    $overview = [];

    $months = [
        'january', 'february', 'march', 'april', 'may', 'june',
        'july', 'august', 'september', 'october', 'november', 'december'
    ];

    foreach ($years as $year) {
        $incomes = Income::where('year_id', $year->id)->get();
        $grouped = $incomes->groupBy('campus_id');

        $yearData = $campuses->map(function ($campus) use ($grouped, $months, $year) {
            $records = $grouped->get($campus->id, collect());

            // ✅ Monthly totals
            $totals = [];
            foreach ($months as $month) {
                $totals[$month] = $records->sum($month) ?? 0;
            }

            // ✅ Enterprises and Inventories count
            $enterprises_total = \App\Models\Enterprise::where('campus_id', $campus->id)->count() ?? 0;
            $inventories_total = \App\Models\Inventory::where('campus_id', $campus->id)->count() ?? 0;

            // ✅ Initialize top_five and lowest_five
            $top_five = [];
            $lowest_five = [];

            // ✅ For each month — get top and lowest 5 income-generating enterprises
            foreach ($months as $month) {
                // 🔹 Top 5 enterprises for this month
                $monthlyTop = \App\Models\Income::where('year_id', $year->id)
                    ->where('campus_id', $campus->id)
                    ->select('enterprise_id', \DB::raw("SUM($month) as total"))
                    ->groupBy('enterprise_id')
                    ->orderByDesc('total')
                    ->take(5)
                    ->get()
                    ->map(function ($item) {
                        $enterprise = \App\Models\Enterprise::find($item->enterprise_id);
                        return [
                            'enterprise_id' => $item->enterprise_id,
                            'enterprise' => $enterprise?->enterprise ?? 'N/A',
                            'amount' => (float) $item->total,
                        ];
                    });

                // 🔹 Lowest 5 enterprises for this month
                $monthlyLowest = \App\Models\Income::where('year_id', $year->id)
                    ->where('campus_id', $campus->id)
                    ->select('enterprise_id', \DB::raw("SUM($month) as total"))
                    ->groupBy('enterprise_id')
                    ->orderBy('total', 'asc')
                    ->take(5)
                    ->get()
                    ->map(function ($item) {
                        $enterprise = \App\Models\Enterprise::find($item->enterprise_id);
                        return [
                            'enterprise_id' => $item->enterprise_id,
                            'enterprise' => $enterprise?->enterprise ?? 'N/A',
                            'amount' => (float) $item->total,
                        ];
                    });

                $top_five[$month] = $monthlyTop;
                $lowest_five[$month] = $monthlyLowest;
            }

            // ✅ Overall (sum of all months)
            $overallTop = \App\Models\Income::where('year_id', $year->id)
                ->where('campus_id', $campus->id)
                ->select(
                    'enterprise_id',
                    \DB::raw('SUM(january + february + march + april + may + june + july + august + september + october + november + december) as total')
                )
                ->groupBy('enterprise_id')
                ->orderByDesc('total')
                ->take(5)
                ->get()
                ->map(function ($item) {
                    $enterprise = \App\Models\Enterprise::find($item->enterprise_id);
                    return [
                        'enterprise_id' => $item->enterprise_id,
                        'enterprise' => $enterprise?->enterprise ?? 'N/A',
                        'amount' => (float) $item->total,
                    ];
                });

            $overallLowest = \App\Models\Income::where('year_id', $year->id)
                ->where('campus_id', $campus->id)
                ->select(
                    'enterprise_id',
                    \DB::raw('SUM(january + february + march + april + may + june + july + august + september + october + november + december) as total')
                )
                ->groupBy('enterprise_id')
                ->orderBy('total', 'asc')
                ->take(5)
                ->get()
                ->map(function ($item) {
                    $enterprise = \App\Models\Enterprise::find($item->enterprise_id);
                    return [
                        'enterprise_id' => $item->enterprise_id,
                        'enterprise' => $enterprise?->enterprise ?? 'N/A',
                        'amount' => (float) $item->total,
                    ];
                });

            $top_five['overall'] = $overallTop;
            $lowest_five['overall'] = $overallLowest;

            // ✅ Return structured data for this campus
            return [
                'campus_id' => $campus->id,
                'campus_name' => $campus->campus,
                ...$totals,
                'enterprises_total' => $enterprises_total,
                'inventories_total' => $inventories_total,
                'top_five' => $top_five,
                'lowest_five' => $lowest_five,
            ];
        });

        $overview[$year->year] = $yearData->values();
    }

    return Inertia::render('Dashboard', [
        'incomes' => $overview,
        'campuses' => $campuses,
        'years' => $years,
    ]);
}


}
