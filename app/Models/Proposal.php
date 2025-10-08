<?php

namespace App\Models;

use Illuminate\Database\Eloquent\SoftDeletes;

use Illuminate\Database\Eloquent\Model;

class Proposal extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'campus_id',
        'user_id',
        'proposal_title',
        'proposal_file',
        'status',
    ];

    protected $casts = [
        'evaluated_at' => 'datetime',
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

    // Relationship to ProposalRemarks
    public function remarks()
    {
        return $this->hasMany(ProposalRemark::class);
    }

    public function evaluator()
    {
        return $this->belongsTo(User::class, 'evaluated_by');
    }
}
