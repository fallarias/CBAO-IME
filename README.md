Added folder js

- Integrate_Inventory 

Added models and controller

- Transaction.php
- IntegratedInventory.php
- IntegratedInventoryController.php

Added migrations

- product_inventory (same table design as inventory)
- transaction

Added code on web.php

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

