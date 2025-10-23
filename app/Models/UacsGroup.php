<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\SoftDeletes;

class UacsGroup extends Model
{
    use HasFactory;
    use SoftDeletes;

    protected $fillable = ['uacs_type_id', 'name', 'code', 'description'];

    public function type()
    {
        return $this->belongsTo(UacsType::class, 'uacs_code_type_id');
    }

    public function codes()
    {
        return $this->hasMany(Uacs::class);
    }

    public function typeData()
    {
        return $this->belongsTo(UacsType::class, 'uacs_type_id')
            ->select('id', 'name');
    }
}
