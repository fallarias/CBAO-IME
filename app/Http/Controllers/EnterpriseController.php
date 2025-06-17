<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;

class EnterpriseController extends Controller
{
    // display list of enterprises
    public function display() {
        return Inertia::render('Enterprises/EnterpriseList');
    }

    // display list of account ledgers
    public function view() {
        return Inertia::render('Enterprises/AccountLedgers');
    }

    // display list of transaction history of clients
    public function fetch() {
        return Inertia::render('Enterprises/ClientTransactionHistory');
    }
}
