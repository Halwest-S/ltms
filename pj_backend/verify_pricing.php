<?php

function calculatePrice($basePrice, $weightKg, $weightRate, $size, $categorySurcharge, $vehicleMultiplier) {
    $weightCost = 0.0;
    if ($weightKg && $weightKg > 0) {
        $weightCost = $weightKg * (float) $weightRate;
    } elseif ($size && !empty($size)) {
        $dims = explode('x', strtolower($size));
        if (count($dims) === 3) {
            $volumeCm3 = (float) $dims[0] * (float) $dims[1] * (float) $dims[2];
            $volumetricWeightKg = $volumeCm3 / 5000;
            $weightCost = max($volumetricWeightKg * (float) $weightRate, 10.0);
        } else {
            $weightCost = 10.0;
        }
    }

    $totalPrice = ($basePrice + $weightCost + $categorySurcharge) * (float) $vehicleMultiplier;
    return [
        'total' => round($totalPrice, 2),
        'weight_cost' => round($weightCost, 2)
    ];
}

// Test Case 1: Weight based
$res1 = calculatePrice(10, 5, 2, null, 5, 1.5);
echo "Test 1 (Weight 5kg, Rate 2, Base 10, Surcharge 5, Mult 1.5):\n";
echo "Expected Total: (10 + (5*2) + 5) * 1.5 = 25 * 1.5 = 37.5\n";
echo "Result: " . $res1['total'] . "\n\n";

// Test Case 2: Size based (Volumetric)
$res2 = calculatePrice(10, 0, 2, '20x20x20', 5, 1.2);
echo "Test 2 (Size 20x20x20, Rate 2, Base 10, Surcharge 5, Mult 1.2):\n";
echo "Volumetric Weight: (20*20*20)/5000 = 8000/5000 = 1.6kg\n";
echo "Weight Cost: max(1.6 * 2, 10) = 10\n";
echo "Expected Total: (10 + 10 + 5) * 1.2 = 25 * 1.2 = 30\n";
echo "Result: " . $res2['total'] . "\n\n";

// Test Case 3: Size based (Large Volumetric)
$res3 = calculatePrice(10, 0, 2, '50x50x50', 0, 1.0);
echo "Test 3 (Size 50x50x50, Rate 2):\n";
echo "Volumetric Weight: 125000/5000 = 25kg\n";
echo "Weight Cost: max(25 * 2, 10) = 50\n";
echo "Expected Total: (10 + 50 + 0) * 1.0 = 60\n";
echo "Result: " . $res3['total'] . "\n";
