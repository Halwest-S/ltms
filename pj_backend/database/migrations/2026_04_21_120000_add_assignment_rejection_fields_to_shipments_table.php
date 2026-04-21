<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('shipments', function (Blueprint $table) {
            $table->foreignId('last_rejected_driver_id')
                ->nullable()
                ->after('driver_id')
                ->constrained('users')
                ->nullOnDelete();
            $table->text('last_assignment_rejection_reason')->nullable()->after('last_rejected_driver_id');
            $table->timestamp('last_assignment_rejected_at')->nullable()->after('last_assignment_rejection_reason');
        });
    }

    public function down(): void
    {
        Schema::table('shipments', function (Blueprint $table) {
            $table->dropConstrainedForeignId('last_rejected_driver_id');
            $table->dropColumn([
                'last_assignment_rejection_reason',
                'last_assignment_rejected_at',
            ]);
        });
    }
};
