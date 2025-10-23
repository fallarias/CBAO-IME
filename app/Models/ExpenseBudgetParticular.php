<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ExpenseBudgetParticular extends Model
{
    protected $fillable = [
        'expense_id',
        'particular_name',
        'amount',
        'updated_by',
    ];
}
