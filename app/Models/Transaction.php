<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Transaction extends Model
{
     use HasFactory;

    protected $fillable = [
        'product_id',
        'campus_id',
        'name',
        'quantity',
        'category',
        'status',
        'id_number',
        'date_paid',
        'date_purchase',
    ];

    protected $table = 'transaction';

    public function product()
    {
    return $this->belongsTo(IntegratedInventory::class, 'product_id', 'id');
    }

    public function campus()
    {
        return $this->belongsTo(Campus::class);
    }
}
