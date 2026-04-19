<?php

namespace Tests\Feature;

use App\Models\Notification;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class NotificationDeliveryTest extends TestCase
{
    use RefreshDatabase;

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

        Sanctum::actingAs($staff);

        $this->postJson('/api/v1/staff/notifications/send', [
            'user_id' => $driver->id,
            'message_en' => 'Pickup is ready for your route.',
            'message_ku' => 'هەڵگرتن ئامادەیە بۆ ڕێگاکەت.',
        ])->assertCreated()
            ->assertJsonPath('user_id', $driver->id)
            ->assertJsonPath('type', 'status_update');

        $this->assertDatabaseHas('notifications', [
            'user_id' => $driver->id,
            'message_en' => 'Pickup is ready for your route.',
            'message_ku' => 'هەڵگرتن ئامادەیە بۆ ڕێگاکەت.',
            'type' => 'status_update',
            'is_read' => false,
        ]);

        Sanctum::actingAs($driver);

        $this->getJson('/api/v1/notifications')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.user_id', $driver->id)
            ->assertJsonPath('data.0.message_en', 'Pickup is ready for your route.')
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
            'message_ku' => 'تاقیکردنەوەی ناوخۆیی',
        ])->assertStatus(422);

        $this->assertDatabaseCount('notifications', 0);
    }
}
