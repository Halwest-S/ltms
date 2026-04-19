<?php

namespace Database\Seeders;

use App\Models\VehicleType;
use Illuminate\Database\Seeder;

class UpdateVehicleTypesSeeder extends Seeder
{
    public function run(): void
    {
        // Update existing vehicle types with transport methods and icons
        VehicleType::where('name_en', 'Motorcycle')->update([
            'transport_method' => 'ground',
            'icon' => '🏍️'
        ]);

        VehicleType::where('name_en', 'Car')->update([
            'transport_method' => 'ground',
            'icon' => '🚗'
        ]);

        VehicleType::where('name_en', 'Truck')->update([
            'transport_method' => 'ground',
            'icon' => '🚛'
        ]);

        // Add new airplane transport method
        VehicleType::updateOrCreate([
            'name_en' => 'Airplane',
        ], [
            'name_en' => 'Airplane',
            'name_ku' => 'فڕۆکە',
            'multiplier' => 2.5,
            'delivery_days_offset' => -2,
            'transport_method' => 'air',
            'icon' => '✈️'
        ]);

        // Add additional ground transport options
        VehicleType::updateOrCreate([
            'name_en' => 'Van',
        ], [
            'name_en' => 'Van',
            'name_ku' => 'ڤان',
            'multiplier' => 1.1,
            'delivery_days_offset' => 0,
            'transport_method' => 'ground',
            'icon' => '🚐'
        ]);
    }
}
