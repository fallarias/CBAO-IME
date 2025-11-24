<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class IntegratedInventory extends Model
{
    use HasFactory;

    protected $fillable = [
        //'enterprise_id',
        'campus_id',
        'product_name',
        'quantity',
        //'unit',
        'price',
        'category',
        'status',
        'low',
        //'updated_by',
        //'image'
    ];

    protected $table = 'product_inventory';
    /**
     * Get the enterprise that owns the inventory.
     */
    public function enterprise()
    {
        return $this->belongsTo(Enterprise::class);
    }

    /**
     * Get the campus that owns the inventory.
     * (Optional: only if you have a Campus model)
     */
    public function campus()
    {
        return $this->belongsTo(Campus::class);
    }

    public function updatedByUser()
    {
        return $this->belongsTo(User::class, 'updated_by');
    }
}
