<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

class Shipment extends Model
{
    use HasUuids;

    protected $fillable = [
        'customer_id',
        'driver_id',
        'last_rejected_driver_id',
        'last_assignment_rejection_reason',
        'last_assignment_rejected_at',
        'origin',
        'destination',
        'product_platform',
        'product_url',
        'product_external_id',
        'product_title',
        'product_image_url',
        'product_price',
        'product_color',
        'product_size',
        'product_metadata',
        'transit_countries',
        'weight_kg',
        'size',
        'category_id',
        'vehicle_type_id',
        'price_breakdown',
        'total_price',
        'estimated_delivery_days',
        'status',
        'delivery_confirmed_at',
    ];

    protected $casts = [
        'transit_countries' => 'array',
        'product_metadata' => 'array',
        'price_breakdown' => 'array',
        'product_price' => 'float',
        'weight_kg' => 'float',
        'total_price' => 'float',
        'estimated_delivery_days' => 'integer',
        'customer_id' => 'integer',
        'category_id' => 'integer',
        'vehicle_type_id' => 'integer',
        'driver_id' => 'integer',
        'last_rejected_driver_id' => 'integer',
        'last_assignment_rejected_at' => 'datetime',
        'delivery_confirmed_at' => 'datetime',
    ];

    public function customer(): BelongsTo
    {
        return $this->belongsTo(User::class, 'customer_id');
    }

    public function driver(): BelongsTo
    {
        return $this->belongsTo(User::class, 'driver_id');
    }

    public function lastRejectedDriver(): BelongsTo
    {
        return $this->belongsTo(User::class, 'last_rejected_driver_id');
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

    public function notifications(): HasMany
    {
        return $this->hasMany(Notification::class);
    }
}
