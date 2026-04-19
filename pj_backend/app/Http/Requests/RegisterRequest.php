<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class RegisterRequest extends FormRequest
{
    protected function prepareForValidation(): void
    {
        if ($this->filled('phone_number')) {
            $this->merge([
                'phone_number' => $this->normalizePhoneNumber((string) $this->input('phone_number')),
            ]);
        }
    }

    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     */
    public function rules(): array
    {
        return [
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'phone_number' => ['required', 'string', 'min:8', 'max:16', 'regex:/^\+?[0-9]{8,15}$/', 'unique:users,phone_number'],
            'password' => 'required|string|min:8|confirmed',
            'role' => 'required|in:customer', // SECURITY: Public registration restricted to customers only
        ];
    }

    /**
     * Get custom messages for validator errors.
     */
    public function messages(): array
    {
        return [
            'phone_number.required' => 'Phone number is required.',
            'phone_number.regex' => 'Phone number must contain 8 to 15 digits and may start with +.',
            'role.in' => 'Public registration is restricted to customers. Drivers and Staff must be registered by an administrator.',
        ];
    }

    private function normalizePhoneNumber(string $phoneNumber): string
    {
        $phoneNumber = trim($phoneNumber);

        if ($phoneNumber === '') {
            return $phoneNumber;
        }

        $hasPlusPrefix = str_starts_with($phoneNumber, '+');
        $digitsOnly = preg_replace('/\D+/', '', $phoneNumber) ?? '';

        return $hasPlusPrefix ? '+' . $digitsOnly : $digitsOnly;
    }
}
