<?php

namespace App\Http\Controllers;

use App\Models\Uacs;
use App\Models\UacsGroup;
use App\Models\UacsType;
use Illuminate\Http\Request;

class UacsController extends Controller
{
    // display uacs codes
    public function display()
    {
        $uacs_types = UacsType::select('id', 'name')->get();
        $uacs_groups = UacsGroup::select('id', 'uacs_type_id', 'name')->get();

        $uacs = Uacs::query()
            ->select(
                'uacs.id',
                'uacs.uacs_code',
                'uacs.object_code',
                'uacs.sub_object_code',
                'uacs.description',
                'uacs.uacs_status',
                'uacs_groups.name as uacs_group_name',
                'uacs_types.name as uacs_type_name'
            )
            ->join('uacs_groups', 'uacs.uacs_group_id', '=', 'uacs_groups.id')
            ->join('uacs_types', 'uacs_groups.uacs_type_id', '=', 'uacs_types.id')
            ->orderBy('uacs.id', 'asc')
            ->get();

        return inertia('Uacs/UacsIndex', [
            'uacs_types' => $uacs_types,
            'uacs_groups' => $uacs_groups,
            'uacs' => $uacs
        ]);
    }

}