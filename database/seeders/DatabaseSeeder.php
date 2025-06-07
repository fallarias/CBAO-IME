<?php

namespace Database\Seeders;

use App\Models\Campus;
use App\Models\User;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // User::factory(10)->create();

        $campuses = [
            'Echague',
            'Cabagan',
            'Cauayan',
            'Ilagan',
            'Roxas',
            'Angadanan',
            'Jones',
            'San Mateo',
            'San Mariano'
        ];

        foreach ($campuses as $campus) {
            Campus::create(['campus' => $campus]);
        }

        User::factory()->create([
            'name' => 'CYRA CACHO',
            'designation' => 'System Administrator',
            'email' => 'cyra@isu.edu.ph',
            'campus_id' => 2,
            'role' => "Admin",
        ]);

    }
}
