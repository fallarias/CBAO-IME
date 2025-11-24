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
        Schema::create('product_inventory', function (Blueprint $table) {
            $table->id();
            // $table->string('image')->default('product_placeholder.jpg');
            $table->bigInteger('campus_id')->unsigned()->nullable();
            $table->foreign('campus_id')->references('id')->on('campuses');
            // $table->bigInteger('enterprise_id')->unsigned()->nullable();
            // $table->foreign('enterprise_id')->references('id')->on('enterprises');
            $table->string('product_name', 255);
            $table->integer('quantity');
            $table->integer('low');
            $table->decimal('price', 10, 2);
            $table->string('category', 255);
            //$table->enum('unit', ['pc', 'kg', 'm', 'l'])->nullable();
            $table->enum('status', ['Available', 'Not Available'])->default('Available')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('product_inventory');
    }
};
