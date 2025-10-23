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
        Schema::create('creditors', function (Blueprint $table) {
            $table->id();
            $table->bigInteger('expenses_id')->unsigned()->nullable();
            $table->foreign('expenses_id')->references('id')->on('expenses');
            $table->string('creditor_name')->nullable();
            $table->date('reference_date')->nullable();
            $table->string('reference_serial_number')->nullable();
            $table->decimal('utilization', 10, 2)->nullable()->default(0);
            $table->decimal('disbursements', 10, 2)->nullable()->default(0);
            $table->decimal('uu_due_and_demandable', 10, 2)->nullable()->default(0);
            $table->decimal('uu_not_yet_due_and_demandable', 10, 2)->nullable()->default(0);
            $table->string('check_number')->nullable();
            $table->date('check_date')->nullable();
            $table->text('particulars')->nullable();
            $table->decimal('total_mooe', 10, 2)->nullable()->default(0);
            $table->decimal('total_co', 10, 2)->nullable()->default(0);
            $table->decimal('overall_total', 10, 2)->nullable()->default(0);
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
        Schema::dropIfExists('creditors');
    }
};
