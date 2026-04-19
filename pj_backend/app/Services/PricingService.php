<?php

namespace App\Services;

use App\Models\Category;
use App\Models\VehicleType;
use App\Models\PricingConfig;

class PricingService
{
    /**
     * Calculate the breakdown and total price for a shipment.
     * 
     * @param int $categoryId
     * @param int $vehicleTypeId
     * @param float|null $weightKg
     * @param string|null $size
     * @return array
     */
    public function calculate(int $categoryId, int $vehicleTypeId, ?float $weightKg = null, ?string $size = null): array
    {
        $category = Category::findOrFail($categoryId);
        $vehicleType = VehicleType::findOrFail($vehicleTypeId);
        $pricing = PricingConfig::first() ?? new PricingConfig([
            'base_price' => 10,
            'weight_rate' => 2,
            'size_divisor' => 5000,
            'size_min_charge' => 10,
        ]);

        $basePrice = (float) $pricing->base_price;
        $weightRate = (float) $pricing->weight_rate;
        $sizeDivisor = max((float) ($pricing->size_divisor ?? 5000), 1.0);
        $sizeMinCharge = max((float) ($pricing->size_min_charge ?? 10), 0.0);
        $weightCost = 0.0;
        $pricingMode = 'base_only';

        if ($weightKg && $weightKg > 0) {
            $weightCost = $weightKg * $weightRate;
            $pricingMode = 'weight';
        } elseif ($size && !empty($size)) {
            $dims = explode('x', strtolower($size));
            if (count($dims) === 3) {
                $volumeCm3 = (float) $dims[0] * (float) $dims[1] * (float) $dims[2];
                $volumetricWeightKg = $volumeCm3 / $sizeDivisor;
                $weightCost = max($volumetricWeightKg * $weightRate, $sizeMinCharge);
            } else {
                $weightCost = $sizeMinCharge;
            }
            $pricingMode = 'size';
        }

        $categorySurcharge = (float) $category->surcharge;
        $totalPrice = ($basePrice + $weightCost + $categorySurcharge) * (float) $vehicleType->multiplier;

        return [
            'total_price' => round($totalPrice, 2),
            'estimated_delivery_days' => 3 + (int) $vehicleType->delivery_days_offset,
            'breakdown' => [
                'base_price' => $basePrice,
                'weight_cost' => round($weightCost, 2),
                'weight_rate' => $weightRate,
                'size_divisor' => $sizeDivisor,
                'size_min_charge' => $sizeMinCharge,
                'pricing_mode' => $pricingMode,
                'category_surcharge' => $categorySurcharge,
                'vehicle_multiplier' => (float) $vehicleType->multiplier,
            ],
        ];
    }
}
