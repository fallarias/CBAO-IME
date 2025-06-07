<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;

class AccountController extends Controller
{
    // display list of account
    public function display() {
        return Inertia::render('Users/Accounts');
    }
}
