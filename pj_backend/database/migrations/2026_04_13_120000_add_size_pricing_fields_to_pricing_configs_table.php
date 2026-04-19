<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('pricing_configs', function (Blueprint $table) {
            $table->decimal('size_divisor', 10, 2)->default(5000)->after('weight_rate');
            $table->decimal('size_min_charge', 10, 2)->default(10)->after('size_divisor');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('pricing_configs', function (Blueprint $table) {
            $table->dropColumn(['size_divisor', 'size_min_charge']);
        });
    }
};
