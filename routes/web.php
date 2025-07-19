<?php

use App\Http\Controllers\AccountController;
use App\Http\Controllers\ExpenseController;
use App\Http\Controllers\CampusController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\EnterpriseController;
use App\Http\Controllers\IncomeController;
use App\Http\Controllers\InventoryController;
use App\Http\Controllers\ProfileController;
use Illuminate\Foundation\Application;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', function () {
    return Inertia::render('Welcome', [
        'canLogin' => Route::has('login'),
        'canRegister' => Route::has('register'),
        'laravelVersion' => Application::VERSION,
        'phpVersion' => PHP_VERSION,
    ]);
});

Route::get('/dashboard', function () {
    return Inertia::render('Dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');

    Route::controller(AccountController::class)->group(function() {
        Route::get('/accounts', 'display')->name('accounts.display');
        Route::post('/accounts', 'store')->name('accounts.store');
        Route::put('/accounts/{id}', 'update')->name('accounts.update');
        Route::put('/accounts/{id}', 'reset')->name('accounts.reset');
        Route::put('/accounts/{id}', 'change_status')->name('accounts.change_status');
    });

    Route::controller(CampusController::class)->group(function(){
        Route::get('/campuses', 'display')->name('campuses.display');
    });

    Route::controller(CategoryController::class)->group(function(){
        Route::get('/categories', 'display')->name('categories.display');
    });

    Route::controller(EnterpriseController::class)->group(function(){
        Route::get('/enterprises', 'display')->name('enterprises.display');
    });

    Route::controller(EnterpriseController::class)->group(function(){
        Route::get('/enterprises/{id}/view', 'view')->name('enterprises.view');
    });

    Route::controller(EnterpriseController::class)->group(function(){
        Route::get('/enterprises/{id}/view/{th_id}/view', 'fetch')->name('enterprises.fetch');
    });

    Route::controller(InventoryController::class)->group(function(){
        Route::get('/inventory', 'display')->name('inventory.display');
    });

    Route::controller(InventoryController::class)->group(function(){
        Route::get('/inventory/{id}/view', 'view')->name('inventory.view');
    });

    Route::controller(IncomeController::class)->group(function(){
        Route::get('/income', 'display')->name('income.display');
    });

    Route::controller(IncomeController::class)->group(function(){
        Route::get('/income/{id}/view', 'view')->name('income.view');
    });

    Route::controller(ExpenseController::class)->group(function(){
        Route::get('/expenses', 'display')->name('expenses.display');
    });

    Route::controller(ExpenseController::class)->group(function(){
        Route::get('/expenses/{id}/view', 'view')->name('expenses.view');
    });
});

require __DIR__.'/auth.php';
