<?php

namespace Tests\Feature;

use App\Models\Category;
use App\Models\Notification;
use App\Models\Shipment;
use App\Models\User;
use App\Models\VehicleType;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class NotificationDeliveryTest extends TestCase
{
    use RefreshDatabase;

    private function createShipmentForDriver(User $driver): Shipment
    {
        $customer = User::factory()->create([
            'role' => 'customer',
            'is_active' => true,
        ]);

        $category = Category::create([
            'name_en' => 'General',
            'name_ku' => 'General',
            'surcharge' => 0,
        ]);

        $vehicleType = VehicleType::create([
            'name_en' => 'Truck',
            'name_ku' => 'Truck',
            'multiplier' => 1,
            'delivery_days_offset' => 1,
        ]);

        return Shipment::create([
            'customer_id' => $customer->id,
            'driver_id' => $driver->id,
            'origin' => 'Amazon marketplace',
            'destination' => 'Erbil',
            'weight_kg' => 4,
            'category_id' => $category->id,
            'vehicle_type_id' => $vehicleType->id,
            'price_breakdown' => ['base_price' => 10],
            'total_price' => 24,
            'estimated_delivery_days' => 5,
            'status' => 'pending',
        ]);
    }

    public function test_staff_can_send_a_notification_to_a_driver_and_the_driver_can_retrieve_it(): void
    {
        $staff = User::factory()->create([
            'role' => 'staff',
            'is_active' => true,
        ]);

        $driver = User::factory()->create([
            'role' => 'driver',
            'is_active' => true,
        ]);

        $shipment = $this->createShipmentForDriver($driver);

        Sanctum::actingAs($staff);

        $this->postJson('/api/v1/staff/notifications/send', [
            'user_id' => $driver->id,
            'shipment_id' => $shipment->id,
            'message_en' => 'Pickup is ready for your route.',
            'message_ku' => 'Pickup is ready for your route.',
        ])->assertCreated()
            ->assertJsonPath('user_id', $driver->id)
            ->assertJsonPath('shipment_id', $shipment->id)
            ->assertJsonPath('shipment.id', $shipment->id)
            ->assertJsonPath('type', 'status_update');

        $this->assertDatabaseHas('notifications', [
            'user_id' => $driver->id,
            'shipment_id' => $shipment->id,
            'message_en' => 'Pickup is ready for your route.',
            'message_ku' => 'Pickup is ready for your route.',
            'type' => 'status_update',
            'is_read' => false,
        ]);

        Sanctum::actingAs($driver);

        $this->getJson('/api/v1/notifications')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.user_id', $driver->id)
            ->assertJsonPath('data.0.message_en', 'Pickup is ready for your route.')
            ->assertJsonPath('data.0.shipment.id', $shipment->id)
            ->assertJsonPath('data.0.type', 'status_update');
    }

    public function test_staff_cannot_send_notifications_to_other_staff_users(): void
    {
        $staff = User::factory()->create([
            'role' => 'staff',
            'is_active' => true,
        ]);

        $otherStaff = User::factory()->create([
            'role' => 'staff',
            'is_active' => true,
        ]);

        Sanctum::actingAs($staff);

        $this->postJson('/api/v1/staff/notifications/send', [
            'user_id' => $otherStaff->id,
            'message_en' => 'Internal test',
            'message_ku' => 'Internal test',
        ])->assertStatus(422);

        $this->assertDatabaseCount('notifications', 0);
    }

    public function test_staff_cannot_link_a_notification_to_someone_elses_shipment(): void
    {
        $staff = User::factory()->create([
            'role' => 'staff',
            'is_active' => true,
        ]);

        $driver = User::factory()->create([
            'role' => 'driver',
            'is_active' => true,
        ]);

        $otherDriver = User::factory()->create([
            'role' => 'driver',
            'is_active' => true,
        ]);

        $shipment = $this->createShipmentForDriver($otherDriver);

        Sanctum::actingAs($staff);

        $this->postJson('/api/v1/staff/notifications/send', [
            'user_id' => $driver->id,
            'shipment_id' => $shipment->id,
            'message_en' => 'Wrong shipment',
            'message_ku' => 'Wrong shipment',
        ])->assertStatus(422)->assertJsonFragment([
            'message' => 'The selected shipment is not linked to this recipient.',
        ]);

        $this->assertDatabaseCount('notifications', 0);
    }
}
