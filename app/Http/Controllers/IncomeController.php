<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;

class IncomeController extends Controller
{
    // display list of products
    public function display() {
        return Inertia::render('Income/IncomeEnterpriseList');
    }

    // display list of products
    public function view() {
        return Inertia::render('Income/CreditorsList');
    }
}
