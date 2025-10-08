<?php

namespace App\Models;

use Illuminate\Database\Eloquent\SoftDeletes;

use Illuminate\Database\Eloquent\Model;

class Enterprise extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'campus_id',
        'user_id',
        'enterprise',
        'category',
        'inventory',
        'updated_by'
    ];

    // Define relationship
    public function campus()
    {
        return $this->belongsTo(Campus::class, 'campus_id');
    }

    // Relationship to User
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}