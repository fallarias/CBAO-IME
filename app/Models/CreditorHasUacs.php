<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class CreditorHasUacs extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'creditor_id',
        'uacs_id',
        'amount',
        'updated_by'
    ];
}
