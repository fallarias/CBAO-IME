<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;

class BatchController extends Controller
{
    // display list of batches
    public function display() {
        return Inertia::render('Batches/BatchList');
    }
}
