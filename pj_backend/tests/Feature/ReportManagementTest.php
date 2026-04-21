<?php

namespace Tests\Feature;

use App\Models\Category;
use App\Models\Report;
use App\Models\Shipment;
use App\Models\User;
use App\Models\VehicleType;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class ReportManagementTest extends TestCase
{
    use RefreshDatabase;

    private function createShipmentFor(User $customer): Shipment
    {
        $category = Category::create([
            'name_en' => 'General',
            'name_ku' => 'General',
            'surcharge' => 0,
        ]);

        $vehicleType = VehicleType::create([
            'name_en' => 'Truck',
            'name_ku' => 'Truck',
            'multiplier' => 1,
            'delivery_days_offset' => 1,
        ]);

        return Shipment::create([
            'customer_id' => $customer->id,
            'origin' => 'Amazon marketplace',
            'destination' => 'Erbil',
            'weight_kg' => 4,
            'category_id' => $category->id,
            'vehicle_type_id' => $vehicleType->id,
            'price_breakdown' => ['base_price' => 10],
            'total_price' => 24,
            'estimated_delivery_days' => 5,
            'status' => 'pending',
        ]);
    }

    public function test_customer_can_submit_report_for_own_shipment(): void
    {
        $customer = User::factory()->create([
            'role' => 'customer',
            'is_active' => true,
        ]);
        $shipment = $this->createShipmentFor($customer);

        Sanctum::actingAs($customer);

        $this->postJson('/api/v1/reports', [
            'shipment_id' => $shipment->id,
            'customer_comment' => 'The imported goods arrived damaged.',
        ])->assertCreated()->assertJsonFragment([
            'customer_comment' => 'The imported goods arrived damaged.',
            'status' => 'open',
        ]);

        $this->assertDatabaseHas('reports', [
            'shipment_id' => $shipment->id,
            'customer_comment' => 'The imported goods arrived damaged.',
            'status' => 'open',
        ]);

        $this->assertDatabaseHas('shipments', [
            'id' => $shipment->id,
            'status' => 'reported',
        ]);
    }

    public function test_drivers_cannot_view_or_update_reports(): void
    {
        $customer = User::factory()->create([
            'role' => 'customer',
            'is_active' => true,
        ]);
        $driver = User::factory()->create([
            'role' => 'driver',
            'is_active' => true,
        ]);
        $shipment = $this->createShipmentFor($customer);
        $report = Report::create([
            'shipment_id' => $shipment->id,
            'customer_comment' => 'The package is missing.',
            'status' => 'open',
        ]);

        Sanctum::actingAs($driver);

        $this->getJson('/api/v1/reports')->assertForbidden();
        $this->patchJson("/api/v1/reports/{$report->id}", [
            'staff_response' => 'Checked by driver.',
            'status' => 'resolved',
        ])->assertForbidden();
    }

    public function test_customer_cannot_submit_more_than_one_report_for_a_shipment(): void
    {
        $customer = User::factory()->create([
            'role' => 'customer',
            'is_active' => true,
        ]);
        $shipment = $this->createShipmentFor($customer);

        Report::create([
            'shipment_id' => $shipment->id,
            'customer_comment' => 'The package is already under review.',
            'status' => 'open',
        ]);

        Sanctum::actingAs($customer);

        $this->postJson('/api/v1/reports', [
            'shipment_id' => $shipment->id,
            'customer_comment' => 'I want to submit the same issue again.',
        ])->assertStatus(422)->assertJsonFragment([
            'message' => 'This import already has a report.',
        ]);

        $this->assertDatabaseCount('reports', 1);
    }

    public function test_staff_and_super_admin_can_resolve_reports_with_a_comment(): void
    {
        $customer = User::factory()->create([
            'role' => 'customer',
            'is_active' => true,
        ]);
        $staff = User::factory()->create([
            'role' => 'staff',
            'is_active' => true,
        ]);
        $superAdmin = User::factory()->create([
            'role' => 'super_admin',
            'is_active' => true,
        ]);

        $shipment = $this->createShipmentFor($customer);
        $staffReport = Report::create([
            'shipment_id' => $shipment->id,
            'customer_comment' => 'The package is late.',
            'status' => 'open',
        ]);

        Sanctum::actingAs($staff);

        $this->patchJson("/api/v1/reports/{$staffReport->id}", [
            'staff_response' => 'We contacted the driver and updated the route.',
            'status' => 'resolved',
        ])->assertOk()->assertJsonFragment([
            'staff_response' => 'We contacted the driver and updated the route.',
            'status' => 'resolved',
            'resolved_by_id' => $staff->id,
        ]);

        $this->assertDatabaseHas('reports', [
            'id' => $staffReport->id,
            'resolved_by_id' => $staff->id,
            'status' => 'resolved',
        ]);

        $this->assertDatabaseHas('notifications', [
            'user_id' => $customer->id,
            'shipment_id' => $shipment->id,
            'type' => 'report_update',
            'is_read' => false,
        ]);

        $adminShipment = $this->createShipmentFor($customer);
        $adminReport = Report::create([
            'shipment_id' => $adminShipment->id,
            'customer_comment' => 'The replacement item needs approval.',
            'status' => 'open',
        ]);

        Sanctum::actingAs($superAdmin);

        $this->patchJson("/api/v1/reports/{$adminReport->id}", [
            'staff_response' => 'Super admin approved a compensation voucher.',
            'status' => 'compensation_issued',
        ])->assertOk()->assertJsonFragment([
            'staff_response' => 'Super admin approved a compensation voucher.',
            'status' => 'compensation_issued',
            'resolved_by_id' => $superAdmin->id,
        ]);

        $this->assertDatabaseHas('reports', [
            'id' => $adminReport->id,
            'resolved_by_id' => $superAdmin->id,
            'status' => 'compensation_issued',
        ]);

        $this->assertDatabaseHas('notifications', [
            'user_id' => $customer->id,
            'shipment_id' => $adminShipment->id,
            'type' => 'report_update',
            'is_read' => false,
        ]);
    }
}
