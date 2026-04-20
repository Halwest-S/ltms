<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreShipmentRequest;
use App\Models\Notification;
use App\Models\Shipment;
use App\Models\User;
use App\Models\VehicleType;
use App\Services\PricingService;
use App\Services\ProductLinkService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ShipmentController extends Controller
{
    protected PricingService $pricingService;

    protected ProductLinkService $productLinkService;

    public function __construct(PricingService $pricingService, ProductLinkService $productLinkService)
    {
        $this->pricingService = $pricingService;
        $this->productLinkService = $productLinkService;
    }
    public function index(Request $request)
    {
        $user = $request->user();
        $query = Shipment::with($this->shipmentRelations());

        // Role-based scoping
        if ($user->role === 'customer') {
            $query->where('customer_id', $user->id);
        } elseif ($user->role === 'driver') {
            $query->where('driver_id', $user->id);
        }

        // Server-side filtering by status
        if ($request->filled('status') && $request->status !== 'All') {
            $query->where('status', $request->status);
        }

        // Server-side search
        if ($request->filled('search')) {
            $search = trim((string) $request->search);
            $like = '%' . strtolower($search) . '%';

            $query->where(function ($q) use ($like) {
                $q->whereRaw('LOWER(CAST(id AS TEXT)) LIKE ?', [$like])
                  ->orWhereRaw('LOWER(origin) LIKE ?', [$like])
                  ->orWhereRaw('LOWER(destination) LIKE ?', [$like])
                  ->orWhereRaw('LOWER(product_platform) LIKE ?', [$like])
                  ->orWhereRaw('LOWER(product_title) LIKE ?', [$like])
                  ->orWhereRaw('LOWER(product_url) LIKE ?', [$like]);
            });
        }

        return response()->json($query->latest()->paginate(15));
    }

    public function store(StoreShipmentRequest $request)
    {
        return DB::transaction(function () use ($request) {
            $product = $this->productLinkService->preview($request->product_url);
            $pricingResult = $this->pricingService->calculate(
                $request->category_id,
                $request->vehicle_type_id,
                $request->weight_kg,
                $request->size
            );

            $shipment = Shipment::create([
                'customer_id' => $request->user()->id,
                'origin' => $request->origin,
                'destination' => $request->destination,
                'product_platform' => $product['platform'],
                'product_url' => $product['url'],
                'product_external_id' => $product['external_id'],
                'product_title' => $request->product_title ?: $product['title'],
                'product_image_url' => $request->product_image_url ?: $product['image_url'],
                'product_price' => $request->filled('product_price')
                    ? $request->product_price
                    : $product['price'],
                'product_color' => $request->product_color,
                'product_size' => $request->product_size,
                'product_metadata' => [
                    'platform_label' => $product['platform_label'],
                    'preview_title' => $product['title'],
                ],
                'transit_countries' => $request->transit_countries,
                'weight_kg' => $request->weight_kg,
                'size' => $request->size,
                'category_id' => $request->category_id,
                'vehicle_type_id' => $request->vehicle_type_id,
                'price_breakdown' => $pricingResult['breakdown'],
                'total_price' => $pricingResult['total_price'],
                'estimated_delivery_days' => $pricingResult['estimated_delivery_days'],
                'status' => 'pending',
            ]);

            Notification::create([
                'user_id' => $shipment->customer_id,
                'shipment_id' => $shipment->id,
                'message_en' => 'Your import request has been created and is currently pending.',
                'message_ku' => 'داواکاری هاوردەکەت دروستکرا و لە ئێستادا چاوەڕوانە.',
                'type' => 'status_update',
                'is_read' => false,
            ]);

            return response()->json($shipment->load($this->shipmentRelations()), 201);
        });
    }

    public function show($id)
    {
        $shipment = Shipment::with([
            ...$this->shipmentRelations(),
            'report',
        ])->findOrFail($id);
        $user = auth()->user();

        if ($user->role === 'customer' && $shipment->customer_id !== $user->id) {
            return response()->json(['message' => 'Unauthorized.'], 403);
        }

        if ($user->role === 'driver' && $shipment->driver_id !== $user->id) {
            return response()->json(['message' => 'Unauthorized.'], 403);
        }

        return response()->json($shipment);
    }

    public function updateStatus(Request $request, $id)
    {
        $request->validate([
            'status' => 'required|in:pending,in_transit,delivered,reported',
        ]);

        $shipment = Shipment::findOrFail($id);
        $user = $request->user();

        if ($user->role === 'customer') {
            if ($shipment->customer_id !== $user->id) {
                return response()->json(['message' => 'Unauthorized.'], 403);
            }

            if ($request->status === 'delivered' && $shipment->status === 'delivered') {
                if ($shipment->delivery_confirmed_at === null) {
                    $shipment->update(['delivery_confirmed_at' => now()]);
                }

                return response()->json($shipment->load($this->shipmentRelations()));
            }

            return response()->json(['message' => 'Unauthorized.'], 403);
        }

        if ($user->role === 'driver' && $shipment->driver_id !== $user->id) {
            return response()->json(['message' => 'Unauthorized.'], 403);
        }

        if (!in_array($user->role, ['driver', 'staff', 'super_admin'], true)) {
            return response()->json(['message' => 'Unauthorized.'], 403);
        }
        
        // Basic state machine enforcement
        $allowedTransitions = [
            'pending' => ['in_transit', 'reported'],
            'in_transit' => ['delivered', 'reported'],
            'delivered' => ['reported'],
            'reported' => [],
        ];

        if (!in_array($request->status, $allowedTransitions[$shipment->status])) {
            return response()->json(['message' => 'Invalid status transition.'], 422);
        }

        $shipment->update(['status' => $request->status]);

        return response()->json($shipment);
    }

    public function assignDriver(Request $request, $id)
    {
        $request->validate([
            'driver_id' => 'required|exists:users,id',
        ]);

        if (!in_array($request->user()->role, ['staff', 'super_admin'], true)) {
            return response()->json(['message' => 'Unauthorized.'], 403);
        }

        $shipment = Shipment::findOrFail($id);
        
        // Verify the user is a driver
        $driver = \App\Models\User::findOrFail($request->driver_id);
        if ($driver->role !== 'driver') {
            return response()->json(['message' => 'The selected user is not a driver.'], 422);
        }

        $shipment->update(['driver_id' => $request->driver_id]);

        Notification::create([
            'user_id' => $request->driver_id,
            'message_en' => 'A new import delivery has been assigned to you: #'.substr($shipment->id, 0, 8),
            'message_ku' => 'گەیاندنی هاوردەیەکی نوێت پێسپێردرا: #'.substr($shipment->id, 0, 8),
            'type' => 'assignment',
            'is_read' => false,
            'shipment_id' => $shipment->id,
        ]);

        return response()->json($shipment->load($this->shipmentRelations()));
    }

    public function drivers()
    {
        $drivers = User::where('role', 'driver')
            ->where('is_active', true)
            ->get(['id', 'name', 'email', 'phone_number']);

        return response()->json($drivers);
    }

    public function previewProductLink(Request $request)
    {
        $request->validate([
            'url' => 'required|string|max:2048',
        ]);

        return response()->json(
            $this->productLinkService->preview((string) $request->input('url'))
        );
    }

    public function transportOptions()
    {
        return response()->json(
            VehicleType::query()
                ->orderByRaw("CASE transport_method WHEN 'air' THEN 1 WHEN 'ground' THEN 2 WHEN 'sea' THEN 3 ELSE 4 END")
                ->orderBy('name_en')
                ->get()
        );
    }

    public function calculatePreview(Request $request)
    {
        $request->validate([
            'weight_kg' => 'nullable|numeric|min:0.1',
            'size' => 'nullable|string',
            'category_id' => 'required|exists:categories,id',
            'vehicle_type_id' => 'required|exists:vehicle_types,id',
        ]);

        $pricingResult = $this->pricingService->calculate(
            $request->category_id,
            $request->vehicle_type_id,
            $request->weight_kg,
            $request->size
        );

        return response()->json([
            'total_price' => $pricingResult['total_price'],
            'estimated_delivery_days' => $pricingResult['estimated_delivery_days'],
        ]);
    }

    private function shipmentRelations(): array
    {
        return [
            'category',
            'vehicleType',
            'customer:id,name,email,phone_number,role',
            'driver:id,name,email,phone_number,role',
        ];
    }
}
