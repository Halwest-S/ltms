<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class VehicleType extends Model
{
    protected $fillable = [
        'name_en',
        'name_ku',
        'multiplier',
        'delivery_days_offset',
    ];

    protected $casts = [
        'multiplier' => 'float',
        'delivery_days_offset' => 'integer',
    ];

    public function shipments(): HasMany
    {
        return $this->hasMany(Shipment::class);
    }
}
