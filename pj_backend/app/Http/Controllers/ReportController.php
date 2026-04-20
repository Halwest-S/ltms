<?php

namespace App\Http\Controllers;

use App\Models\Report;
use App\Models\Shipment;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class ReportController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        $query = Report::with([
            'shipment',
            'resolver:id,name,email,phone_number,role',
        ]);

        if ($user->role === 'customer') {
            $query->whereHas('shipment', function ($q) use ($user) {
                $q->where('customer_id', $user->id);
            });
        } elseif (!in_array($user->role, ['staff', 'super_admin'], true)) {
            return response()->json(['message' => 'Unauthorized.'], 403);
        }

        return response()->json($query->latest()->paginate(15));
    }

    public function store(Request $request)
    {
        if ($request->user()->role !== 'customer') {
            return response()->json(['message' => 'Only customers can submit reports.'], 403);
        }

        if (!$request->filled('shipment_id') && $request->route('id') !== null) {
            $request->merge(['shipment_id' => $request->route('id')]);
        }

        $request->validate([
            'shipment_id' => 'required|exists:shipments,id',
            'customer_comment' => 'required|string',
        ]);

        $shipment = Shipment::findOrFail($request->shipment_id);

        if ($shipment->customer_id !== $request->user()->id) {
            return response()->json(['message' => 'Unauthorized.'], 403);
        }

        if ($shipment->delivery_confirmed_at !== null) {
            return response()->json([
                'message' => 'This import has already been confirmed as delivered.',
            ], 422);
        }

        if ($shipment->report()->exists()) {
            return response()->json([
                'message' => 'This import already has a report.',
            ], 422);
        }

        $report = Report::create([
            'shipment_id' => $shipment->id,
            'customer_comment' => $request->customer_comment,
            'status' => 'open',
        ]);

        $shipment->update(['status' => 'reported']);

        return response()->json($report, 201);
    }

    public function update(Request $request, $id)
    {
        if (!in_array($request->user()->role, ['staff', 'super_admin'], true)) {
            return response()->json(['message' => 'Unauthorized.'], 403);
        }

        $attributes = $request->validate([
            'staff_response' => ['required', 'string', 'min:3'],
            'status' => ['required', Rule::in(['resolved', 'rejected', 'compensation_issued'])],
        ]);

        $report = Report::findOrFail($id);

        $data = [
            'status' => $attributes['status'],
            'staff_response' => $attributes['staff_response'],
            'resolved_by_id' => $request->user()->id,
        ];

        if ($report->status === 'open') {
            $data['resolved_at'] = now();
        }

        $report->update($data);

        return response()->json(
            $report->load('resolver:id,name,email,phone_number,role')
        );
    }
}
