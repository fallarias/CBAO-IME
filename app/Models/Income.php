<?php

namespace App\Models;

use Illuminate\Database\Eloquent\SoftDeletes;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Income extends Model
{
    use SoftDeletes;

    use HasFactory;

    protected $table = 'incomes';

    /**
     * The attributes that are mass assignable.
     */
    protected $fillable = [
        'year_id',
        'enterprise_id',
        'campus_id',
        'continuing',
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
        'current',
        'updated_by',
    ];

    /**
     * Relationships
     */

    // 🏫 Get the campus (name, etc.)
    public function campus()
    {
        return $this->belongsTo(Campus::class, 'campus_id');
    }

    // App\Models\Income.php
    public function enterprise()
    {
        return $this->belongsTo(Enterprise::class, 'enterprise_id');
    }


    // 👤 Get the user who last updated this record
    public function updatedBy()
    {
        return $this->belongsTo(User::class, 'updated_by');
    }
}