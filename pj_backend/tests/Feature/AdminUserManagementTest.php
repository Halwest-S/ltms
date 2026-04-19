<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class AdminUserManagementTest extends TestCase
{
    use RefreshDatabase;

    public function test_super_admin_creation_requires_an_admin_key_for_new_super_admins(): void
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
        ])->assertStatus(422)->assertJsonValidationErrors(['admin_key']);
    }

    public function test_super_admin_creation_stores_the_admin_key_hash(): void
    {
        Sanctum::actingAs(User::factory()->create([
            'role' => 'super_admin',
            'password' => Hash::make('password'),
            'admin_key_hash' => Hash::make('11111111-1111-1111-1111-111111111111'),
            'is_active' => true,
        ]));

        $adminKey = '22222222-2222-2222-2222-222222222222';

        $this->postJson('/api/v1/admin/users', [
            'name' => 'Created Admin',
            'email' => 'created-admin@ltms.app',
            'password' => 'password',
            'role' => 'super_admin',
            'admin_key' => $adminKey,
        ])->assertCreated();

        $createdUser = User::where('email', 'created-admin@ltms.app')->firstOrFail();

        $this->assertSame('super_admin', $createdUser->role);
        $this->assertNotNull($createdUser->admin_key_hash);
        $this->assertTrue(Hash::check($adminKey, $createdUser->admin_key_hash));
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
}
