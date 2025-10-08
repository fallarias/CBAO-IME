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
        Schema::create('incomes', function (Blueprint $table) {
            $table->id();
            $table->bigInteger('year_id')->unsigned()->nullable();
            $table->foreign('year_id')->references('id')->on('years');
            $table->bigInteger('campus_id')->unsigned()->nullable();
            $table->foreign('campus_id')->references('id')->on('campuses');
            $table->bigInteger('enterprise_id')->unsigned()->nullable();
            $table->foreign('enterprise_id')->references('id')->on('enterprises');
            $table->decimal('continuing', 10, 2)->nullable();
            $table->decimal('january', 10, 2)->nullable();
            $table->decimal('february', 10, 2)->nullable();
            $table->decimal('march', 10, 2)->nullable();
            $table->decimal('april', 10, 2)->nullable();
            $table->decimal('may', 10, 2)->nullable();
            $table->decimal('june', 10, 2)->nullable();
            $table->decimal('july', 10, 2)->nullable();
            $table->decimal('august', 10, 2)->nullable();
            $table->decimal('september', 10, 2)->nullable();
            $table->decimal('october', 10, 2)->nullable();
            $table->decimal('november', 10, 2)->nullable();
            $table->decimal('december', 10, 2)->nullable();
            $table->timestamps();
            $table->bigInteger('updated_by')->unsigned()->nullable();
            $table->foreign('updated_by')->references('id')->on('users');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('income');
    }
};
