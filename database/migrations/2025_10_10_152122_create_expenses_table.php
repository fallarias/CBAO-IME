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
        Schema::create('expenses', function (Blueprint $table) {
            $table->id();
            $table->bigInteger('year_id')->unsigned()->nullable();
            $table->foreign('year_id')->references('id')->on('years');
            $table->bigInteger('campus_id')->unsigned()->nullable();
            $table->foreign('campus_id')->references('id')->on('campuses');
            $table->bigInteger('enterprise_id')->unsigned()->nullable();
            $table->foreign('enterprise_id')->references('id')->on('enterprises');
            $table->decimal('budgeted_amount', 10, 2)->nullable()->default(0);
            $table->decimal('january', 10, 2)->nullable()->default(0);
            $table->decimal('february', 10, 2)->nullable()->default(0);
            $table->decimal('march', 10, 2)->nullable()->default(0);
            $table->decimal('april', 10, 2)->nullable()->default(0);
            $table->decimal('may', 10, 2)->nullable()->default(0);
            $table->decimal('june', 10, 2)->nullable()->default(0);
            $table->decimal('july', 10, 2)->nullable()->default(0);
            $table->decimal('august', 10, 2)->nullable()->default(0);
            $table->decimal('september', 10, 2)->nullable()->default(0);
            $table->decimal('october', 10, 2)->nullable()->default(0);
            $table->decimal('november', 10, 2)->nullable()->default(0);
            $table->decimal('december', 10, 2)->nullable()->default(0);
            $table->decimal('total_mooe', 10, 2)->nullable()->default(0);
            $table->decimal('total_co', 10, 2)->nullable()->default(0);
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
        Schema::dropIfExists('expenses');
    }
};
