<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Enterprise extends Model
{
    protected $fillable = [
        'campus_id',
        'enterprise',
        'category'
    ];

    // Define relationship
    public function campus()
    {
        return $this->belongsTo(Campus::class, 'campus_id');
    }
}