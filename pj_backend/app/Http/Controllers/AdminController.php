<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\VehicleType;
use App\Models\PricingConfig;
use App\Models\User;
use App\Models\Faq;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rule;

class AdminController extends Controller
{
    // User Management
    public function users()
    {
        return response()->json(User::paginate(15));
    }

    public function storeUser(Request $request)
    {
        if ($request->filled('phone_number')) {
            $request->merge([
                'phone_number' => $this->normalizePhoneNumber((string) $request->input('phone_number')),
            ]);
        }

        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'phone_number' => ['nullable', 'required_if:role,driver', 'string', 'min:8', 'max:16', 'regex:/^\+?[0-9]{8,15}$/', 'unique:users,phone_number'],
            'password' => 'required|string|min:6',
            'role' => ['required', Rule::in(['staff', 'driver'])],
        ], [
            'role.in' => 'Only staff and driver accounts can be created here. This system supports exactly one super admin account.',
        ]);

        $attributes = [
            'name' => $request->name,
            'email' => $request->email,
            'phone_number' => $request->phone_number,
            'password' => Hash::make($request->password),
            'role' => $request->role,
        ];

        $user = User::create($attributes);

        return response()->json($user, 201);
    }

    public function toggleUserStatus(Request $request, $id)
    {
        $user = User::findOrFail($id);

        if ($user->id === $request->user()->id || $user->role === 'super_admin') {
            return response()->json([
                'message' => 'The super admin account cannot be disabled.',
            ], 422);
        }

        $user->update(['is_active' => !$user->is_active]);
        return response()->json($user);
    }

    public function destroyUser(Request $request, $id)
    {
        $user = User::findOrFail($id);

        if ($user->id === $request->user()->id) {
            return response()->json([
                'message' => 'You cannot delete your own account.',
            ], 422);
        }

        if ($user->role === 'super_admin') {
            return response()->json([
                'message' => 'The super admin account cannot be deleted.',
            ], 422);
        }

        if ($user->shipments()->exists() || $user->assignedShipments()->exists()) {
            return response()->json([
                'message' => 'This account is linked to shipments and cannot be deleted.',
            ], 422);
        }

        $user->tokens()->delete();
        $user->notifications()->delete();
        $user->delete();

        return response()->noContent();
    }

    // Categories
    public function categories()
    {
        return response()->json(Category::all());
    }

    public function storeCategory(Request $request)
    {
        $attributes = $request->validate([
            'name_en' => 'required|string',
            'name_ku' => 'required|string',
            'surcharge' => 'required|numeric',
        ]);

        return response()->json(Category::create($attributes), 201);
    }

    public function updateCategory(Request $request, Category $category)
    {
        $attributes = $request->validate([
            'name_en' => 'required|string',
            'name_ku' => 'required|string',
            'surcharge' => 'required|numeric',
        ]);

        $category->update($attributes);

        return response()->json($category);
    }

    public function destroyCategory(Category $category)
    {
        if ($category->shipments()->exists()) {
            return response()->json([
                'message' => 'This category is already used by shipments and cannot be deleted.',
            ], 422);
        }

        $category->delete();

        return response()->noContent();
    }

    // Vehicle Types
    public function vehicleTypes()
    {
        return response()->json(
            VehicleType::query()
                ->where('name_en', '!=', 'Motorcycle')
                ->get()
        );
    }

    public function storeVehicleType(Request $request)
    {
        $attributes = $request->validate([
            'name_en' => 'required|string',
            'name_ku' => 'required|string',
            'transport_method' => 'nullable|in:ground,air,sea',
            'icon' => 'nullable|string|max:32',
            'multiplier' => 'required|numeric',
            'delivery_days_offset' => 'required|integer',
        ]);

        return response()->json(VehicleType::create($attributes), 201);
    }

    public function updateVehicleType(Request $request, VehicleType $vehicleType)
    {
        $attributes = $request->validate([
            'name_en' => 'required|string',
            'name_ku' => 'required|string',
            'transport_method' => 'nullable|in:ground,air,sea',
            'icon' => 'nullable|string|max:32',
            'multiplier' => 'required|numeric',
            'delivery_days_offset' => 'required|integer',
        ]);

        $vehicleType->update($attributes);

        return response()->json($vehicleType);
    }

    public function destroyVehicleType(VehicleType $vehicleType)
    {
        if ($vehicleType->shipments()->exists()) {
            return response()->json([
                'message' => 'This vehicle type is already used by shipments and cannot be deleted.',
            ], 422);
        }

        $vehicleType->delete();

        return response()->noContent();
    }

    // Pricing Config
    public function pricing()
    {
        return response()->json(PricingConfig::first() ?? new PricingConfig([
            'base_price' => 10,
            'weight_rate' => 2,
            'size_divisor' => 5000,
            'size_min_charge' => 10,
        ]));
    }

    public function updatePricing(Request $request)
    {
        $attributes = $request->validate([
            'base_price' => 'required|numeric|min:0',
            'weight_rate' => 'required|numeric|min:0',
            'size_divisor' => 'required|numeric|gt:0',
            'size_min_charge' => 'required|numeric|min:0',
        ]);

        $pricing = PricingConfig::first() ?? new PricingConfig();
        $pricing->fill($attributes)->save();

        return response()->json($pricing);
    }

    // FAQs
    public function faqs()
    {
        return response()->json(Faq::orderBy('sort_order')->get());
    }

    public function storeFaq(Request $request)
    {
        $attributes = $request->validate([
            'question_en' => 'required|string',
            'question_ku' => 'required|string',
            'answer_en' => 'required|string',
            'answer_ku' => 'required|string',
            'sort_order' => 'nullable|integer|min:0',
        ]);

        $attributes['sort_order'] ??= ((int) Faq::max('sort_order')) + 1;

        return response()->json(Faq::create($attributes), 201);
    }

    public function updateFaq(Request $request, Faq $faq)
    {
        $attributes = $request->validate([
            'question_en' => 'required|string',
            'question_ku' => 'required|string',
            'answer_en' => 'required|string',
            'answer_ku' => 'required|string',
            'sort_order' => 'nullable|integer|min:0',
        ]);

        $attributes['sort_order'] ??= $faq->sort_order;
        $faq->update($attributes);

        return response()->json($faq);
    }

    public function destroyFaq(Faq $faq)
    {
        $faq->delete();

        return response()->noContent();
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
