<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('transaction', function (Blueprint $table) {
            $table->id();
            $table->bigInteger('campus_id')->unsigned()->nullable();
            $table->foreign('campus_id')->references('id')->on('campuses');
            $table->bigInteger('product_id')->unsigned()->nullable();
            $table->foreign('product_id')->references('id')->on('product_inventory');
            $table->integer('quantity');
            $table->string('category', 255);
            $table->string('name', 255)->nullable();
            $table->string('id_number', 255)->nullable();
            $table->timestamp('date_purchase')->nullable();
            $table->enum('status', ['paid', 'unpaid', 'cancelled'])->nullable();
            $table->timestamp('date_paid')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('transaction');
    }
};
