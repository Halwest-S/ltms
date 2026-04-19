<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AuthRegistrationPhoneTest extends TestCase
{
    use RefreshDatabase;

    public function test_customer_registration_requires_a_phone_number(): void
    {
        $this->postJson('/api/v1/auth/register', [
            'name' => 'Sample Customer',
            'email' => 'customer@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
            'role' => 'customer',
        ])->assertStatus(422)->assertJsonValidationErrors(['phone_number']);
    }

    public function test_customer_registration_normalizes_and_returns_phone_number(): void
    {
        $response = $this->postJson('/api/v1/auth/register', [
            'name' => 'Sample Customer',
            'email' => 'customer@example.com',
            'phone_number' => '+964 750 123 4567',
            'password' => 'password123',
            'password_confirmation' => 'password123',
            'role' => 'customer',
        ]);

        $response->assertOk()
            ->assertJsonPath('user.phone_number', '+9647501234567')
            ->assertJsonStructure([
                'access_token',
                'token_type',
                'user',
            ]);

        $this->assertDatabaseHas('users', [
            'email' => 'customer@example.com',
            'phone_number' => '+9647501234567',
            'role' => 'customer',
        ]);
    }
}
