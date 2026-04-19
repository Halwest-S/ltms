<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class AuthLoginTest extends TestCase
{
    use RefreshDatabase;

    public function test_super_admin_login_requires_a_matching_admin_key(): void
    {
        $user = User::factory()->create([
            'email' => 'admin@ltms.app',
            'role' => 'super_admin',
            'password' => Hash::make('password'),
            'admin_key_hash' => Hash::make('11111111-1111-1111-1111-111111111111'),
            'is_active' => true,
        ]);

        $this->postJson('/api/v1/auth/login', [
            'email' => $user->email,
            'password' => 'password',
        ])->assertStatus(422)->assertJsonValidationErrors(['admin_key']);

        $this->postJson('/api/v1/auth/login', [
            'email' => $user->email,
            'password' => 'password',
            'admin_key' => '22222222-2222-2222-2222-222222222222',
        ])->assertStatus(422)->assertJsonValidationErrors(['admin_key']);

        $this->postJson('/api/v1/auth/login', [
            'email' => $user->email,
            'password' => 'password',
            'admin_key' => '11111111-1111-1111-1111-111111111111',
        ])->assertOk()->assertJsonStructure([
            'access_token',
            'token_type',
            'user',
        ]);
    }

    public function test_non_admin_login_does_not_require_an_admin_key(): void
    {
        $user = User::factory()->create([
            'email' => 'staff@ltms.app',
            'role' => 'staff',
            'password' => Hash::make('password'),
            'is_active' => true,
        ]);

        $this->postJson('/api/v1/auth/login', [
            'email' => $user->email,
            'password' => 'password',
        ])->assertOk()->assertJsonMissingPath('user.admin_key_hash');
    }
}
