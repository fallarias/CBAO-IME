<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;

class InventoryController extends Controller
{
    // display list of products
    public function display() {
        return Inertia::render('Inventory/InventoryList');
    }

    // display list of products
    public function view() {
        return Inertia::render('Inventory/InventorySalesPerProduct');
    }
}
