<?php
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

$vehicles = \App\Models\VehicleType::all()->toArray();
$categories = \App\Models\Category::all()->toArray();

file_put_contents('output.json', json_encode([
    'vehicles' => $vehicles,
    'categories' => $categories
], JSON_PRETTY_PRINT));
