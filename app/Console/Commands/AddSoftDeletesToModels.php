<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\File;

class AddSoftDeletesToModels extends Command
{
    protected $signature = 'models:add-softdeletes';
    protected $description = 'Automatically add use SoftDeletes; to all Eloquent models';

    public function handle()
    {
        $modelPath = app_path('Models');
        $files = File::allFiles($modelPath);

        foreach ($files as $file) {
            $path = $file->getRealPath();
            $contents = File::get($path);

            // Skip if SoftDeletes is already there
            if (strpos($contents, 'use SoftDeletes;') !== false) {
                $this->info("✅ {$file->getFilename()} already has SoftDeletes.");
                continue;
            }

            // Add the import if not present
            if (strpos($contents, 'use Illuminate\Database\Eloquent\SoftDeletes;') === false) {
                $contents = preg_replace(
                    '/namespace App\\\\Models;/',
                    "namespace App\\Models;\n\nuse Illuminate\\Database\\Eloquent\\SoftDeletes;",
                    $contents
                );
            }

            // Add the trait inside the class
            $contents = preg_replace(
                '/class\s+(\w+)\s+extends\s+Model\s*\{/',
                "class $1 extends Model\n{\n    use SoftDeletes;\n",
                $contents
            );

            File::put($path, $contents);

            $this->info("✨ Added SoftDeletes to: {$file->getFilename()}");
        }

        $this->info("\n✅ All models in /app/Models now use SoftDeletes!");
    }
}
