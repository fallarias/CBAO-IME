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
        Schema::create('creditor_has_uacs', function (Blueprint $table) {
            $table->id();
            $table->bigInteger('creditor_id')->unsigned()->nullable();
            $table->foreign('creditor_id')->references('id')->on('creditors');
            $table->bigInteger('uacs_id')->unsigned()->nullable();
            $table->foreign('uacs_id')->references('id')->on('uacs');
            $table->decimal('amount', 10, 2)->default(0.00);
            $table->timestamps();
            $table->bigInteger('updated_by')->unsigned()->nullable();
            $table->foreign('updated_by')->references('id')->on('users');
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('creditor_has_uacs');
    }
};
