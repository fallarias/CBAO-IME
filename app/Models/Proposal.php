<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Proposal extends Model
{
    protected $fillable = [
        'campus_id',
        'user_id',
        'proposal_title',
        'proposal_file',
        'status',
    ];

    // Relationship to Campus
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
