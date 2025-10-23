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
        Schema::create('uacs_groups', function (Blueprint $table) {
            $table->id();
            $table->bigInteger('uacs_type_id')->unsigned()->nullable();
            $table->foreign('uacs_type_id')->references('id')->on('uacs_types');
            $table->string('name')->unique();
            $table->string('code', 50)->unique()->nullable();
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('uacs_groups');
    }
};
