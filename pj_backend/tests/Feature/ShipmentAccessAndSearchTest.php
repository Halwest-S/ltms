<?php

namespace Tests\Feature;

use App\Models\Category;
use App\Models\PricingConfig;
use App\Models\Shipment;
use App\Models\User;
use App\Models\VehicleType;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class ShipmentAccessAndSearchTest extends TestCase
{
    use RefreshDatabase;

    private function seedCatalog(): array
    {
        PricingConfig::create([
            'base_price' => 15,
            'weight_rate' => 2.5,
        ]);

        $category = Category::create([
            'name_en' => 'General',
            'name_ku' => 'گشتی',
            'surcharge' => 0,
        ]);

        $vehicleType = VehicleType::create([
            'name_en' => 'Car',
            'name_ku' => 'ئۆتۆمبێل',
            'transport_method' => 'ground',
            'multiplier' => 1.2,
            'delivery_days_offset' => 1,
        ]);

        return [$category, $vehicleType];
    }

    public function test_only_customers_can_create_shipments(): void
    {
        [$category, $vehicleType] = $this->seedCatalog();

        $staff = User::factory()->create([
            'role' => 'staff',
            'is_active' => true,
        ]);

        Sanctum::actingAs($staff);

        $this->postJson('/api/v1/shipments', [
            'origin' => 'Erbil',
            'destination' => 'Baghdad',
            'weight_kg' => 12.5,
            'category_id' => $category->id,
            'vehicle_type_id' => $vehicleType->id,
        ])->assertForbidden();

        $this->assertDatabaseCount('shipments', 0);
    }

    public function test_customer_can_create_import_shipment_to_kurdistan(): void
    {
        [$category, $vehicleType] = $this->seedCatalog();

        $customer = User::factory()->create([
            'role' => 'customer',
            'is_active' => true,
        ]);

        Sanctum::actingAs($customer);

        $this->postJson('/api/v1/shipments', [
            'origin' => 'Istanbul Supplier Warehouse',
            'destination' => 'Erbil, Kurdistan',
            'product_url' => 'https://www.amazon.com/Example-Product/dp/B09G9FPHY6',
            'product_color' => 'Black',
            'product_size' => 'M',
            'weight_kg' => 12.5,
            'category_id' => $category->id,
            'vehicle_type_id' => $vehicleType->id,
        ])->assertCreated()
            ->assertJsonPath('origin', 'Istanbul Supplier Warehouse')
            ->assertJsonPath('destination', 'Erbil, Kurdistan')
            ->assertJsonPath('product_platform', 'amazon')
            ->assertJsonPath('product_external_id', 'B09G9FPHY6')
            ->assertJsonPath('product_color', 'Black')
            ->assertJsonPath('product_size', 'M');

        $this->assertDatabaseHas('shipments', [
            'customer_id' => $customer->id,
            'origin' => 'Istanbul Supplier Warehouse',
            'destination' => 'Erbil, Kurdistan',
            'product_platform' => 'amazon',
            'product_url' => 'https://www.amazon.com/Example-Product/dp/B09G9FPHY6',
            'product_external_id' => 'B09G9FPHY6',
            'product_color' => 'Black',
            'product_size' => 'M',
            'status' => 'pending',
        ]);
    }

    public function test_customer_can_preview_marketplace_product_link(): void
    {
        $customer = User::factory()->create([
            'role' => 'customer',
            'is_active' => true,
        ]);

        Sanctum::actingAs($customer);

        $this->postJson('/api/v1/product-links/preview', [
            'url' => 'https://www.amazon.com/Example-Product/dp/B09G9FPHY6',
        ])->assertOk()
            ->assertJsonPath('platform', 'amazon')
            ->assertJsonPath('platform_label', 'Amazon')
            ->assertJsonPath('external_id', 'B09G9FPHY6');
    }

    public function test_unsupported_product_link_is_rejected(): void
    {
        $customer = User::factory()->create([
            'role' => 'customer',
            'is_active' => true,
        ]);

        Sanctum::actingAs($customer);

        $this->postJson('/api/v1/product-links/preview', [
            'url' => 'https://example.com/products/1',
        ])->assertUnprocessable()
            ->assertJsonValidationErrors('product_url');
    }

    public function test_customer_cannot_create_export_shipment_outside_kurdistan(): void
    {
        [$category, $vehicleType] = $this->seedCatalog();

        $customer = User::factory()->create([
            'role' => 'customer',
            'is_active' => true,
        ]);

        Sanctum::actingAs($customer);

        $this->postJson('/api/v1/shipments', [
            'origin' => 'Erbil Warehouse',
            'destination' => 'Istanbul, Turkey',
            'product_url' => 'https://www.amazon.com/Example-Product/dp/B09G9FPHY6',
            'product_color' => 'Black',
            'product_size' => 'M',
            'weight_kg' => 12.5,
            'category_id' => $category->id,
            'vehicle_type_id' => $vehicleType->id,
        ])->assertUnprocessable()
            ->assertJsonValidationErrors('destination');

        $this->assertDatabaseCount('shipments', 0);
    }

    public function test_customer_cannot_create_domestic_shipment_inside_kurdistan(): void
    {
        [$category, $vehicleType] = $this->seedCatalog();

        $customer = User::factory()->create([
            'role' => 'customer',
            'is_active' => true,
        ]);

        Sanctum::actingAs($customer);

        $this->postJson('/api/v1/shipments', [
            'origin' => 'Erbil Warehouse',
            'destination' => 'Duhok Market',
            'product_url' => 'https://www.alibaba.com/product-detail/Example-product_1601234567890.html',
            'product_color' => 'White',
            'product_size' => '42',
            'weight_kg' => 12.5,
            'category_id' => $category->id,
            'vehicle_type_id' => $vehicleType->id,
        ])->assertUnprocessable()
            ->assertJsonValidationErrors('origin');

        $this->assertDatabaseCount('shipments', 0);
    }

    public function test_customer_can_search_shipments_by_uuid_fragment(): void
    {
        [$category, $vehicleType] = $this->seedCatalog();

        $customer = User::factory()->create([
            'role' => 'customer',
            'is_active' => true,
        ]);

        $otherCustomer = User::factory()->create([
            'role' => 'customer',
            'is_active' => true,
        ]);

        $matchingShipment = Shipment::create([
            'customer_id' => $customer->id,
            'origin' => 'Istanbul Supplier Warehouse',
            'destination' => 'Erbil Import Hub',
            'weight_kg' => 3.5,
            'category_id' => $category->id,
            'vehicle_type_id' => $vehicleType->id,
            'price_breakdown' => ['base_price' => 15, 'weight_cost' => 8.75],
            'total_price' => 23.75,
            'estimated_delivery_days' => 4,
            'status' => 'pending',
        ]);

        Shipment::create([
            'customer_id' => $otherCustomer->id,
            'origin' => 'Dubai Free Zone',
            'destination' => 'Duhok Delivery Center',
            'weight_kg' => 5,
            'category_id' => $category->id,
            'vehicle_type_id' => $vehicleType->id,
            'price_breakdown' => ['base_price' => 15, 'weight_cost' => 12.5],
            'total_price' => 27.5,
            'estimated_delivery_days' => 4,
            'status' => 'pending',
        ]);

        Sanctum::actingAs($customer);

        $response = $this->getJson('/api/v1/shipments?search=' . strtoupper(substr($matchingShipment->id, 0, 8)));

        $response->assertOk();
        $response->assertJsonCount(1, 'data');
        $response->assertJsonPath('data.0.id', $matchingShipment->id);
    }

    public function test_staff_and_assigned_driver_receive_customer_phone_with_shipment_payloads(): void
    {
        [$category, $vehicleType] = $this->seedCatalog();

        $customer = User::factory()->create([
            'role' => 'customer',
            'phone_number' => '+9647501234567',
            'is_active' => true,
        ]);

        $driver = User::factory()->create([
            'role' => 'driver',
            'phone_number' => '+9647507654321',
            'is_active' => true,
        ]);

        $staff = User::factory()->create([
            'role' => 'staff',
            'is_active' => true,
        ]);

        $shipment = Shipment::create([
            'customer_id' => $customer->id,
            'driver_id' => $driver->id,
            'origin' => 'Guangzhou Electronics Market',
            'destination' => 'Sulaimani Delivery Center',
            'weight_kg' => 3.5,
            'category_id' => $category->id,
            'vehicle_type_id' => $vehicleType->id,
            'price_breakdown' => ['base_price' => 15, 'weight_cost' => 8.75],
            'total_price' => 23.75,
            'estimated_delivery_days' => 4,
            'status' => 'pending',
        ]);

        Sanctum::actingAs($staff);

        $this->getJson('/api/v1/shipments')
            ->assertOk()
            ->assertJsonPath('data.0.id', $shipment->id)
            ->assertJsonPath('data.0.customer.phone_number', '+9647501234567')
            ->assertJsonPath('data.0.customer.role', 'customer')
            ->assertJsonPath('data.0.driver.phone_number', '+9647507654321');

        Sanctum::actingAs($driver);

        $this->getJson('/api/v1/shipments')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.customer.role', 'customer')
            ->assertJsonPath('data.0.customer.phone_number', '+9647501234567');
    }

    public function test_customer_can_confirm_their_delivered_shipment(): void
    {
        [$category, $vehicleType] = $this->seedCatalog();

        $customer = User::factory()->create([
            'role' => 'customer',
            'is_active' => true,
        ]);

        $shipment = Shipment::create([
            'customer_id' => $customer->id,
            'origin' => 'Istanbul Supplier Warehouse',
            'destination' => 'Erbil Import Hub',
            'weight_kg' => 3.5,
            'category_id' => $category->id,
            'vehicle_type_id' => $vehicleType->id,
            'price_breakdown' => ['base_price' => 15, 'weight_cost' => 8.75],
            'total_price' => 23.75,
            'estimated_delivery_days' => 4,
            'status' => 'delivered',
        ]);

        Sanctum::actingAs($customer);

        $this->patchJson("/api/v1/shipments/{$shipment->id}/status", [
            'status' => 'delivered',
        ])->assertOk()
            ->assertJsonPath('id', $shipment->id)
            ->assertJsonPath('status', 'delivered')
            ->assertJsonStructure(['delivery_confirmed_at']);

        $this->assertNotNull($shipment->fresh()->delivery_confirmed_at);
    }

    public function test_customer_cannot_mark_pending_shipment_delivered(): void
    {
        [$category, $vehicleType] = $this->seedCatalog();

        $customer = User::factory()->create([
            'role' => 'customer',
            'is_active' => true,
        ]);

        $shipment = Shipment::create([
            'customer_id' => $customer->id,
            'origin' => 'Istanbul Supplier Warehouse',
            'destination' => 'Erbil Import Hub',
            'weight_kg' => 3.5,
            'category_id' => $category->id,
            'vehicle_type_id' => $vehicleType->id,
            'price_breakdown' => ['base_price' => 15, 'weight_cost' => 8.75],
            'total_price' => 23.75,
            'estimated_delivery_days' => 4,
            'status' => 'pending',
        ]);

        Sanctum::actingAs($customer);

        $this->patchJson("/api/v1/shipments/{$shipment->id}/status", [
            'status' => 'delivered',
        ])->assertForbidden();
    }

    public function test_customer_cannot_report_a_confirmed_delivered_shipment(): void
    {
        [$category, $vehicleType] = $this->seedCatalog();

        $customer = User::factory()->create([
            'role' => 'customer',
            'is_active' => true,
        ]);

        $shipment = Shipment::create([
            'customer_id' => $customer->id,
            'origin' => 'Istanbul Supplier Warehouse',
            'destination' => 'Erbil Import Hub',
            'weight_kg' => 3.5,
            'category_id' => $category->id,
            'vehicle_type_id' => $vehicleType->id,
            'price_breakdown' => ['base_price' => 15, 'weight_cost' => 8.75],
            'total_price' => 23.75,
            'estimated_delivery_days' => 4,
            'status' => 'delivered',
            'delivery_confirmed_at' => now(),
        ]);

        Sanctum::actingAs($customer);

        $this->postJson('/api/v1/reports', [
            'shipment_id' => $shipment->id,
            'customer_comment' => 'The package has an issue.',
        ])->assertStatus(422)
            ->assertJsonFragment([
                'message' => 'This import has already been confirmed as delivered.',
            ]);

        $this->assertDatabaseCount('reports', 0);
    }
}
