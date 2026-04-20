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
        Schema::table('shipments', function (Blueprint $table) {
            $table->string('product_platform')->nullable()->after('destination');
            $table->text('product_url')->nullable()->after('product_platform');
            $table->string('product_external_id')->nullable()->after('product_url');
            $table->string('product_title')->nullable()->after('product_external_id');
            $table->text('product_image_url')->nullable()->after('product_title');
            $table->decimal('product_price', 10, 2)->nullable()->after('product_image_url');
            $table->string('product_color')->nullable()->after('product_price');
            $table->string('product_size')->nullable()->after('product_color');
            $table->json('product_metadata')->nullable()->after('product_size');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('shipments', function (Blueprint $table) {
            $table->dropColumn([
                'product_platform',
                'product_url',
                'product_external_id',
                'product_title',
                'product_image_url',
                'product_price',
                'product_color',
                'product_size',
                'product_metadata',
            ]);
        });
    }
};
