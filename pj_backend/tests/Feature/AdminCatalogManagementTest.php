<?php

namespace Tests\Feature;

use App\Models\Category;
use App\Models\Faq;
use App\Models\PricingConfig;
use App\Models\Shipment;
use App\Models\User;
use App\Models\VehicleType;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class AdminCatalogManagementTest extends TestCase
{
    use RefreshDatabase;

    private function actAsSuperAdmin(): void
    {
        Sanctum::actingAs(User::factory()->create([
            'role' => 'super_admin',
            'is_active' => true,
        ]));
    }

    public function test_super_admin_can_create_and_update_categories(): void
    {
        $this->actAsSuperAdmin();

        $created = $this->postJson('/api/v1/admin/categories', [
            'name_en' => 'Medical',
            'name_ku' => 'Pzishki',
            'surcharge' => 12.5,
        ])->assertCreated()->json();

        $categoryId = $created['id'];

        $this->patchJson("/api/v1/admin/categories/{$categoryId}", [
            'name_en' => 'Medical Priority',
            'name_ku' => 'Pzishki Bala',
            'surcharge' => 18.75,
        ])->assertOk()->assertJsonFragment([
            'id' => $categoryId,
            'name_en' => 'Medical Priority',
            'name_ku' => 'Pzishki Bala',
        ]);

        $this->assertDatabaseHas('categories', [
            'id' => $categoryId,
            'name_en' => 'Medical Priority',
            'name_ku' => 'Pzishki Bala',
            'surcharge' => 18.75,
        ]);
    }

    public function test_super_admin_can_create_and_update_vehicle_types(): void
    {
        $this->actAsSuperAdmin();

        $created = $this->postJson('/api/v1/admin/vehicles', [
            'name_en' => 'Cargo Van',
            'name_ku' => 'Cargo Van',
            'multiplier' => 1.3,
            'delivery_days_offset' => 1,
        ])->assertCreated()->json();

        $vehicleId = $created['id'];

        $this->patchJson("/api/v1/admin/vehicles/{$vehicleId}", [
            'name_en' => 'Cargo Van Express',
            'name_ku' => 'Cargo Van Express',
            'multiplier' => 1.45,
            'delivery_days_offset' => -1,
        ])->assertOk()->assertJsonFragment([
            'id' => $vehicleId,
            'name_en' => 'Cargo Van Express',
            'name_ku' => 'Cargo Van Express',
            'delivery_days_offset' => -1,
        ]);

        $this->assertDatabaseHas('vehicle_types', [
            'id' => $vehicleId,
            'name_en' => 'Cargo Van Express',
            'name_ku' => 'Cargo Van Express',
            'multiplier' => 1.45,
            'delivery_days_offset' => -1,
        ]);
    }

    public function test_super_admin_can_delete_unused_category_and_vehicle_type(): void
    {
        $this->actAsSuperAdmin();

        $category = Category::create([
            'name_en' => 'Archive',
            'name_ku' => 'Archive',
            'surcharge' => 3,
        ]);

        $vehicleType = VehicleType::create([
            'name_en' => 'Archive Van',
            'name_ku' => 'Archive Van',
            'multiplier' => 1.05,
            'delivery_days_offset' => 0,
        ]);

        $this->deleteJson("/api/v1/admin/categories/{$category->id}")
            ->assertNoContent();

        $this->deleteJson("/api/v1/admin/vehicles/{$vehicleType->id}")
            ->assertNoContent();

        $this->assertDatabaseMissing('categories', ['id' => $category->id]);
        $this->assertDatabaseMissing('vehicle_types', ['id' => $vehicleType->id]);
    }

    public function test_super_admin_cannot_delete_category_or_vehicle_type_when_used_by_shipments(): void
    {
        $this->actAsSuperAdmin();

        $customer = User::factory()->create([
            'role' => 'customer',
            'is_active' => true,
        ]);

        $category = Category::create([
            'name_en' => 'Protected Category',
            'name_ku' => 'Protected Category',
            'surcharge' => 8,
        ]);

        $vehicleType = VehicleType::create([
            'name_en' => 'Protected Vehicle',
            'name_ku' => 'Protected Vehicle',
            'multiplier' => 1.3,
            'delivery_days_offset' => 2,
        ]);

        Shipment::create([
            'customer_id' => $customer->id,
            'origin' => 'Erbil',
            'destination' => 'Baghdad',
            'weight_kg' => 12,
            'category_id' => $category->id,
            'vehicle_type_id' => $vehicleType->id,
            'price_breakdown' => ['base_price' => 10],
            'total_price' => 25,
            'estimated_delivery_days' => 3,
            'status' => 'pending',
        ]);

        $this->deleteJson("/api/v1/admin/categories/{$category->id}")
            ->assertStatus(422)
            ->assertJsonFragment([
                'message' => 'This category is already used by shipments and cannot be deleted.',
            ]);

        $this->deleteJson("/api/v1/admin/vehicles/{$vehicleType->id}")
            ->assertStatus(422)
            ->assertJsonFragment([
                'message' => 'This vehicle type is already used by shipments and cannot be deleted.',
            ]);
    }

    public function test_super_admin_can_manage_faqs(): void
    {
        $this->actAsSuperAdmin();

        $created = $this->postJson('/api/v1/admin/faq', [
            'question_en' => 'How long does delivery take?',
            'question_ku' => 'Geyandin chand kat dakhet?',
            'answer_en' => 'Delivery time depends on the selected vehicle type.',
            'answer_ku' => 'Kati geyandin bawastaya be jori otooombel halbzherdrawe.',
            'sort_order' => 2,
        ])->assertCreated()->json();

        $faqId = $created['id'];

        $this->patchJson("/api/v1/admin/faq/{$faqId}", [
            'question_en' => 'How long does express delivery take?',
            'question_ku' => 'Geyandini xera chand kat dakhet?',
            'answer_en' => 'Express delivery arrives faster than standard delivery.',
            'answer_ku' => 'Geyandini xera la geyandini asayi xertir degat.',
            'sort_order' => 1,
        ])->assertOk()->assertJsonFragment([
            'id' => $faqId,
            'question_en' => 'How long does express delivery take?',
            'sort_order' => 1,
        ]);

        $this->deleteJson("/api/v1/admin/faq/{$faqId}")
            ->assertNoContent();

        $this->assertDatabaseMissing('faqs', ['id' => $faqId]);
    }

    public function test_super_admin_can_update_weight_and_size_pricing_rules(): void
    {
        $this->actAsSuperAdmin();

        PricingConfig::create([
            'base_price' => 15,
            'weight_rate' => 2.5,
            'size_divisor' => 5000,
            'size_min_charge' => 10,
        ]);

        $this->patchJson('/api/v1/admin/pricing', [
            'base_price' => 18.5,
            'weight_rate' => 3.25,
            'size_divisor' => 6000,
            'size_min_charge' => 12,
        ])->assertOk()->assertJsonFragment([
            'base_price' => 18.5,
            'weight_rate' => 3.25,
            'size_divisor' => 6000,
            'size_min_charge' => 12,
        ]);

        $this->assertDatabaseHas('pricing_configs', [
            'base_price' => 18.5,
            'weight_rate' => 3.25,
            'size_divisor' => 6000,
            'size_min_charge' => 12,
        ]);
    }
}
