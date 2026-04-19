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
        Schema::create('shipments', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignId('customer_id')->constrained('users');
            $table->foreignId('driver_id')->nullable()->constrained('users');
            $table->string('origin');
            $table->string('destination');
            $table->json('transit_countries')->nullable();
            $table->decimal('weight_kg', 8, 2);
            $table->foreignId('category_id')->constrained('categories');
            $table->foreignId('vehicle_type_id')->constrained('vehicle_types');
            $table->json('price_breakdown');
            $table->decimal('total_price', 10, 2);
            $table->integer('estimated_delivery_days');
            $table->enum('status', ['pending', 'in_transit', 'delivered', 'reported'])->default('pending');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('shipments');
    }
};
