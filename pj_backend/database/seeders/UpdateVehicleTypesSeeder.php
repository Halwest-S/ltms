<?php

namespace Database\Seeders;

use App\Models\VehicleType;
use Illuminate\Database\Seeder;

class UpdateVehicleTypesSeeder extends Seeder
{
    public function run(): void
    {
        VehicleType::where('name_en', 'Motorcycle')->update([
            'transport_method' => 'ground',
            'icon' => '🏍️',
        ]);

        VehicleType::where('name_en', 'Car')->update([
            'transport_method' => 'ground',
            'icon' => '🚗',
        ]);

        VehicleType::where('name_en', 'Truck')->update([
            'transport_method' => 'ground',
            'icon' => '🚛',
        ]);

        VehicleType::updateOrCreate([
            'name_en' => 'Airplane',
        ], [
            'name_en' => 'Airplane',
            'name_ku' => 'فڕۆکە',
            'multiplier' => 2.5,
            'delivery_days_offset' => -2,
            'transport_method' => 'air',
            'icon' => '✈️',
        ]);

        VehicleType::updateOrCreate([
            'name_en' => 'Van',
        ], [
            'name_en' => 'Van',
            'name_ku' => 'ڤان',
            'multiplier' => 1.1,
            'delivery_days_offset' => 0,
            'transport_method' => 'ground',
            'icon' => '🚐',
        ]);

        VehicleType::updateOrCreate([
            'name_en' => 'Ship',
        ], [
            'name_en' => 'Ship',
            'name_ku' => 'کەشتی',
            'multiplier' => 0.8,
            'delivery_days_offset' => 10,
            'transport_method' => 'sea',
            'icon' => '🚢',
        ]);

        VehicleType::where('name_en', 'Motorcycle')
            ->whereDoesntHave('shipments')
            ->delete();
    }
}
