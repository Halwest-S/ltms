<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PricingConfig extends Model
{
    protected $fillable = [
        'base_price',
        'weight_rate',
        'size_divisor',
        'size_min_charge',
    ];

    protected $casts = [
        'base_price' => 'float',
        'weight_rate' => 'float',
        'size_divisor' => 'float',
        'size_min_charge' => 'float',
    ];
}
