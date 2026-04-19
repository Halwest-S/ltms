import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_l10n/pj_l10n.dart';

import '../../core/admin_shell.dart';
import '../../core/api_provider.dart';
import '../../core/response_parsing.dart';
import '../../core/theme.dart';

final pricingProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final response = await ref.read(apiClientProvider).getAdminPricing();
  return extractMapBody(response.data);
});

class PricingConfigScreen extends ConsumerStatefulWidget {
  const PricingConfigScreen({super.key});

  @override
  ConsumerState<PricingConfigScreen> createState() =>
      _PricingConfigScreenState();
}

class _PricingConfigScreenState extends ConsumerState<PricingConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  final _basePriceCtrl = TextEditingController();
  final _weightRateCtrl = TextEditingController();
  final _sizeDivisorCtrl = TextEditingController();
  final _sizeMinChargeCtrl = TextEditingController();

  bool _isSaving = false;
  bool _hasInitializedForm = false;
  double? _initialBasePrice;
  double? _initialWeightRate;
  double? _initialSizeDivisor;
  double? _initialSizeMinCharge;

  @override
  void initState() {
    super.initState();
    _basePriceCtrl.addListener(_onFieldChanged);
    _weightRateCtrl.addListener(_onFieldChanged);
    _sizeDivisorCtrl.addListener(_onFieldChanged);
    _sizeMinChargeCtrl.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _basePriceCtrl
      ..removeListener(_onFieldChanged)
      ..dispose();
    _weightRateCtrl
      ..removeListener(_onFieldChanged)
      ..dispose();
    _sizeDivisorCtrl
      ..removeListener(_onFieldChanged)
      ..dispose();
    _sizeMinChargeCtrl
      ..removeListener(_onFieldChanged)
      ..dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _applyConfig(Map<String, dynamic> config) {
    final basePrice = _parseStoredNumber(config['base_price']) ?? 0;
    final weightRate = _parseStoredNumber(config['weight_rate']) ?? 0;
    final sizeDivisor = _parseStoredNumber(config['size_divisor']) ?? 5000;
    final sizeMinCharge = _parseStoredNumber(config['size_min_charge']) ?? 10;

    _initialBasePrice = basePrice;
    _initialWeightRate = weightRate;
    _initialSizeDivisor = sizeDivisor;
    _initialSizeMinCharge = sizeMinCharge;
    _basePriceCtrl.text = _formatNumber(basePrice);
    _weightRateCtrl.text = _formatNumber(weightRate);
    _sizeDivisorCtrl.text = _formatNumber(sizeDivisor);
    _sizeMinChargeCtrl.text = _formatNumber(sizeMinCharge);
    _hasInitializedForm = true;
  }

  double? _parseStoredNumber(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  double? _parseFieldValue(String value) {
    final normalized = value.trim().replaceAll(',', '.');
    if (normalized.isEmpty) return null;
    return double.tryParse(normalized);
  }

  String _formatNumber(num value) {
    final asText = value.toString();
    return asText.endsWith('.0')
        ? asText.substring(0, asText.length - 2)
        : asText;
  }

  String _screenText(
    BuildContext context, {
    required String ku,
    required String en,
  }) {
    return L10n.of(context)!.localeName == 'ku' ? ku : en;
  }

  String? _validatePriceField(
    BuildContext context,
    String? value, {
    bool allowZero = true,
    bool mustBePositive = false,
  }) {
    final l10n = L10n.of(context)!;
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return l10n.required;
    final parsed = _parseFieldValue(trimmed);
    if (parsed == null) {
      return _screenText(
        context,
        ku: 'تکایە ژمارەیەکی دروست بنووسە',
        en: 'Please enter a valid number',
      );
    }
    if (!allowZero && parsed == 0) {
      return _screenText(
        context,
        ku: 'نابێت بە صفر بێت',
        en: 'Value cannot be zero',
      );
    }
    if (mustBePositive && parsed <= 0) {
      return _screenText(
        context,
        ku: 'تکایە ژمارەیەک لە صفر گەورەتر بنووسە',
        en: 'Please enter a number greater than zero',
      );
    }
    return null;
  }

  bool get _isDirty {
    final currentBasePrice = _parseFieldValue(_basePriceCtrl.text);
    final currentWeightRate = _parseFieldValue(_weightRateCtrl.text);
    final currentSizeDivisor = _parseFieldValue(_sizeDivisorCtrl.text);
    final currentSizeMinCharge = _parseFieldValue(_sizeMinChargeCtrl.text);
    if (currentBasePrice == null ||
        currentWeightRate == null ||
        currentSizeDivisor == null ||
        currentSizeMinCharge == null) {
      return false;
    }
    return currentBasePrice != _initialBasePrice ||
        currentWeightRate != _initialWeightRate ||
        currentSizeDivisor != _initialSizeDivisor ||
        currentSizeMinCharge != _initialSizeMinCharge;
  }

  Future<void> _resetForm() async {
    if (_initialBasePrice == null ||
        _initialWeightRate == null ||
        _initialSizeDivisor == null ||
        _initialSizeMinCharge == null) {
      return;
    }
    _basePriceCtrl.text = _formatNumber(_initialBasePrice!);
    _weightRateCtrl.text = _formatNumber(_initialWeightRate!);
    _sizeDivisorCtrl.text = _formatNumber(_initialSizeDivisor!);
    _sizeMinChargeCtrl.text = _formatNumber(_initialSizeMinCharge!);
  }

  Future<void> _savePricing() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = L10n.of(context)!;
    final basePrice = _parseFieldValue(_basePriceCtrl.text);
    final weightRate = _parseFieldValue(_weightRateCtrl.text);
    final sizeDivisor = _parseFieldValue(_sizeDivisorCtrl.text);
    final sizeMinCharge = _parseFieldValue(_sizeMinChargeCtrl.text);
    if (basePrice == null ||
        weightRate == null ||
        sizeDivisor == null ||
        sizeMinCharge == null) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final response = await ref.read(apiClientProvider).updateAdminPricing({
        'base_price': basePrice,
        'weight_rate': weightRate,
        'size_divisor': sizeDivisor,
        'size_min_charge': sizeMinCharge,
      });

      final savedConfig = extractMapBody(response.data);
      if (mounted) {
        setState(() {
          _applyConfig(savedConfig);
        });
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text('${l10n.success}: ${l10n.updatePricing}')),
          );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('${l10n.error}: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String _moneyValue(TextEditingController controller) {
    return '\$${controller.text}';
  }

  String _compactValue(TextEditingController controller) {
    return controller.text.isEmpty ? '0' : controller.text;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final pricingAsync = ref.watch(pricingProvider);
    final isCompact = MediaQuery.sizeOf(context).width < 960;

    return AdminShell(
      activeRoute: '/pricing',
      title: l10n.pricingConfiguration,
      actions: [
        IconButton(
          onPressed: () => ref.refresh(pricingProvider),
          tooltip: l10n.refresh,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
      child: pricingAsync.when(
        data: (config) {
          if (!_hasInitializedForm || (!_isDirty && !_isSaving)) {
            _applyConfig(config);
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(isCompact ? 16 : 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isCompact) ...[
                      Text(
                        l10n.pricingConfiguration,
                        style: textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _screenText(
                          context,
                          ku: 'نرخی داواکاری بە کێش و بە قەبارە لێرە لە یەک شوێن ڕێکبخە.',
                          en: 'Manage both weight-based and size-based shipment pricing here.',
                        ),
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppTheme.muted,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ] else ...[
                      Text(
                        l10n.pricingConfiguration,
                        style: textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                    ],
                    Text(
                      _screenText(
                        context,
                        ku: 'ڕێکخستنی نرخ',
                        en: 'Pricing settings',
                      ),
                      style: textTheme.labelLarge?.copyWith(
                        color: AppTheme.ink,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppTheme.card,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _PricingField(
                              controller: _basePriceCtrl,
                              label: l10n.basePrice,
                              helperText: _screenText(
                                context,
                                ku: 'نرخی سەرەکی بۆ هەر داواکارییەک',
                                en: 'Starting price added to every shipment',
                              ),
                              prefixIcon: Icons.attach_money_rounded,
                              suffixText: 'USD',
                              validator: (value) =>
                                  _validatePriceField(context, value),
                            ),
                            const SizedBox(height: 18),
                            _PricingField(
                              controller: _weightRateCtrl,
                              label: _screenText(
                                context,
                                ku: 'نرخی داواکاری بە کێش',
                                en: 'Weight order rate',
                              ),
                              helperText: _screenText(
                                context,
                                ku: 'بۆ داواکارییەکانی هەوا بە پێی کیلۆگرام بەکاردێت',
                                en: 'Used for shipments ordered by kilogram',
                              ),
                              prefixIcon: Icons.scale_rounded,
                              suffixText: '/kg',
                              validator: (value) =>
                                  _validatePriceField(context, value),
                            ),
                            const SizedBox(height: 18),
                            _PricingField(
                              controller: _sizeDivisorCtrl,
                              label: _screenText(
                                context,
                                ku: 'دابەشکەری قەبارە',
                                en: 'Size divisor',
                              ),
                              helperText: _screenText(
                                context,
                                ku: 'قەبارەی L×W×H بە سێجا پاشان بەسەر ئەم ژمارەیە دابەش دەکرێت',
                                en: 'Converts L×W×H dimensions into volumetric kilograms',
                              ),
                              prefixIcon: Icons.straighten_rounded,
                              suffixText: 'cm³/kg',
                              validator: (value) => _validatePriceField(
                                context,
                                value,
                                allowZero: false,
                                mustBePositive: true,
                              ),
                            ),
                            const SizedBox(height: 18),
                            _PricingField(
                              controller: _sizeMinChargeCtrl,
                              label: _screenText(
                                context,
                                ku: 'کەمترین نرخی قەبارە',
                                en: 'Minimum size charge',
                              ),
                              helperText: _screenText(
                                context,
                                ku: 'کەمترین بڕی زیادکراو بۆ داواکاری بە قەبارە',
                                en: 'Minimum extra charge for size-based orders',
                              ),
                              prefixIcon: Icons.inventory_2_outlined,
                              suffixText: 'USD',
                              validator: (value) =>
                                  _validatePriceField(context, value),
                            ),
                            const SizedBox(height: 24),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                OutlinedButton(
                                  onPressed: _isSaving || !_isDirty
                                      ? null
                                      : _resetForm,
                                  child: Text(l10n.cancel),
                                ),
                                ElevatedButton.icon(
                                  onPressed: _isSaving || !_isDirty
                                      ? null
                                      : _savePricing,
                                  icon: _isSaving
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(Icons.save_rounded),
                                  label: Text(l10n.updatePricing),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final stacked = constraints.maxWidth < 760;
                        final weightCard = _PricingModeCard(
                          icon: Icons.monitor_weight_outlined,
                          iconColor: AppTheme.teal,
                          title: _screenText(
                            context,
                            ku: 'داواکاری بە کێش',
                            en: 'Order by kg',
                          ),
                          description: _screenText(
                            context,
                            ku: 'کڕیار کێش بە کیلۆگرام دەنێرێت و نرخ بە پێی کێش هەژمار دەکرێت.',
                            en: 'Customer enters shipment weight in kilograms.',
                          ),
                          stats: [
                            _ModeStat(
                              label: l10n.basePrice,
                              value: _moneyValue(_basePriceCtrl),
                            ),
                            _ModeStat(
                              label: l10n.weightRate,
                              value: '${_moneyValue(_weightRateCtrl)} /kg',
                            ),
                          ],
                          formula: _screenText(
                            context,
                            ku: 'کۆی = (${_moneyValue(_basePriceCtrl)} + کێش × ${_compactValue(_weightRateCtrl)}) + خەرێک، پاشان لە لێکدەری ئامێر دەدرێت.',
                            en: 'Total = (${_moneyValue(_basePriceCtrl)} + kg × ${_compactValue(_weightRateCtrl)}) + surcharge, then multiplied by vehicle.',
                          ),
                        );
                        final sizeCard = _PricingModeCard(
                          icon: Icons.straighten_rounded,
                          iconColor: AppTheme.blue,
                          title: _screenText(
                            context,
                            ku: 'داواکاری بە قەبارە',
                            en: 'Order by size',
                          ),
                          description: _screenText(
                            context,
                            ku: 'قەبارەی L×W×H بۆ کێشی ئەندازیاری دەگۆڕدرێت، پاشان هەمان نرخی کێش بەکاردێت.',
                            en: 'Dimensions are converted to volumetric kilograms before applying the rate.',
                          ),
                          stats: [
                            _ModeStat(
                              label: _screenText(
                                context,
                                ku: 'دابەشکەر',
                                en: 'Divisor',
                              ),
                              value: _compactValue(_sizeDivisorCtrl),
                            ),
                            _ModeStat(
                              label: _screenText(
                                context,
                                ku: 'کەمترین نرخ',
                                en: 'Minimum charge',
                              ),
                              value: _moneyValue(_sizeMinChargeCtrl),
                            ),
                          ],
                          formula: _screenText(
                            context,
                            ku: 'نرخی قەبارە = max(((L×W×H) ÷ ${_compactValue(_sizeDivisorCtrl)}) × ${_compactValue(_weightRateCtrl)}, ${_moneyValue(_sizeMinChargeCtrl)}).',
                            en: 'Size charge = max(((L×W×H) ÷ ${_compactValue(_sizeDivisorCtrl)}) × ${_compactValue(_weightRateCtrl)}, ${_moneyValue(_sizeMinChargeCtrl)}).',
                          ),
                        );

                        if (stacked) {
                          return Column(
                            children: [
                              weightCard,
                              const SizedBox(height: 16),
                              sizeCard,
                            ],
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: weightCard),
                            const SizedBox(width: 16),
                            Expanded(child: sizeCard),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.blueLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.lightbulb_outline_rounded,
                            color: Color(0xFF1E40AF),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _screenText(
                                context,
                                ku: 'هەوا بە کێش هەژمار دەکرێت. زەوی و دەریا دەتوانن بە قەبارە هەژمار بکرێن لە ڕێگەی دابەشکردنی L×W×H بە ${_compactValue(_sizeDivisorCtrl)}.',
                                en: 'Air shipments use kg pricing. Ground and sea shipments can use size pricing through the L×W×H ÷ ${_compactValue(_sizeDivisorCtrl)} volumetric rule.',
                              ),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF1E40AF),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('${L10n.of(context)!.error}: $error')),
      ),
    );
  }
}

class _PricingField extends StatelessWidget {
  const _PricingField({
    required this.controller,
    required this.label,
    required this.helperText,
    required this.prefixIcon,
    required this.suffixText,
    required this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String helperText;
  final IconData prefixIcon;
  final String suffixText;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: AppTheme.ink),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
          ],
          decoration: InputDecoration(
            helperText: helperText,
            prefixIcon: Icon(prefixIcon),
            suffixText: suffixText,
          ),
        ),
      ],
    );
  }
}

class _ModeStat {
  const _ModeStat({required this.label, required this.value});

  final String label;
  final String value;
}

class _PricingModeCard extends StatelessWidget {
  const _PricingModeCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.stats,
    required this.formula,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final List<_ModeStat> stats;
  final String formula;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(24),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.muted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          ...stats.map(
            (stat) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Text(
                    stat.label,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    stat.value,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppTheme.ink,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Text(
              formula,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.ink,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
