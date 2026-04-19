<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasOne;

class Shipment extends Model
{
    use HasUuids;

    protected $fillable = [
        'customer_id',
        'driver_id',
        'origin',
        'destination',
        'transit_countries',
        'weight_kg',
        'size',
        'category_id',
        'vehicle_type_id',
        'price_breakdown',
        'total_price',
        'estimated_delivery_days',
        'status',
    ];

    protected $casts = [
        'transit_countries' => 'array',
        'price_breakdown' => 'array',
        'weight_kg' => 'float',
        'total_price' => 'float',
        'estimated_delivery_days' => 'integer',
        'customer_id' => 'integer',
        'category_id' => 'integer',
        'vehicle_type_id' => 'integer',
        'driver_id' => 'integer',
    ];

    public function customer(): BelongsTo
    {
        return $this->belongsTo(User::class, 'customer_id');
    }

    public function driver(): BelongsTo
    {
        return $this->belongsTo(User::class, 'driver_id');
    }

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    public function vehicleType(): BelongsTo
    {
        return $this->belongsTo(VehicleType::class);
    }

    public function report(): HasOne
    {
        return $this->hasOne(Report::class);
    }
}
