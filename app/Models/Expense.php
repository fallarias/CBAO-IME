<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Expense extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'year_id',
        'campus_id',
        'enterprise_id',
        'budgeted_amount',
        'january',
        'february',
        'march',
        'april',
        'may',
        'june',
        'july',
        'august',
        'september',
        'october',
        'november',
        'december',
        'total_mooe',
        'total_co',
        'updated_by'
    ];

    // App\Models\Expense.php
    public function budgetParticulars()
    {
        return $this->hasMany(ExpenseBudgetParticular::class, 'expense_id');
    }

    public function campus()
    {
        return $this->belongsTo(Campus::class, 'campus_id');
    }

    public function enterprise()
    {
        return $this->belongsTo(Enterprise::class, 'enterprise_id');
    }

    public function year()
    {
        return $this->belongsTo(Year::class, 'year_id');
    }
}
