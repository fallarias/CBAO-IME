<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;

class ExpenseController extends Controller
{
    // display list of products
    public function display() {
        return Inertia::render('Expenses/ExpensesEnterpriseList');
    }

    // display list of products
    public function view() {
        return Inertia::render('Expenses/CreditorsList');
    }
}
