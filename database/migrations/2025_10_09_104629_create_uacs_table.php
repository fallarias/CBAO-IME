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
        Schema::create('uacs', function (Blueprint $table) {
            $table->id();
            $table->bigInteger('uacs_group_id')->unsigned()->nullable();
            $table->foreign('uacs_group_id')->references('id')->on('uacs_groups');
            $table->string('uacs_code')->unique();
            $table->string('object_code');
            $table->string('sub_object_code')->nullable();
            $table->text('description')->nullable();
            $table->enum('uacs_status', ['Active', 'Inactive'])->default('Active');
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('uacs');
    }
};
