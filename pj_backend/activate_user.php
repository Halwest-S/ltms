<?php
require 'vendor/autoload.php';
$app = require_once 'bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

$user = App\Models\User::where('email', 'driver@ltms.app')->first();
if ($user) {
    echo "User found. Current status: " . ($user->is_active ? 'Active' : 'Inactive') . "\n";
    $user->is_active = true;
    $user->save();
    echo "User activated. New status: " . ($user->is_active ? 'Active' : 'Inactive') . "\n";
} else {
    echo "User not found\n";
}
