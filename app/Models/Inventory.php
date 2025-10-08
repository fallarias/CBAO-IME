<?php

namespace App\Models;

use Illuminate\Database\Eloquent\SoftDeletes;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Inventory extends Model
{
    use SoftDeletes;

    use HasFactory;

    protected $fillable = [
        'enterprise_id',
        'campus_id',
        'quantity',
        'unit',
        'price',
        'status',
        'updated_by',
        'image'
    ];

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
