<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        // Get all table names from INFORMATION_SCHEMA
        $tables = DB::select('SHOW TABLES');
        $database = DB::getDatabaseName();
        $key = 'Tables_in_' . $database;

        foreach ($tables as $tableObj) {
            $table = $tableObj->$key;

            // Skip migrations table
            if ($table === 'migrations') {
                continue;
            }

            // Add deleted_at if not already there
            if (!Schema::hasColumn($table, 'deleted_at')) {
                Schema::table($table, function (Blueprint $table) {
                    $table->softDeletes();
                });
            }
        }
    }

    public function down(): void
    {
        $tables = DB::select('SHOW TABLES');
        $database = DB::getDatabaseName();
        $key = 'Tables_in_' . $database;

        foreach ($tables as $tableObj) {
            $table = $tableObj->$key;

            if ($table === 'migrations') {
                continue;
            }

            // Drop deleted_at if it exists
            if (Schema::hasColumn($table, 'deleted_at')) {
                Schema::table($table, function (Blueprint $table) {
                    $table->dropSoftDeletes();
                });
            }
        }
    }
};
