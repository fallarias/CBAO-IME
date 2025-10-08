<?php

namespace App\Models;

use Illuminate\Database\Eloquent\SoftDeletes;

use Illuminate\Database\Eloquent\Model;

class ProposalRemark extends Model
{
    use SoftDeletes;

    protected $fillable = ['proposal_id', 'user_id', 'remark'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
