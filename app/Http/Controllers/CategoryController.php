<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;

class CategoryController extends Controller
{
    // display list of batches
    public function display() {
        // $campuses = Campus::select('id', 'campus')->get()->map(function ($campus, $index) {
        //     return [
        //         'number' => $index + 1,
        //         'id' => $campus->id,
        //         'campus' => $campus->campus,
        //     ];
        // });

        // return Inertia::render('Campuses/CampusList', [
        //     'campuses' => $campuses,
        // ]);

        return Inertia::render('Categories/CategoriesList');
    }
}
