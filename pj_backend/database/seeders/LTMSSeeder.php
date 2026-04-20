<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Faq;
use App\Models\PricingConfig;
use App\Models\Report;
use App\Models\Shipment;
use App\Models\User;
use App\Models\VehicleType;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class LTMSSeeder extends Seeder
{
    private const DEFAULT_SUPER_ADMIN_KEY = '11111111-1111-1111-1111-111111111111';

    public function run(): void
    {
        $superAdminAttributes = [
            'name' => 'Super Admin',
            'email' => env('SEED_SUPER_ADMIN_EMAIL', 'admin@ltms.app'),
            'phone_number' => env('SEED_SUPER_ADMIN_PHONE', '+9647500000001'),
            'password' => Hash::make(env('SEED_SUPER_ADMIN_PASSWORD', 'password')),
            'admin_key_hash' => Hash::make(env('SEED_SUPER_ADMIN_KEY', self::DEFAULT_SUPER_ADMIN_KEY)),
            'role' => 'super_admin',
            'is_active' => true,
        ];

        $superAdmin = User::where('role', 'super_admin')->first();
        if ($superAdmin) {
            $superAdmin->fill($superAdminAttributes)->save();
        } else {
            User::create($superAdminAttributes);
        }

        User::updateOrCreate([
            'email' => env('SEED_STAFF_EMAIL', 'staff@ltms.app'),
        ], [
            'name' => 'Staff member',
            'phone_number' => env('SEED_STAFF_PHONE', '+9647500000002'),
            'password' => Hash::make(env('SEED_STAFF_PASSWORD', 'password')),
            'role' => 'staff',
            'is_active' => true,
        ]);

        User::updateOrCreate([
            'email' => env('SEED_DRIVER_EMAIL', 'driver@ltms.app'),
        ], [
            'name' => 'John Driver',
            'phone_number' => env('SEED_DRIVER_PHONE', '+9647500000003'),
            'password' => Hash::make(env('SEED_DRIVER_PASSWORD', 'password')),
            'role' => 'driver',
            'is_active' => true,
        ]);

        $customer = User::updateOrCreate([
            'email' => env('SEED_CUSTOMER_EMAIL', 'customer@ltms.app'),
        ], [
            'name' => 'Sample Customer',
            'phone_number' => env('SEED_CUSTOMER_PHONE', '+9647500000004'),
            'password' => Hash::make(env('SEED_CUSTOMER_PASSWORD', 'password')),
            'role' => 'customer',
            'is_active' => true,
        ]);

        $driver = User::where('email', env('SEED_DRIVER_EMAIL', 'driver@ltms.app'))->first();

        PricingConfig::updateOrCreate([
            'id' => 1,
        ], [
            'base_price' => 15.00,
            'weight_rate' => 2.50,
            'size_divisor' => 5000.00,
            'size_min_charge' => 10.00,
        ]);

        Category::updateOrCreate([
            'name_en' => 'General',
        ], [
            'name_ku' => 'گشتی',
            'surcharge' => 0,
        ]);
        Category::updateOrCreate([
            'name_en' => 'Fragile',
        ], [
            'name_ku' => 'شکاو',
            'surcharge' => 10.00,
        ]);
        Category::updateOrCreate([
            'name_en' => 'Electronics',
        ], [
            'name_ku' => 'ئەلیکترۆنی',
            'surcharge' => 5.00,
        ]);

        VehicleType::updateOrCreate([
            'name_en' => 'Motorcycle',
        ], [
            'name_ku' => 'ماتۆڕسکڵ',
            'transport_method' => 'ground',
            'icon' => '🏍️',
            'multiplier' => 1.0,
            'delivery_days_offset' => 0,
        ]);
        VehicleType::updateOrCreate([
            'name_en' => 'Car',
        ], [
            'name_ku' => 'ئۆتۆمبێل',
            'transport_method' => 'ground',
            'icon' => '🚗',
            'multiplier' => 1.2,
            'delivery_days_offset' => 1,
        ]);
        VehicleType::updateOrCreate([
            'name_en' => 'Truck',
        ], [
            'name_ku' => 'باری هەڵگر',
            'transport_method' => 'ground',
            'icon' => '🚛',
            'multiplier' => 1.5,
            'delivery_days_offset' => 2,
        ]);

        Faq::updateOrCreate([
            'sort_order' => 1,
        ], [
            'question_en' => 'How do I track my import?',
            'question_ku' => 'Chon barekam bedozmawa?',
            'answer_en' => 'Open My Imports in the app to see the current status.',
            'answer_ku' => 'لە ئەپەکە بەشی هاوردەکانم بکەرەوە بۆ بینینی دۆخی ئێستا.',
            'sort_order' => 1,
        ]);

        $general = Category::where('name_en', 'General')->first();
        $fragile = Category::where('name_en', 'Fragile')->first();
        $car = VehicleType::where('name_en', 'Car')->first();
        $truck = VehicleType::where('name_en', 'Truck')->first();

        if ($customer && $driver && $general && $fragile && $car && $truck) {
            $shipmentOne = Shipment::updateOrCreate([
                'customer_id' => $customer->id,
                'origin' => 'Istanbul Supplier Warehouse',
                'destination' => 'Erbil Import Hub',
            ], [
                'driver_id' => $driver->id,
                'product_platform' => 'amazon',
                'product_url' => 'https://www.amazon.com/Example-Travel-Bag/dp/B09G9FPHY6',
                'product_external_id' => 'B09G9FPHY6',
                'product_title' => 'Example Travel Bag',
                'product_color' => 'Black',
                'product_size' => 'M',
                'transit_countries' => [],
                'weight_kg' => 4.5,
                'size' => 'medium',
                'category_id' => $general->id,
                'vehicle_type_id' => $car->id,
                'price_breakdown' => [
                    'base_price' => 15,
                    'weight_rate' => 11.25,
                    'category_surcharge' => 0,
                    'vehicle_multiplier' => 1.2,
                ],
                'total_price' => 31.50,
                'estimated_delivery_days' => 1,
                'status' => 'reported',
            ]);

            $shipmentTwo = Shipment::updateOrCreate([
                'customer_id' => $customer->id,
                'origin' => 'Dubai Free Zone',
                'destination' => 'Sulaimani Bazaar',
            ], [
                'driver_id' => $driver->id,
                'product_platform' => 'alibaba',
                'product_url' => 'https://www.alibaba.com/product-detail/Glass-storage-set_1601234567890.html',
                'product_external_id' => '1601234567890',
                'product_title' => 'Glass Storage Set',
                'product_color' => 'Clear',
                'product_size' => '12 pcs',
                'transit_countries' => [],
                'weight_kg' => 12.0,
                'size' => 'large',
                'category_id' => $fragile->id,
                'vehicle_type_id' => $truck->id,
                'price_breakdown' => [
                    'base_price' => 15,
                    'weight_rate' => 30,
                    'category_surcharge' => 10,
                    'vehicle_multiplier' => 1.5,
                ],
                'total_price' => 82.50,
                'estimated_delivery_days' => 3,
                'status' => 'reported',
            ]);

            $shipmentThree = Shipment::updateOrCreate([
                'customer_id' => $customer->id,
                'origin' => 'Guangzhou Electronics Market',
                'destination' => 'Duhok Delivery Center',
            ], [
                'driver_id' => $driver->id,
                'product_platform' => 'alibaba',
                'product_url' => 'https://www.alibaba.com/product-detail/Phone-accessory-kit_1601234567891.html',
                'product_external_id' => '1601234567891',
                'product_title' => 'Phone Accessory Kit',
                'product_color' => 'White',
                'product_size' => 'Standard',
                'transit_countries' => [],
                'weight_kg' => 2.3,
                'size' => 'small',
                'category_id' => $general->id,
                'vehicle_type_id' => $car->id,
                'price_breakdown' => [
                    'base_price' => 15,
                    'weight_rate' => 5.75,
                    'category_surcharge' => 0,
                    'vehicle_multiplier' => 1.2,
                ],
                'total_price' => 24.90,
                'estimated_delivery_days' => 1,
                'status' => 'reported',
            ]);

            Report::updateOrCreate([
                'shipment_id' => $shipmentOne->id,
            ], [
                'customer_comment' => 'Imported package arrived late and the outer box was dented.',
                'staff_response' => null,
                'status' => 'open',
                'resolved_at' => null,
            ]);

            Report::updateOrCreate([
                'shipment_id' => $shipmentTwo->id,
            ], [
                'customer_comment' => 'Fragile imported items were handled roughly during delivery.',
                'staff_response' => 'We reviewed the import route and issued a compensation voucher.',
                'status' => 'resolved',
                'resolved_at' => now()->subDay(),
            ]);

            Report::updateOrCreate([
                'shipment_id' => $shipmentThree->id,
            ], [
                'customer_comment' => 'Driver marked the imported goods delivered before arrival.',
                'staff_response' => null,
                'status' => 'open',
                'resolved_at' => null,
            ]);
        }
    }
}
