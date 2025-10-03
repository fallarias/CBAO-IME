<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class UacsController extends Controller
{
    // display uacs codes
    public function display() {
        return inertia('Uacs/Index');
    }
}