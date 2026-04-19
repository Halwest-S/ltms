<?php

namespace Tests\Feature;

// use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ExampleTest extends TestCase
{
    /**
     * A basic test example.
     */
    public function test_the_application_returns_a_backend_status_payload(): void
    {
        $response = $this->get('/');

        $response
            ->assertOk()
            ->assertJson([
                'service' => 'Backend API',
                'status' => 'ok',
                'message' => 'Backend API is running.',
                'endpoints' => [
                    'health' => '/up',
                    'api' => '/api/v1',
                ],
            ]);
    }
}
