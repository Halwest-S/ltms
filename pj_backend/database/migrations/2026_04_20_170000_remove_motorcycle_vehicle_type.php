<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        DB::table('vehicle_types')
            ->where('name_en', 'Motorcycle')
            ->whereNotExists(function ($query) {
                $query
                    ->selectRaw('1')
                    ->from('shipments')
                    ->whereColumn('shipments.vehicle_type_id', 'vehicle_types.id');
            })
            ->delete();
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        //
    }
};
