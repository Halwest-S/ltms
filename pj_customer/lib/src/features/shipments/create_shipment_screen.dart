import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/api_provider.dart';
import '../../core/theme.dart';
import 'shipment_provider.dart';
import 'package:pj_l10n/pj_l10n.dart';

class CreateShipmentScreen extends ConsumerStatefulWidget {
  const CreateShipmentScreen({super.key});

  @override
  ConsumerState<CreateShipmentScreen> createState() => _CreateShipmentScreenState();
}

class _CreateShipmentScreenState extends ConsumerState<CreateShipmentScreen> {
  final _originCtrl = TextEditingController();
  final _destCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _lenCtrl = TextEditingController();
  final _widCtrl = TextEditingController();
  final _hgtCtrl = TextEditingController();

  int _categoryId = 3;
  int _vehicleTypeId = 3;
  int _step = 0;
  bool _isLoading = false;
  bool _isLoadingPricing = false;
  Map<String, dynamic>? _pricing;

  static const _categories = [
    (1, 'General'),
    (2, 'Fragile'),
    (3, 'Electronics'),
  ];
  static const _vehicles = [
    (3, '\u{1F69B}', 'Truck', '+2 days · High capacity', '×1.5', 'ground'), // Truck 🚚
    (4, '\u{2708}\u{FE0F}', 'Airplane', '-2 days · Express', '×2.5', 'air'), // Airplane ✈️
    (8, '\u{1F6A2}', 'Ship', '+10 days · Sea freight', '×0.8', 'sea'), // Ship 🚢
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final tt = Theme.of(context).textTheme;
    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _step > 0) {
          setState(() => _step--);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              if (_step > 0) {
                setState(() => _step--);
              } else {
                context.pop();
              }
            },
          ),
          title: Text(L10n.of(context)!.newShipment),
        ),
      body: Column(
        children: [
          // Step Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: Column(children: [
              Row(children: List.generate(4, (i) => Expanded(child: Container(
                height: 4, margin: EdgeInsets.only(right: i < 3 ? 5 : 0),
                decoration: BoxDecoration(
                  color: i < _step ? AppTheme.teal : i == _step ? AppTheme.ink : AppTheme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              )))),
              const SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                for (final (i, label) in [l10n.vehicleStep, l10n.routeStep, l10n.detailsStep, l10n.reviewStep].indexed)
                  Text(label, style: TextStyle(fontSize: 11, fontWeight: i <= _step ? FontWeight.w600 : FontWeight.w500, color: i == _step ? AppTheme.ink : AppTheme.muted)),
              ]),
            ]),
          ),
          const SizedBox(height: 8),

          // Content
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: [_buildVehicleStep, _buildRouteStep, _buildDetailsStep, _buildReviewStep][_step](tt),
            ),
          ),
        ],
      ),
    ));
  }

  // ── Step 0: Vehicle ──
  Widget _buildVehicleStep(TextTheme tt) {
    final l10n = L10n.of(context)!;
    return SingleChildScrollView(
      key: const ValueKey(0),
      padding: const EdgeInsets.all(18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(l10n.chooseTransport, style: tt.displaySmall),
        const SizedBox(height: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTransportSection(l10n.groundTransport, 'ground', tt),
            const SizedBox(height: 20),
            _buildTransportSection(l10n.airTransport, 'air', tt),
            const SizedBox(height: 20),
            _buildTransportSection(l10n.seaTransport, 'sea', tt),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: () => setState(() => _step = 1), child: Text(l10n.continueBtn)),
      ]),
    );
  }

  // ── Step 1: Route ──
  Widget _buildRouteStep(TextTheme tt) {
    final l10n = L10n.of(context)!;
    return SingleChildScrollView(
      key: const ValueKey(1),
      padding: const EdgeInsets.all(18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(l10n.whereIsItGoing, style: tt.displaySmall),
        const SizedBox(height: 4),
        Text(l10n.enterOriginDestination, style: tt.bodyMedium?.copyWith(color: AppTheme.muted)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppTheme.border)),
          child: Column(children: [
            _labeledField(l10n.originCity, _originCtrl, l10n.originHint),
            const Divider(height: 20),
            _labeledField(l10n.destinationCity, _destCtrl, l10n.destinationHint),
          ]),
        ),
        const SizedBox(height: 24),
        ElevatedButton(onPressed: () => setState(() => _step = 2), child: Text(l10n.continueBtn)),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: () => setState(() => _step = 0), child: Text(l10n.backBtn)),
      ]),
    );
  }

  // ── Step 2: Details ──
  Widget _buildDetailsStep(TextTheme tt) {
    final l10n = L10n.of(context)!;
    final vehicle = _vehicles.firstWhere((v) => v.$1 == _vehicleTypeId, orElse: () => _vehicles.first);
    final isAir = vehicle.$6 == 'air';
    return SingleChildScrollView(
      key: const ValueKey(2),
      padding: const EdgeInsets.all(18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(l10n.whatAreSending, style: tt.displaySmall),
        const SizedBox(height: 16),
        if (isAir) ...[
          Text(l10n.weightKg, style: tt.labelLarge),
          const SizedBox(height: 5),
          TextField(controller: _weightCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(hintText: l10n.weightPlaceholder)),
        ] else ...[
          Text(l10n.dimensionsCm, style: tt.labelLarge),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(child: TextField(controller: _lenCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(hintText: l10n.lengthLabel, filled: false))),
              const SizedBox(width: 10),
              Expanded(child: TextField(controller: _widCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(hintText: l10n.widthLabel, filled: false))),
              const SizedBox(width: 10),
              Expanded(child: TextField(controller: _hgtCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(hintText: l10n.heightLabel, filled: false))),
            ],
          ),
        ],
        const SizedBox(height: 14),
        Text(l10n.category, style: tt.labelLarge),
        const SizedBox(height: 6),
        Wrap(spacing: 7, runSpacing: 7, children: _categories.map((e) {
          final (id, label) = e;
          final localizedLabel = id == 1 ? l10n.categoryGeneral : id == 2 ? l10n.categoryFragile : l10n.categoryElectronics;
          final sel = _categoryId == id;
          return GestureDetector(
            onTap: () => setState(() => _categoryId = id),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
              decoration: BoxDecoration(
                color: sel ? AppTheme.ink : null,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: sel ? AppTheme.ink : AppTheme.border, width: 1.5),
              ),
              child: Text(localizedLabel, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: sel ? Colors.white : AppTheme.muted)),
            ),
          );
        }).toList()),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isLoadingPricing ? null : () async {
            setState(() => _isLoadingPricing = true);
            final errorMsg = await _calculatePricing();
            setState(() => _isLoadingPricing = false);
            if (errorMsg == null) {
              setState(() => _step = 3);
            } else {
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMsg)));
            }
          }, 
          child: _isLoadingPricing ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(l10n.continueBtn),
        ),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: () => setState(() => _step = 1), child: Text(l10n.backBtn)),
      ]),
    );
  }

  // ── Step 3: Review ──
  Widget _buildReviewStep(TextTheme tt) {
    final l10n = L10n.of(context)!;
    final vehicle = _vehicles.firstWhere((v) => v.$1 == _vehicleTypeId, orElse: () => _vehicles.first);
    final isAir = vehicle.$6 == 'air';
    return SingleChildScrollView(
      key: const ValueKey(3),
      padding: const EdgeInsets.all(18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // Price Box
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [AppTheme.ink, Color(0xFF2D2F4A)]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l10n.estimatedTotal, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.7, color: Colors.white.withAlpha(153))),
            const SizedBox(height: 4),
            Text('\$${_pricing != null ? (double.tryParse(_pricing!['total_price'].toString()) ?? 0.0).toStringAsFixed(2) : '---'}', style: const TextStyle(fontFamily: 'InstrumentSerif', fontStyle: FontStyle.italic, fontSize: 36, color: Color(0xFFA7F3D0))),
            const SizedBox(height: 6),
            Text(l10n.estimatedDeliveryDays(_pricing?['estimated_delivery_days'] ?? 5), style: TextStyle(fontSize: 12, color: Colors.white.withAlpha(153))),
          ]),
        ),
        const SizedBox(height: 12),

        // Summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppTheme.border)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l10n.shipmentSummary, style: tt.labelLarge?.copyWith(color: AppTheme.muted, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            _brRow(l10n.routeStep, '${_originCtrl.text} \u{2192} ${_destCtrl.text}'), // Arrow →
            if (isAir) _brRow(l10n.weightRow, '${_weightCtrl.text} kg') else _brRow(l10n.dimensionsRow, '${_lenCtrl.text} x ${_widCtrl.text} x ${_hgtCtrl.text} cm'),
            _brRow(l10n.category, _getLocalizedCategory(l10n, _categoryId)),
            _brRow(l10n.vehicleStep, _getLocalizedVehicleName(l10n, _vehicleTypeId)),
          ]),
        ),
        const SizedBox(height: 16),

        // Submit
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.teal, minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
          child: _isLoading
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
            : Text(l10n.confirmShipment),
        ),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: () => setState(() => _step = 2), child: Text(l10n.backBtn)),
      ]),
    );
  }

  String _getLocalizedCategory(L10n l10n, int id) {
    return switch (id) {
      1 => l10n.categoryGeneral,
      2 => l10n.categoryFragile,
      3 => l10n.categoryElectronics,
      _ => l10n.categoryGeneral,
    };
  }

  String _getLocalizedVehicleName(L10n l10n, int id) {
    return switch (id) {
      3 => l10n.transportTruck,
      4 => l10n.transportAirplane,
      8 => l10n.transportShip,
      _ => L10n.of(context)!.vehicleType,
    };
  }

  String _getLocalizedVehicleMeta(L10n l10n, int id) {
    return switch (id) {
      3 => l10n.transportTruckMeta,
      4 => l10n.transportAirplaneMeta,
      8 => l10n.transportShipMeta,
      _ => '',
    };
  }

  Widget _labeledField(String label, TextEditingController ctrl, String hint) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: Theme.of(context).textTheme.labelLarge),
      const SizedBox(height: 5),
      TextField(controller: ctrl, decoration: InputDecoration(hintText: hint, border: InputBorder.none, filled: false)),
    ],
  );

  Widget _brRow(String key, String val) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(key, style: const TextStyle(color: AppTheme.muted, fontWeight: FontWeight.w500, fontSize: 13)),
      Flexible(child: Text(val, style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.ink, fontSize: 13), textAlign: TextAlign.end)),
    ]),
  );

  Future<String?> _calculatePricing() async {
    final vehicle = _vehicles.firstWhere((v) => v.$1 == _vehicleTypeId, orElse: () => _vehicles.first);
    final isAir = vehicle.$6 == 'air';
    double? w;
    String? s;
    if (isAir) {
      final cleanWeight = _weightCtrl.text.replaceAll(RegExp(r'[^0-9.]'), '');
      w = double.tryParse(cleanWeight) ?? 0;
      if (w <= 0) return L10n.of(context)!.validWeightError;
      _weightCtrl.text = cleanWeight;
    } else {
      final l = double.tryParse(_lenCtrl.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      final wd = double.tryParse(_widCtrl.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      final h = double.tryParse(_hgtCtrl.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      if (l <= 0 || wd <= 0 || h <= 0) return L10n.of(context)!.validDimensionsError;
      s = '${l}x${wd}x$h';
      
      _lenCtrl.text = l.toStringAsFixed(0);
      _widCtrl.text = wd.toStringAsFixed(0);
      _hgtCtrl.text = h.toStringAsFixed(0);
    }

    try {
      final r = await ref.read(apiClientProvider).calculatePricing(
        weight: w,
        size: s,
        categoryId: _categoryId,
        vehicleTypeId: _vehicleTypeId,
      );
      setState(() {
        _pricing = r.data;
      });
      return null;
    } catch (e) {
      debugPrint('Pricing calculation error: $e');
      if (e.toString().contains('DioException [bad response]')) {
         try {
           final dioErr = e as dynamic;
            return 'هەڵەی API ${dioErr.response?.statusCode}: ${dioErr.response?.data}';
          } catch(_) {}
      }
      return 'هەڵەی API: $e';
    }
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    final vehicle = _vehicles.firstWhere((v) => v.$1 == _vehicleTypeId, orElse: () => _vehicles.first);
    final isAir = vehicle.$6 == 'air';
    try {
      final l = double.tryParse(_lenCtrl.text) ?? 0;
      final w = double.tryParse(_widCtrl.text) ?? 0;
      final h = double.tryParse(_hgtCtrl.text) ?? 0;
      await ref.read(apiClientProvider).createShipment({
        'origin': _originCtrl.text, 'destination': _destCtrl.text,
        if (isAir) 'weight_kg': double.tryParse(_weightCtrl.text) ?? 0,
        if (!isAir) 'size': '${l}x${w}x$h',
        'category_id': _categoryId, 'vehicle_type_id': _vehicleTypeId,
      });
      ref.invalidate(customerShipmentsProvider);
      if (mounted) { context.go('/'); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(L10n.of(context)!.shipmentCreated))); }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${L10n.of(context)!.error}: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildTransportSection(String title, String method, TextTheme tt) {
    final filteredVehicles = _vehicles.where((v) => v.$6 == method).toList();
    if (filteredVehicles.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...List.generate(filteredVehicles.length, (i) {
          final vehicle = filteredVehicles[i];
          final (id, icon, name, meta, mult, _) = vehicle;
          final sel = _vehicleTypeId == id;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () => setState(() => _vehicleTypeId = id),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: sel ? const Color(0xFFF7F7F5) : AppTheme.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: sel ? AppTheme.ink : AppTheme.border, width: 1.5),
                ),
                child: Row(children: [
                  Text(icon, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(_getLocalizedVehicleName(L10n.of(context)!, id), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.ink)),
                    Text(_getLocalizedVehicleMeta(L10n.of(context)!, id), style: const TextStyle(fontSize: 11, color: AppTheme.muted)),
                  ])),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: AppTheme.tealLight, borderRadius: BorderRadius.circular(6)),
                    child: Text(mult, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.teal)),
                  ),
                ]),
              ),
            ),
          );
        }),
      ],
    );
  }
}
