<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;

class DashboardController extends Controller
{
    // display dashboard
    public function display() {
        // get only id and campus columns from the campuses table
        $campuses = \App\Models\Campus::select('id', 'campus')->get();

        return Inertia::render('Dashboard', [
            'campuses' => $campuses,
        ]);
    }
}
