<?php

use App\Http\Controllers\AccountController;
use App\Http\Controllers\BatchController;
use App\Http\Controllers\CampusController;
use App\Http\Controllers\EnterpriseController;
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
    });

    Route::controller(CampusController::class)->group(function(){
        Route::get('/campuses', 'display')->name('campuses.display');
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
});

require __DIR__.'/auth.php';
