<?php

use App\Http\Controllers\AccountController;
use App\Http\Controllers\ExpenseController;
use App\Http\Controllers\CampusController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\EnterpriseController;
use App\Http\Controllers\IncomeController;
use App\Http\Controllers\InventoryController;
use App\Http\Controllers\IntegratedInventoryController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\ProposalController;
use App\Http\Controllers\Auth\AuthenticatedSessionController;
use App\Http\Controllers\CreditorController;
use App\Http\Controllers\UacsController;
use App\Http\Controllers\YearController;
use App\Models\Proposal;
use Illuminate\Support\Facades\Auth;
use Illuminate\Foundation\Application;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;
use Illuminate\Support\Facades\Storage;

// Route::get('/', function () {
//     return Inertia::render('Welcome', [
//         'canLogin' => Route::has('login'),
//         'canRegister' => Route::has('register'),
//         'laravelVersion' => Application::VERSION,
//         'phpVersion' => PHP_VERSION,
//     ]);
// });

Route::get('/', function () {
    if (Auth::check()) {
        return redirect('/dashboard');
    }

    return redirect('/login');
});

Route::get('/dashboard', [DashboardController::class, 'display'])->middleware(['auth', 'verified'])->name('dashboard');

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

    Route::controller(YearController::class)->group(function(){
        Route::get('/years', 'display')->name('years.display');
        Route::post('/years', 'store')->name('years.store');
        Route::put('/years/{id}', 'update')->name('years.update');
    });

    Route::controller(EnterpriseController::class)->group(function(){
        Route::get('/enterprises', 'display')->name('enterprises.display');
        Route::post('/enterprises', 'store')->name('enterprises.store');
        Route::put('/enterprises/{id}', 'update')->name('enterprises.update');
    });

    Route::controller(EnterpriseController::class)->group(function(){
        Route::get('/enterprises/{id}/view', 'view')->name('enterprises.view');
    });

    Route::controller(EnterpriseController::class)->group(function(){
        Route::get('/enterprises/{id}/view/{th_id}/view', 'fetch')->name('enterprises.fetch');
    });

    Route::controller(InventoryController::class)->group(function(){
        Route::get('/inventory', 'display')->name('inventory.display');
        Route::post('/inventory', 'store')->name('inventory.store');
        Route::put('/inventory/{id}', 'update')->name('inventory.update');
        Route::post('/inventory/import', 'import')->name('inventory.import');
    });

    Route::controller(InventoryController::class)->group(function(){
        Route::get('/inventory/{id}/view', 'view')->name('inventory.view');
    });

    Route::controller(IntegratedInventoryController::class)->group(function(){
        //PRODUCT INVENTORY
        Route::get('/integrated/inventory', 'display')->name('integrated_inventory.display');
        Route::post('/integrated/inventory', 'store')->name('integrated_inventory.store');
        Route::put('/integrated/inventory/{id}', 'update')->name('integrated_inventory.update');
        Route::post('/integrated/inventory/import', 'import')->name('integrated_inventory.import');
        //SALES REPORTS
        Route::get('/integrated/inventory/sales', 'display_sales')->name('integrated_inventory.display_sales');
        Route::get('/integrated/inventory/sales-per-product', 'salesPerProduct');
        Route::get('/integrated/inventory/monthly-sales', 'monthlySales');
        //TRANSACTION LIST
        Route::get('/integrated/inventory/transaction', 'display_transaction')->name('integrated_inventory.display_transaction');
        Route::post('/integrated/inventory/transaction/purchase', 'transaction_store')->name('transaction.store');
        Route::put('/integrated/inventory/transaction/status', 'status_update')->name('integrated_inventory.status_update');
        Route::post('/integrated/inventory/transaction/reservation', 'transaction_reservation')->name('reservation.store');
    });

    Route::controller(IntegratedInventoryController::class)->group(function(){
        Route::get('/integrated/inventory/{id}/view', 'view')->name('integrated_inventory.view');
    });

    Route::controller(IncomeController::class)->group(function(){
        Route::get('/income', 'display')->name('income.display');
        Route::post('/income', 'store')->name('income.store');
        Route::put('/income/{id}', 'update')->name('income.update');
        Route::post('/income/import', 'import')->name('income.import');
    });

    Route::controller(IncomeController::class)->group(function(){
        Route::get('/income/{id}/view', 'view')->name('income.view');
    });

    Route::controller(ExpenseController::class)->group(function(){
        Route::get('/expenses', 'display')->name('expenses.display');
        Route::post('/expenses/import', 'import')->name('expenses.import');
        Route::put('/expenses/{id}', 'update')->name('expenses.update');
        Route::delete('/expenses/{id}', 'delete')->name('expenses.delete');
        Route::get('/expenses/{id}/view', 'view')->name('expenses.view');
    });

    Route::controller(CreditorController::class)->group(function(){
        Route::get('/expenses/{id}/creditors', 'display')->name('creditors.display');
        Route::post('/expenses/{id}/creditors', 'store')->name('creditors.store');
    });

    Route::controller(ProposalController::class)->group(function(){
        Route::get('/proposals', 'display')->name('proposal.display');
        Route::post('/proposals', 'store')->name('proposal.store');
        Route::post('/proposals/{id}', 'update')->name('proposal.update');
        Route::put('/proposals/{id}/evaluate', 'evaluate')->name('proposal.evaluate');
        Route::post('/proposals/{id}/remark', 'add_remark')->name('proposal.add_remark');
    });

    Route::middleware(['auth'])->get('/proposals/view/{filename}', function ($filename) {
        $path = 'proposals/' . $filename;

        // Check if file exists in private storage
        if (!Storage::disk('local')->exists($path)) {
            abort(404, 'File not found');
        }

        $user = Auth::user();

        // Find the proposal by file path
        $proposal = Proposal::where('proposal_file', 'proposals/' . $filename)->first();

        if (!$proposal) {
            abort(404, 'Proposal record not found');
        }

        // Authorization check:
        // - Admin can view all
        // - User can only view their own
        if ($user->role !== 'Admin' && $proposal->user_id !== $user->id) {
            abort(403, 'Unauthorized access to this file');
        }

        // Stream the PDF securely
        return response()->file(
            Storage::disk('local')->path($path),
            [
                'Content-Type' => 'application/pdf',
                'Content-Disposition' => 'inline; filename="' . $filename . '"'
            ]
        );
    })->where('filename', '.*')->name('proposals.secure-view');

    Route::controller(UacsController::class)->group(function(){
        Route::get('/uacs', 'display')->name('uacs.display');
        Route::post('/uacs', 'store')->name('uacs.store');
        Route::put('/uacs/{id}', 'update')->name('uacs.update');
    });
});

require __DIR__.'/auth.php';
