<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Validator;

class StoreShipmentRequest extends FormRequest
{
    private const KURDISTAN_DESTINATION_KEYWORDS = [
        'kurdistan',
        'kurdistan region',
        'kurdish region',
        'کوردستان',
        'كوردستان',
        'باشووری کوردستان',
        'erbil',
        'hawler',
        'hewler',
        'هەولێر',
        'هولێر',
        'اربيل',
        'أربيل',
        'sulaimani',
        'sulaymaniyah',
        'slemani',
        'silemani',
        'سلێمانی',
        'سليماني',
        'سليمانية',
        'duhok',
        'dohuk',
        'دهۆک',
        'دهوك',
        'zakho',
        'zaxo',
        'زاخۆ',
        'halabja',
        'هەڵەبجە',
        'حلبجة',
        'kirkuk',
        'kerkuk',
        'کەرکووک',
        'كركوك',
        'koya',
        'koysinjaq',
        'کۆیە',
        'akre',
        'aqra',
        'ئاکرێ',
        'ranya',
        'ڕانیە',
        'shaqlawa',
        'شقلاوە',
        'chamchamal',
        'چەمچەماڵ',
        'kalar',
        'کەلار',
    ];

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
            'product_url' => 'required|string|max:2048',
            'product_platform' => 'nullable|string|in:amazon,alibaba',
            'product_title' => 'nullable|string|max:255',
            'product_image_url' => 'nullable|string|max:2048',
            'product_price' => 'nullable|numeric|min:0',
            'product_color' => 'nullable|string|max:100',
            'product_size' => 'nullable|string|max:100',
            'transit_countries' => 'nullable|array',
            'weight_kg' => 'nullable|numeric|min:0.1',
            'size' => 'nullable|string',
            'category_id' => 'required|exists:categories,id',
            'vehicle_type_id' => 'required|exists:vehicle_types,id',
        ];
    }

    public function withValidator(Validator $validator): void
    {
        $validator->after(function (Validator $validator): void {
            $origin = trim((string) $this->input('origin', ''));
            $destination = trim((string) $this->input('destination', ''));

            if ($origin !== '' && $this->looksLikeKurdistanLocation($origin)) {
                $validator->errors()->add(
                    'origin',
                    'Source must be outside Kurdistan for an import request.'
                );
            }

            if ($destination !== '' && ! $this->looksLikeKurdistanLocation($destination)) {
                $validator->errors()->add(
                    'destination',
                    'Destination must be a delivery city in Kurdistan.'
                );
            }
        });
    }

    private function looksLikeKurdistanLocation(string $value): bool
    {
        $normalized = mb_strtolower($value);

        foreach (self::KURDISTAN_DESTINATION_KEYWORDS as $keyword) {
            if (str_contains($normalized, mb_strtolower($keyword))) {
                return true;
            }
        }

        return false;
    }
}
