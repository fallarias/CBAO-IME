<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class Creditor extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'expenses_id',
        'creditor_name',
        'reference_date',
        'reference_serial_number',
        'utilization',
        'disbursements',
        'uu_due_and_demandable',
        'uu_not_yet_due_and_demandable',
        'check_number',
        'check_date',
        'particulars',
        'total_mooe',
        'total_co',
        'overall_total',
        'updated_by'
    ];

    public function creditorUacs(): HasMany
    {
        return $this->hasMany(CreditorHasUacs::class, 'creditor_id');
    }

    public function uacsData()
    {
        return $this->hasManyThrough(
            Uacs::class,                 // final model we want
            CreditorHasUacs::class,      // pivot table
            'creditor_id',               // foreign key on pivot
            'id',                        // local key on uacs
            'id',                        // local key on creditor
            'uacs_id'                    // foreign key on pivot to uacs
        )
        ->select(
            'uacs.id',
            'uacs.uacs_group_id',
            'uacs.uacs_code',
            'uacs.object_code',
            'uacs.sub_object_code'
        )
        ->with(['groupData']); // nested relation
    }
}
