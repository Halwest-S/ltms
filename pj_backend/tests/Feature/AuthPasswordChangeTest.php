<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class AuthPasswordChangeTest extends TestCase
{
    use RefreshDatabase;

    public function test_driver_can_change_password_with_current_password(): void
    {
        $driver = User::factory()->create([
            'role' => 'driver',
            'password' => Hash::make('old-password'),
            'is_active' => true,
        ]);

        Sanctum::actingAs($driver);

        $this->patchJson('/api/v1/auth/password', [
            'current_password' => 'old-password',
            'new_password' => 'new-password',
            'new_password_confirmation' => 'new-password',
        ])->assertOk()->assertJsonPath('message', 'Password updated successfully.');

        $this->assertTrue(Hash::check('new-password', $driver->fresh()->password));
    }

    public function test_password_change_rejects_wrong_current_password(): void
    {
        $driver = User::factory()->create([
            'role' => 'driver',
            'password' => Hash::make('old-password'),
            'is_active' => true,
        ]);

        Sanctum::actingAs($driver);

        $this->patchJson('/api/v1/auth/password', [
            'current_password' => 'wrong-password',
            'new_password' => 'new-password',
            'new_password_confirmation' => 'new-password',
        ])->assertStatus(422)->assertJsonValidationErrors(['current_password']);
    }
}
