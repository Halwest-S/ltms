<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        $this->removeDuplicateShipmentReports();

        Schema::table('reports', function (Blueprint $table) {
            $table->foreignId('resolved_by_id')
                ->nullable()
                ->after('staff_response')
                ->constrained('users')
                ->nullOnDelete();

            $table->unique('shipment_id', 'reports_shipment_id_unique');
            $table->index(['status', 'created_at'], 'reports_status_created_at_idx');
            $table->index('resolved_by_id', 'reports_resolved_by_id_idx');
        });

        Schema::table('notifications', function (Blueprint $table) {
            $table->foreignUuid('shipment_id')
                ->nullable()
                ->after('user_id')
                ->constrained('shipments')
                ->nullOnDelete();

            $table->index(['user_id', 'is_read'], 'notifications_user_read_idx');
            $table->index(['user_id', 'created_at'], 'notifications_user_created_at_idx');
            $table->index('shipment_id', 'notifications_shipment_id_idx');
        });

        Schema::table('shipments', function (Blueprint $table) {
            $table->index(['customer_id', 'status'], 'shipments_customer_status_idx');
            $table->index(['driver_id', 'status'], 'shipments_driver_status_idx');
            $table->index(['status', 'created_at'], 'shipments_status_created_at_idx');
            $table->index('category_id', 'shipments_category_id_idx');
            $table->index('vehicle_type_id', 'shipments_vehicle_type_id_idx');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('shipments', function (Blueprint $table) {
            $table->dropIndex('shipments_customer_status_idx');
            $table->dropIndex('shipments_driver_status_idx');
            $table->dropIndex('shipments_status_created_at_idx');
            $table->dropIndex('shipments_category_id_idx');
            $table->dropIndex('shipments_vehicle_type_id_idx');
        });

        Schema::table('notifications', function (Blueprint $table) {
            $table->dropIndex('notifications_user_read_idx');
            $table->dropIndex('notifications_user_created_at_idx');
            $table->dropIndex('notifications_shipment_id_idx');
            $table->dropForeign(['shipment_id']);
            $table->dropColumn('shipment_id');
        });

        Schema::table('reports', function (Blueprint $table) {
            $table->dropUnique('reports_shipment_id_unique');
            $table->dropIndex('reports_status_created_at_idx');
            $table->dropIndex('reports_resolved_by_id_idx');
            $table->dropConstrainedForeignId('resolved_by_id');
        });
    }

    private function removeDuplicateShipmentReports(): void
    {
        DB::table('reports')
            ->select('shipment_id')
            ->groupBy('shipment_id')
            ->havingRaw('COUNT(*) > 1')
            ->pluck('shipment_id')
            ->each(function (string $shipmentId): void {
                $reportIds = DB::table('reports')
                    ->where('shipment_id', $shipmentId)
                    ->orderBy('id')
                    ->pluck('id');

                $duplicateIds = $reportIds->slice(1)->values();

                if ($duplicateIds->isNotEmpty()) {
                    DB::table('reports')
                        ->whereIn('id', $duplicateIds)
                        ->delete();
                }
            });
    }
};
