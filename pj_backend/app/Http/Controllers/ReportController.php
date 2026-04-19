<?php

namespace App\Http\Controllers;

use App\Models\Report;
use App\Models\Shipment;
use Illuminate\Http\Request;

class ReportController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
        $query = Report::with('shipment');

        if ($user->role === 'customer') {
            $query->whereHas('shipment', function ($q) use ($user) {
                $q->where('customer_id', $user->id);
            });
        }

        return response()->json($query->latest()->paginate(15));
    }

    public function store(Request $request)
    {
        $request->validate([
            'shipment_id' => 'required|exists:shipments,id',
            'customer_comment' => 'required|string',
        ]);

        $shipment = Shipment::findOrFail($request->shipment_id);

        if ($shipment->customer_id !== $request->user()->id) {
            return response()->json(['message' => 'Unauthorized.'], 403);
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
        $request->validate([
            'staff_response' => 'nullable|string',
            'status' => 'required|in:open,resolved,rejected,compensation_issued',
        ]);

        $report = Report::findOrFail($id);
        
        $data = ['status' => $request->status];
        if ($request->has('staff_response')) {
            $data['staff_response'] = $request->staff_response;
        }

        if ($request->status !== 'open' && $report->status === 'open') {
            $data['resolved_at'] = now();
        }

        $report->update($data);

        return response()->json($report);
    }
}
