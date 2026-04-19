<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreShipmentRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return $this->user()?->role === 'customer';
    }

    /**
     * Get the validation rules that apply to the request.
     */
    public function rules(): array
    {
        return [
            'origin' => 'required|string',
            'destination' => 'required|string',
            'transit_countries' => 'nullable|array',
            'weight_kg' => 'nullable|numeric|min:0.1',
            'size' => 'nullable|string',
            'category_id' => 'required|exists:categories,id',
            'vehicle_type_id' => 'required|exists:vehicle_types,id',
        ];
    }
}
