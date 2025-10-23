<?php

namespace App\Models;

use Illuminate\Database\Eloquent\SoftDeletes;

use Illuminate\Database\Eloquent\Model;

class Uacs extends Model
{
    use SoftDeletes;

    protected $fillable = ['uacs_group_id', 'uacs_code', 'object_code', 'sub_object_code', 'description', 'uacs_status'];

    public function group()
    {
        return $this->belongsTo(UacsGroup::class);
    }

    public function groupData()
    {
        return $this->belongsTo(UacsGroup::class, 'uacs_group_id')
            ->select('id', 'uacs_type_id', 'name')
            ->with('typeData');
    }
}
