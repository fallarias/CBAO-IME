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
        Schema::create('proposals', function (Blueprint $table) {
            $table->id();
            $table->bigInteger('campus_id')->unsigned()->nullable();
            $table->foreign('campus_id')->references('id')->on('campuses');
            $table->bigInteger('user_id')->unsigned()->nullable();
            $table->foreign('user_id')->references('id')->on('users');
            $table->string('proposal_title')->nullable();
            $table->text('proposal_file');
            $table->enum('category', ['Agri-based', 'Non Agri-based'])->nullable();
            $table->enum('status', ['Approved', 'Declined', 'Pending'])->default('Pending');
            $table->bigInteger('evaluated_by')->unsigned()->nullable();
            $table->foreign('evaluated_by')->references('id')->on('users');
            $table->timestamp('evaluated_at')->nullable();
            $table->timestamps();
            $table->bigInteger('updated_by')->unsigned()->nullable();
            $table->foreign('updated_by')->references('id')->on('users');
            $table->timestamp('updated_at')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('proposals');
    }
};
