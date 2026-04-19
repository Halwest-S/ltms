<?php

use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Route;

Route::get('/', function (): JsonResponse {
    $serviceName = config('app.name');

    if (! is_string($serviceName) || $serviceName === '' || $serviceName === 'Laravel') {
        $serviceName = 'Backend API';
    }

    return response()->json([
        'service' => $serviceName,
        'status' => 'ok',
        'message' => 'Backend API is running.',
        'endpoints' => [
            'health' => '/up',
            'api' => '/api/v1',
        ],
    ]);
});
