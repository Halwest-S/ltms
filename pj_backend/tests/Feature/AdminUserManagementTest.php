<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use App\Models\Category;
use App\Models\Shipment;
use App\Models\VehicleType;
use Illuminate\Support\Facades\Hash;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class AdminUserManagementTest extends TestCase
{
    use RefreshDatabase;

    public function test_super_admin_cannot_create_another_super_admin(): void
    {
        Sanctum::actingAs(User::factory()->create([
            'role' => 'super_admin',
            'password' => Hash::make('password'),
            'admin_key_hash' => Hash::make('11111111-1111-1111-1111-111111111111'),
            'is_active' => true,
        ]));

        $this->postJson('/api/v1/admin/users', [
            'name' => 'Created Admin',
            'email' => 'created-admin@ltms.app',
            'password' => 'password',
            'role' => 'super_admin',
        ])->assertStatus(422)->assertJsonValidationErrors(['role']);
    }

    public function test_super_admin_can_create_staff_account(): void
    {
        Sanctum::actingAs(User::factory()->create([
            'role' => 'super_admin',
            'password' => Hash::make('password'),
            'admin_key_hash' => Hash::make('11111111-1111-1111-1111-111111111111'),
            'is_active' => true,
        ]));

        $this->postJson('/api/v1/admin/users', [
            'name' => 'Created Staff',
            'email' => 'created-staff@ltms.app',
            'password' => 'password',
            'role' => 'staff',
        ])->assertCreated();

        $createdUser = User::where('email', 'created-staff@ltms.app')->firstOrFail();

        $this->assertSame('staff', $createdUser->role);
        $this->assertNull($createdUser->admin_key_hash);
    }

    public function test_driver_creation_requires_a_phone_number(): void
    {
        Sanctum::actingAs(User::factory()->create([
            'role' => 'super_admin',
            'password' => Hash::make('password'),
            'admin_key_hash' => Hash::make('11111111-1111-1111-1111-111111111111'),
            'is_active' => true,
        ]));

        $this->postJson('/api/v1/admin/users', [
            'name' => 'Created Driver',
            'email' => 'created-driver@ltms.app',
            'password' => 'password',
            'role' => 'driver',
        ])->assertStatus(422)->assertJsonValidationErrors(['phone_number']);

        $this->postJson('/api/v1/admin/users', [
            'name' => 'Created Driver',
            'email' => 'created-driver@ltms.app',
            'phone_number' => '+964 750 123 4567',
            'password' => 'password',
            'role' => 'driver',
        ])->assertCreated()->assertJsonPath('phone_number', '+9647501234567');

        $this->assertDatabaseHas('users', [
            'email' => 'created-driver@ltms.app',
            'phone_number' => '+9647501234567',
            'role' => 'driver',
        ]);
    }

    public function test_super_admin_can_delete_unlinked_accounts(): void
    {
        Sanctum::actingAs(User::factory()->create([
            'role' => 'super_admin',
            'password' => Hash::make('password'),
            'admin_key_hash' => Hash::make('11111111-1111-1111-1111-111111111111'),
            'is_active' => true,
        ]));

        $staff = User::factory()->create([
            'role' => 'staff',
            'is_active' => true,
        ]);

        $this->deleteJson("/api/v1/admin/users/{$staff->id}")
            ->assertNoContent();

        $this->assertDatabaseMissing('users', ['id' => $staff->id]);
    }

    public function test_super_admin_cannot_delete_self_or_the_super_admin_account(): void
    {
        $superAdmin = User::factory()->create([
            'role' => 'super_admin',
            'password' => Hash::make('password'),
            'admin_key_hash' => Hash::make('11111111-1111-1111-1111-111111111111'),
            'is_active' => true,
        ]);

        Sanctum::actingAs($superAdmin);

        $this->deleteJson("/api/v1/admin/users/{$superAdmin->id}")
            ->assertStatus(422)
            ->assertJsonFragment([
                'message' => 'You cannot delete your own account.',
            ]);

        $this->patchJson("/api/v1/admin/users/{$superAdmin->id}/toggle")
            ->assertStatus(422)
            ->assertJsonFragment([
                'message' => 'The super admin account cannot be disabled.',
            ]);
    }

    public function test_super_admin_cannot_delete_accounts_linked_to_shipments(): void
    {
        Sanctum::actingAs(User::factory()->create([
            'role' => 'super_admin',
            'password' => Hash::make('password'),
            'admin_key_hash' => Hash::make('11111111-1111-1111-1111-111111111111'),
            'is_active' => true,
        ]));

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

        Shipment::create([
            'customer_id' => $customer->id,
            'origin' => 'Amazon marketplace',
            'destination' => 'Duhok',
            'weight_kg' => 3,
            'category_id' => $category->id,
            'vehicle_type_id' => $vehicleType->id,
            'price_breakdown' => ['base_price' => 10],
            'total_price' => 20,
            'estimated_delivery_days' => 5,
            'status' => 'pending',
        ]);

        $this->deleteJson("/api/v1/admin/users/{$customer->id}")
            ->assertStatus(422)
            ->assertJsonFragment([
                'message' => 'This account is linked to shipments and cannot be deleted.',
            ]);
    }
}
