import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pj_l10n/pj_l10n.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/api_provider.dart';
import '../../core/theme.dart';
import 'shipment_provider.dart';

class CreateShipmentScreen extends ConsumerStatefulWidget {
  const CreateShipmentScreen({super.key});

  @override
  ConsumerState<CreateShipmentScreen> createState() =>
      _CreateShipmentScreenState();
}

class _CreateShipmentScreenState extends ConsumerState<CreateShipmentScreen> {
  final _productUrlCtrl = TextEditingController();
  final _destinationCtrl = TextEditingController();
  final _colorCtrl = TextEditingController();
  final _productSizeCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _lengthCtrl = TextEditingController();
  final _widthCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();

  int _step = 0;
  int _categoryId = 3;
  int? _vehicleTypeId;
  bool _isLoadingProduct = false;
  bool _isLoadingTransport = false;
  bool _isLoadingPricing = false;
  bool _isSubmitting = false;
  Map<String, dynamic>? _productPreview;
  Map<String, dynamic>? _pricing;
  List<_TransportOption> _transportOptions = const [];

  static const _platforms = [
    _Marketplace(
      id: 'amazon',
      name: 'Amazon',
      url: 'https://www.amazon.com/',
      logoAsset: 'assets/brand/amazon.svg',
      logoWidth: 120,
    ),
    _Marketplace(
      id: 'alibaba',
      name: 'Alibaba',
      url: 'https://www.alibaba.com/',
      logoAsset: 'assets/brand/alibaba.svg',
      logoWidth: 158,
    ),
  ];

  static const _categories = [
    (1, 'General'),
    (2, 'Fragile'),
    (3, 'Electronics'),
  ];

  static const _fallbackTransportOptions = [
    _TransportOption(
      id: 4,
      nameEn: 'Airplane',
      nameKu: 'فڕۆکە',
      transportMethod: 'air',
      multiplier: 2.5,
      deliveryDaysOffset: -2,
    ),
    _TransportOption(
      id: 3,
      nameEn: 'Truck',
      nameKu: 'باری هەڵگر',
      transportMethod: 'ground',
      multiplier: 1.5,
      deliveryDaysOffset: 2,
    ),
    _TransportOption(
      id: 8,
      nameEn: 'Ship',
      nameKu: 'کەشتی',
      transportMethod: 'sea',
      multiplier: 0.8,
      deliveryDaysOffset: 10,
    ),
  ];

  static const _kurdistanDestinationKeywords = [
    'kurdistan',
    'erbil',
    'hawler',
    'hewler',
    'sulaimani',
    'sulaymaniyah',
    'slemani',
    'silemani',
    'duhok',
    'dohuk',
    'zakho',
    'zaxo',
    'halabja',
    'kirkuk',
    'kerkuk',
    'koya',
    'akre',
    'aqra',
    'ranya',
    'shaqlawa',
    'chamchamal',
    'kalar',
    'کوردستان',
    'هەولێر',
    'سلێمانی',
    'دهۆک',
    'دهوك',
    'زاخۆ',
    'هەڵەبجە',
    'کەرکووک',
    'کۆیە',
    'ئاکرێ',
    'ڕانیە',
    'شقڵاوە',
    'چەمچەماڵ',
    'کەلار',
  ];

  @override
  void initState() {
    super.initState();
    _loadTransportOptions();
  }

  @override
  void dispose() {
    _productUrlCtrl.dispose();
    _destinationCtrl.dispose();
    _colorCtrl.dispose();
    _productSizeCtrl.dispose();
    _weightCtrl.dispose();
    _lengthCtrl.dispose();
    _widthCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

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
          title: Text(l10n.newShipment),
        ),
        body: Column(
          children: [
            _buildStepIndicator(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: [
                  _buildProductStep,
                  _buildDestinationStep,
                  _buildSpecsStep,
                  _buildShippingStep,
                  _buildReviewStep,
                ][_step](tt),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    final labels = [
      _t(ku: 'بەرهەم', en: 'Product'),
      _t(ku: 'گەیاندن', en: 'Delivery'),
      _t(ku: 'وردەکاری', en: 'Specs'),
      _t(ku: 'گواستنەوە', en: 'Shipping'),
      _t(ku: 'پێداچوونەوە', en: 'Review'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
      child: Column(
        children: [
          Row(
            children: List.generate(labels.length, (index) {
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsetsDirectional.only(
                    end: index < labels.length - 1 ? 5 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: index < _step
                        ? AppTheme.teal
                        : index == _step
                        ? AppTheme.ink
                        : AppTheme.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final (index, label) in labels.indexed)
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: index <= _step
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: index == _step ? AppTheme.ink : AppTheme.muted,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _screen({required int keyValue, required Widget child}) {
    return SingleChildScrollView(
      key: ValueKey(keyValue),
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: child,
        ),
      ),
    );
  }

  Widget _buildProductStep(TextTheme tt) {
    return _screen(
      keyValue: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _productHeroCard(tt),
          const SizedBox(height: 18),
          _sectionLabel(
            _t(ku: 'بازاڕە فەرمییەکان', en: 'Official marketplaces'),
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 600;
              final cards = _platforms.map(_platformCard).toList();

              if (!isWide) {
                return Column(
                  children: [
                    for (final card in cards) ...[
                      card,
                      if (card != cards.last) const SizedBox(height: 10),
                    ],
                  ],
                );
              }

              return Row(
                children: [
                  for (final card in cards) ...[
                    Expanded(child: card),
                    if (card != cards.last) const SizedBox(width: 12),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          _linkInputCard(tt),
          if (_productPreview != null) ...[
            const SizedBox(height: 12),
            _productPreviewCard(tt),
          ],
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: _productPreview == null
                ? null
                : () => setState(() => _step = 1),
            child: Text(_t(ku: 'بەردەوامبوون', en: 'Continue')),
          ),
        ],
      ),
    );
  }

  Widget _productHeroCard(TextTheme tt) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.ink,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppTheme.ink.withAlpha(18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 680;
          final intro = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppTheme.teal,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                _t(
                  ku: 'کاڵاکەت لە دەرەوە هەڵبژێرە',
                  en: 'Choose your product outside LTMS',
                ),
                style: tt.headlineLarge?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                _t(
                  ku: 'ئەمازۆن یان عەلیبابا بکەرەوە، لینکی کاڵاکە کۆپی بکە، پاشان لێرە دایبنێ بۆ دروستکردنی داواکاری هاوردە.',
                  en: 'Open Amazon or Alibaba, copy the product link, then paste it here to start your import request.',
                ),
                style: tt.bodyMedium?.copyWith(
                  color: Colors.white.withAlpha(178),
                  height: 1.45,
                ),
              ),
            ],
          );

          final steps = Column(
            children: [
              _heroStep(
                number: '1',
                icon: Icons.open_in_new_rounded,
                label: _t(ku: 'ماڵپەڕ بکەرەوە', en: 'Open site'),
              ),
              const SizedBox(height: 8),
              _heroStep(
                number: '2',
                icon: Icons.link_rounded,
                label: _t(ku: 'لینک کۆپی بکە', en: 'Copy link'),
              ),
              const SizedBox(height: 8),
              _heroStep(
                number: '3',
                icon: Icons.verified_outlined,
                label: _t(ku: 'لێرە پشتڕاستی بکەوە', en: 'Validate here'),
              ),
            ],
          );

          if (!isWide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [intro, const SizedBox(height: 16), steps],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: intro),
              const SizedBox(width: 24),
              SizedBox(width: 230, child: steps),
            ],
          );
        },
      ),
    );
  }

  Widget _heroStep({
    required String number,
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withAlpha(26)),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppTheme.teal,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: AppTheme.ink,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _platformCard(_Marketplace platform) {
    final isDetected = _productPreview?['platform'] == platform.id;

    return InkWell(
      onTap: () => _openMarketplace(platform),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDetected ? AppTheme.tealLight : AppTheme.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDetected ? AppTheme.teal : AppTheme.border,
            width: isDetected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: SvgPicture.asset(
                        platform.logoAsset,
                        width: platform.logoWidth,
                        fit: BoxFit.contain,
                        semanticsLabel: platform.name,
                      ),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isDetected ? AppTheme.teal : AppTheme.tealLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isDetected
                        ? Icons.check_rounded
                        : Icons.open_in_new_rounded,
                    size: 18,
                    color: isDetected ? Colors.white : AppTheme.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(platform.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              _t(
                ku: 'ماڵپەڕی فەرمی بۆ دۆزینەوە و کۆپیکردنی لینکی کاڵا',
                en: 'Official marketplace for finding and copying a product link',
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 14),
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: isDetected ? AppTheme.teal : AppTheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDetected ? AppTheme.teal : AppTheme.border,
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.open_in_new_rounded,
                      size: 17,
                      color: isDetected ? Colors.white : AppTheme.ink,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _t(ku: 'کردنەوەی ماڵپەڕ', en: 'Open Official Site'),
                      style: TextStyle(
                        color: isDetected ? Colors.white : AppTheme.ink,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _linkInputCard(TextTheme tt) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppTheme.tealLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.link_rounded, color: AppTheme.teal),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _t(
                        ku: 'لینکی کاڵاکە دابنێ',
                        en: 'Paste the product link',
                      ),
                      style: tt.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _t(
                        ku: 'تەنها لینکی بەرهەمی ئەمازۆن یان عەلیبابا پشتڕاست دەکرێتەوە.',
                        en: 'Only Amazon or Alibaba product links are validated here.',
                      ),
                      style: tt.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _productUrlCtrl,
            keyboardType: TextInputType.url,
            textDirection: TextDirection.ltr,
            decoration: InputDecoration(
              hintText: 'https://www.amazon.com/.../dp/...',
              prefixIcon: const Icon(Icons.travel_explore_rounded),
              suffixIcon: IconButton(
                icon: const Icon(Icons.verified_outlined),
                tooltip: _t(ku: 'پشتڕاستکردنەوە', en: 'Validate'),
                onPressed: _isLoadingProduct ? null : _previewProductLink,
              ),
            ),
            onSubmitted: (_) => _previewProductLink(),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _isLoadingProduct ? null : _previewProductLink,
            icon: _isLoadingProduct
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check_circle_outline_rounded),
            label: Text(_t(ku: 'پشتڕاستکردنەوەی لینک', en: 'Validate Link')),
          ),
        ],
      ),
    );
  }

  Widget _productPreviewCard(TextTheme tt) {
    final platform =
        _productPreview?['platform_label']?.toString() ??
        _productPreview?['platform']?.toString() ??
        '';
    final title = _productPreview?['title']?.toString();
    final externalId = _productPreview?['external_id']?.toString();

    return _sectionCard(
      borderColor: AppTheme.teal,
      backgroundColor: AppTheme.tealLight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.verified, color: AppTheme.teal),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _t(ku: 'لینکەکە پشتڕاست کرایەوە', en: 'Link validated'),
                  style: tt.titleMedium?.copyWith(color: AppTheme.teal),
                ),
                const SizedBox(height: 6),
                Text(
                  [
                    platform,
                    if (externalId != null && externalId.isNotEmpty)
                      '#$externalId',
                  ].join(' '),
                  style: tt.bodySmall,
                ),
                if (title != null && title.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationStep(TextTheme tt) {
    final cityChips = [
      (_t(ku: 'هەولێر', en: 'Erbil'), 'Erbil, Kurdistan'),
      (_t(ku: 'دهۆک', en: 'Duhok'), 'Duhok, Kurdistan'),
      (_t(ku: 'سلێمانی', en: 'Sulaimaniyah'), 'Sulaimaniyah, Kurdistan'),
    ];

    return _screen(
      keyValue: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _t(
              ku: 'شوێنی گەیاندن لە کوردستان',
              en: 'Delivery inside Kurdistan',
            ),
            style: tt.displaySmall,
          ),
          const SizedBox(height: 6),
          Text(
            _t(
              ku: 'هاوردەکان بۆ شاری ناو هەرێمی کوردستان تۆمار دەکرێن.',
              en: 'Imports are registered for delivery cities in the Kurdistan Region.',
            ),
            style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (label, value) in cityChips)
                ChoiceChip(
                  selected: _destinationCtrl.text == value,
                  label: Text(label),
                  onSelected: (_) =>
                      setState(() => _destinationCtrl.text = value),
                  selectedColor: AppTheme.tealLight,
                  side: const BorderSide(color: AppTheme.border),
                ),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _destinationCtrl,
            decoration: InputDecoration(
              labelText: _t(ku: 'شاری گەیاندن', en: 'Delivery city'),
              hintText: _t(
                ku: 'نموونە: هەولێر، کوردستان',
                en: 'Example: Erbil, Kurdistan',
              ),
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () {
              if (_validateDestination()) {
                setState(() => _step = 2);
              }
            },
            child: Text(_t(ku: 'بەردەوامبوون', en: 'Continue')),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => setState(() => _step = 0),
            child: Text(_t(ku: 'گەڕانەوە', en: 'Back')),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecsStep(TextTheme tt) {
    return _screen(
      keyValue: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _t(ku: 'وردەکاری بەرهەم', en: 'Product specifications'),
            style: tt.displaySmall,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _colorCtrl,
            decoration: InputDecoration(
              labelText: _t(ku: 'ڕەنگ', en: 'Color'),
              hintText: _t(ku: 'نموونە: ڕەش', en: 'Example: Black'),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _productSizeCtrl,
            decoration: InputDecoration(
              labelText: _t(ku: 'قەبارە', en: 'Size'),
              hintText: _t(
                ku: 'نموونە: M، 42، 256GB',
                en: 'Example: M, 42, 256GB',
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _t(ku: 'جۆری بەرهەم', en: 'Product category'),
            style: tt.labelLarge,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final (id, _) in _categories)
                ChoiceChip(
                  selected: _categoryId == id,
                  label: Text(_categoryName(id)),
                  onSelected: (_) => setState(() => _categoryId = id),
                  selectedColor: AppTheme.tealLight,
                  side: const BorderSide(color: AppTheme.border),
                ),
            ],
          ),
          const SizedBox(height: 18),
          _sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _t(
                    ku: 'قەبارە و کێشی پاکێج',
                    en: 'Package weight and dimensions',
                  ),
                  style: tt.labelLarge,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _weightCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: _t(ku: 'کێش بە کیلۆگرام', en: 'Weight in kg'),
                    hintText: '2.5',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _dimensionField(
                        _lengthCtrl,
                        _t(ku: 'درێژی', en: 'Length'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _dimensionField(
                        _widthCtrl,
                        _t(ku: 'پانی', en: 'Width'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _dimensionField(
                        _heightCtrl,
                        _t(ku: 'بەرزی', en: 'Height'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () {
              if (_validateSpecs()) {
                setState(() => _step = 3);
              }
            },
            child: Text(_t(ku: 'بەردەوامبوون', en: 'Continue')),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => setState(() => _step = 1),
            child: Text(_t(ku: 'گەڕانەوە', en: 'Back')),
          ),
        ],
      ),
    );
  }

  Widget _dimensionField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label, hintText: 'cm'),
    );
  }

  Widget _buildShippingStep(TextTheme tt) {
    final options = _transportOptions.isEmpty
        ? _fallbackTransportOptions
        : _transportOptions;

    return _screen(
      keyValue: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _t(ku: 'شێوازی گواستنەوە', en: 'Shipping method'),
            style: tt.displaySmall,
          ),
          const SizedBox(height: 6),
          Text(
            _t(
              ku: 'هەوایی، وشکانی، یان دەریایی هەڵبژێرە؛ نرخ و کات بە پێی ئەم هەڵبژاردنە دەگۆڕێت.',
              en: 'Choose air, land, or sea; cost and delivery time are calculated from this option.',
            ),
            style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
          ),
          const SizedBox(height: 16),
          if (_isLoadingTransport)
            const Center(child: CircularProgressIndicator())
          else
            for (final option in options) ...[
              _transportCard(option),
              const SizedBox(height: 10),
            ],
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _isLoadingPricing ? null : _continueToReview,
            child: _isLoadingPricing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white,
                    ),
                  )
                : Text(_t(ku: 'ژماردنی نرخ', en: 'Calculate Cost')),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => setState(() => _step = 2),
            child: Text(_t(ku: 'گەڕانەوە', en: 'Back')),
          ),
        ],
      ),
    );
  }

  Widget _transportCard(_TransportOption option) {
    final selected = _vehicleTypeId == option.id;
    final days = option.estimatedDays.clamp(1, 60);

    return InkWell(
      onTap: () => setState(() {
        _vehicleTypeId = option.id;
        _pricing = null;
      }),
      borderRadius: BorderRadius.circular(12),
      child: _sectionCard(
        borderColor: selected ? AppTheme.ink : AppTheme.border,
        backgroundColor: selected ? const Color(0xFFF7F7F5) : AppTheme.card,
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppTheme.tealLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(
                  _transportIconAsset(option.transportMethod),
                  fit: BoxFit.contain,
                  semanticsLabel: _methodLabel(option.transportMethod),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.displayName(isKurdish: _isKurdish),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppTheme.ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${_methodLabel(option.transportMethod)} • ${_t(ku: '$days ڕۆژ', en: '$days days')}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? AppTheme.ink : AppTheme.tealLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _formatMultiplier(option.multiplier),
                style: TextStyle(
                  color: selected ? Colors.white : AppTheme.teal,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewStep(TextTheme tt) {
    final selectedTransport = _selectedTransport;
    final totalPrice = _asDouble(_pricing?['total_price']);
    final days = _pricing?['estimated_delivery_days']?.toString() ?? '-';

    return _screen(
      keyValue: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.ink,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _t(ku: 'کۆی خەمڵێنراو', en: 'Estimated Total'),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  totalPrice == null
                      ? '--'
                      : '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(0xFFA7F3D0),
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _t(
                    ku: 'ماوەی گەیاندنی خەمڵێنراو: $days ڕۆژ',
                    en: 'Estimated delivery: $days days',
                  ),
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _sectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _t(
                    ku: 'پوختەی داواکاری هاوردە',
                    en: 'Import Request Summary',
                  ),
                  style: tt.titleMedium,
                ),
                const SizedBox(height: 10),
                _summaryRow(_t(ku: 'سەرچاوە', en: 'Source'), _sourceOrigin),
                _summaryRow(
                  _t(ku: 'لینک', en: 'Link'),
                  _productUrlCtrl.text.trim(),
                ),
                _summaryRow(
                  _t(ku: 'گەیاندن', en: 'Delivery'),
                  _destinationCtrl.text.trim(),
                ),
                _summaryRow(
                  _t(ku: 'ڕەنگ', en: 'Color'),
                  _colorCtrl.text.trim(),
                ),
                _summaryRow(
                  _t(ku: 'قەبارە', en: 'Size'),
                  _productSizeCtrl.text.trim(),
                ),
                _summaryRow(
                  _t(ku: 'جۆر', en: 'Category'),
                  _categoryName(_categoryId),
                ),
                if (selectedTransport != null)
                  _summaryRow(
                    _t(ku: 'گواستنەوە', en: 'Shipping'),
                    '${selectedTransport.displayName(isKurdish: _isKurdish)} (${_methodLabel(selectedTransport.transportMethod)})',
                  ),
                _summaryRow(_t(ku: 'پاکێج', en: 'Package'), _packageSummary),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submit,
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.teal),
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    _t(
                      ku: 'پشتڕاستکردنەوەی داواکاری هاوردە',
                      en: 'Confirm Import Request',
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => setState(() => _step = 3),
            child: Text(_t(ku: 'گەڕانەوە', en: 'Back')),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required Widget child,
    Color borderColor = AppTheme.border,
    Color backgroundColor = AppTheme.card,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.4),
      ),
      child: child,
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.muted,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppTheme.ink,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadTransportOptions() async {
    setState(() => _isLoadingTransport = true);

    try {
      final response = await ref.read(apiClientProvider).getTransportOptions();
      final data = response.data as List;
      final options = data
          .map(
            (item) =>
                _TransportOption.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();

      if (!mounted) {
        return;
      }

      setState(() {
        _transportOptions = options.isEmpty
            ? _fallbackTransportOptions
            : options;
        _vehicleTypeId = _transportOptions.first.id;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _transportOptions = _fallbackTransportOptions;
        _vehicleTypeId = _fallbackTransportOptions.first.id;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoadingTransport = false);
      }
    }
  }

  Future<void> _openMarketplace(_Marketplace platform) async {
    final opened = await launchUrl(
      Uri.parse(platform.url),
      mode: LaunchMode.externalApplication,
    );

    if (!opened && mounted) {
      _showError(
        _t(ku: 'ماڵپەڕەکە نەکرایەوە.', en: 'Could not open the official site.'),
      );
    }
  }

  Future<void> _previewProductLink() async {
    final url = _productUrlCtrl.text.trim();

    if (url.isEmpty) {
      _showError(
        _t(
          ku: 'تکایە لینکی بەرهەم بنووسە.',
          en: 'Please enter a product link.',
        ),
      );
      return;
    }

    setState(() {
      _isLoadingProduct = true;
      _productPreview = null;
    });

    try {
      final response = await ref
          .read(apiClientProvider)
          .previewProductLink(url);
      if (!mounted) {
        return;
      }

      setState(() {
        _productPreview = Map<String, dynamic>.from(response.data);
        _productUrlCtrl.text = _productPreview?['url']?.toString() ?? url;
      });
    } catch (error) {
      if (mounted) {
        _showError(_extractApiMessage(error));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingProduct = false);
      }
    }
  }

  bool _validateDestination() {
    final destination = _destinationCtrl.text.trim();

    if (destination.isEmpty) {
      _showError(
        _t(ku: 'شاری گەیاندن پێویستە.', en: 'Delivery city is required.'),
      );
      return false;
    }

    if (!_isKurdistanLocation(destination)) {
      _showError(
        _t(
          ku: 'شاری گەیاندن دەبێت لە هەرێمی کوردستان بێت.',
          en: 'Delivery city must be inside the Kurdistan Region.',
        ),
      );
      return false;
    }

    _destinationCtrl.text = destination;
    return true;
  }

  bool _validateSpecs() {
    if (_colorCtrl.text.trim().isEmpty) {
      _showError(
        _t(ku: 'ڕەنگی بەرهەم پێویستە.', en: 'Product color is required.'),
      );
      return false;
    }

    if (_productSizeCtrl.text.trim().isEmpty) {
      _showError(
        _t(ku: 'قەبارەی بەرهەم پێویستە.', en: 'Product size is required.'),
      );
      return false;
    }

    return true;
  }

  Future<void> _continueToReview() async {
    if (_vehicleTypeId == null) {
      _showError(
        _t(ku: 'شێوازی گواستنەوە هەڵبژێرە.', en: 'Choose a shipping method.'),
      );
      return;
    }

    final selectedTransport = _selectedTransport;
    if (selectedTransport == null) {
      return;
    }

    final cargo = _cargoPayloadFor(selectedTransport);
    if (cargo.error != null) {
      _showError(cargo.error!);
      return;
    }

    setState(() => _isLoadingPricing = true);

    try {
      final response = await ref
          .read(apiClientProvider)
          .calculatePricing(
            weight: cargo.weight,
            size: cargo.size,
            categoryId: _categoryId,
            vehicleTypeId: selectedTransport.id,
          );

      if (!mounted) {
        return;
      }

      setState(() {
        _pricing = Map<String, dynamic>.from(response.data);
        _step = 4;
      });
    } catch (error) {
      if (mounted) {
        _showError(_extractApiMessage(error));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingPricing = false);
      }
    }
  }

  Future<void> _submit() async {
    final selectedTransport = _selectedTransport;
    if (_productPreview == null || selectedTransport == null) {
      _showError(
        _t(ku: 'داواکارییەکە تەواو نییە.', en: 'The request is incomplete.'),
      );
      return;
    }

    final cargo = _cargoPayloadFor(selectedTransport);
    if (cargo.error != null) {
      _showError(cargo.error!);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await ref.read(apiClientProvider).createShipment({
        'origin': _sourceOrigin,
        'destination': _destinationCtrl.text.trim(),
        'product_url': _productUrlCtrl.text.trim(),
        'product_platform': _productPreview?['platform'],
        'product_title': _productPreview?['title'],
        'product_image_url': _productPreview?['image_url'],
        'product_price': _productPreview?['price'],
        'product_color': _colorCtrl.text.trim(),
        'product_size': _productSizeCtrl.text.trim(),
        if (cargo.weight != null) 'weight_kg': cargo.weight,
        if (cargo.size != null) 'size': cargo.size,
        'category_id': _categoryId,
        'vehicle_type_id': selectedTransport.id,
      });

      ref.invalidate(customerShipmentsProvider);

      if (mounted) {
        context.go('/');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _t(
                ku: 'داواکاری هاوردەکە تۆمار کرا.',
                en: 'Import request created.',
              ),
            ),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        _showError(_extractApiMessage(error));
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  _CargoPayload _cargoPayloadFor(_TransportOption transport) {
    if (transport.transportMethod == 'air') {
      final weight = _parsePositiveNumber(_weightCtrl.text);

      if (weight == null) {
        return _CargoPayload(
          error: _t(
            ku: 'بۆ گواستنەوەی هەوایی کێشی پاکێج پێویستە.',
            en: 'Package weight is required for air shipping.',
          ),
        );
      }

      return _CargoPayload(weight: weight);
    }

    final length = _parsePositiveNumber(_lengthCtrl.text);
    final width = _parsePositiveNumber(_widthCtrl.text);
    final height = _parsePositiveNumber(_heightCtrl.text);

    if (length == null || width == null || height == null) {
      return _CargoPayload(
        error: _t(
          ku: 'بۆ گواستنەوەی وشکانی یان دەریایی قەبارەی پاکێج پێویستە.',
          en: 'Package dimensions are required for land or sea shipping.',
        ),
      );
    }

    return _CargoPayload(
      size:
          '${_trimNumber(length)}x${_trimNumber(width)}x${_trimNumber(height)}',
    );
  }

  bool _isKurdistanLocation(String value) {
    final normalized = value.toLowerCase();
    return _kurdistanDestinationKeywords.any(
      (keyword) => normalized.contains(keyword.toLowerCase()),
    );
  }

  String _categoryName(int id) {
    return switch (id) {
      1 => _t(ku: 'گشتی', en: 'General'),
      2 => _t(ku: 'نازک', en: 'Fragile'),
      3 => _t(ku: 'ئەلیکترۆنی', en: 'Electronics'),
      _ => _t(ku: 'گشتی', en: 'General'),
    };
  }

  String _methodLabel(String method) {
    return switch (method) {
      'air' => _t(ku: 'هەوایی', en: 'Air'),
      'sea' => _t(ku: 'دەریایی', en: 'Sea'),
      _ => _t(ku: 'وشکانی', en: 'Land'),
    };
  }

  String _transportIconAsset(String method) {
    return switch (method) {
      'air' => 'assets/icons/transport_air.svg',
      'sea' => 'assets/icons/transport_sea.svg',
      _ => 'assets/icons/transport_land.svg',
    };
  }

  String get _sourceOrigin {
    final label = _productPreview?['platform_label']?.toString();
    return '${label == null || label.isEmpty ? 'International' : label} marketplace';
  }

  String get _packageSummary {
    final selectedTransport = _selectedTransport;
    if (selectedTransport == null) {
      return '-';
    }

    final cargo = _cargoPayloadFor(selectedTransport);
    if (cargo.weight != null) {
      return '${_trimNumber(cargo.weight!)} kg';
    }

    return cargo.size ?? '-';
  }

  _TransportOption? get _selectedTransport {
    final options = _transportOptions.isEmpty
        ? _fallbackTransportOptions
        : _transportOptions;

    if (_vehicleTypeId == null) {
      return options.isEmpty ? null : options.first;
    }

    return options.cast<_TransportOption?>().firstWhere(
      (option) => option?.id == _vehicleTypeId,
      orElse: () => options.isEmpty ? null : options.first,
    );
  }

  bool get _isKurdish => L10n.of(context)!.localeName == 'ku';

  String _t({required String ku, required String en}) => _isKurdish ? ku : en;

  String _formatMultiplier(double multiplier) {
    final rounded = multiplier == multiplier.roundToDouble()
        ? multiplier.toStringAsFixed(0)
        : multiplier.toStringAsFixed(1);
    return 'x$rounded';
  }

  String _trimNumber(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
  }

  double? _parsePositiveNumber(String value) {
    final parsed = double.tryParse(value.replaceAll(RegExp(r'[^0-9.]'), ''));
    if (parsed == null || parsed <= 0) {
      return null;
    }
    return parsed;
  }

  double? _asDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '');
  }

  String _extractApiMessage(Object error) {
    try {
      final dynamic dioError = error;
      final data = dioError.response?.data;

      if (data is Map) {
        final errors = data['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final first = errors.values.first;
          if (first is List && first.isNotEmpty) {
            return first.first.toString();
          }
        }

        if (data['message'] != null) {
          return data['message'].toString();
        }
      }
    } catch (_) {
      // Use the local fallback below.
    }

    return _t(
      ku: 'هەڵەیەک ڕوویدا. تکایە دووبارە هەوڵ بدەوە.',
      en: 'Something went wrong. Please try again.',
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _Marketplace {
  const _Marketplace({
    required this.id,
    required this.name,
    required this.url,
    required this.logoAsset,
    required this.logoWidth,
  });

  final String id;
  final String name;
  final String url;
  final String logoAsset;
  final double logoWidth;
}

class _TransportOption {
  const _TransportOption({
    required this.id,
    required this.nameEn,
    required this.nameKu,
    required this.transportMethod,
    required this.multiplier,
    required this.deliveryDaysOffset,
  });

  factory _TransportOption.fromJson(Map<String, dynamic> json) {
    return _TransportOption(
      id: (json['id'] as num).toInt(),
      nameEn: json['name_en']?.toString() ?? '',
      nameKu: json['name_ku']?.toString() ?? '',
      transportMethod: json['transport_method']?.toString() ?? 'ground',
      multiplier: (json['multiplier'] as num?)?.toDouble() ?? 1.0,
      deliveryDaysOffset: (json['delivery_days_offset'] as num?)?.toInt() ?? 0,
    );
  }

  final int id;
  final String nameEn;
  final String nameKu;
  final String transportMethod;
  final double multiplier;
  final int deliveryDaysOffset;

  int get estimatedDays => 3 + deliveryDaysOffset;

  String displayName({required bool isKurdish}) {
    if (isKurdish && nameKu.trim().isNotEmpty) {
      return nameKu;
    }

    return nameEn.trim().isEmpty ? 'Transport' : nameEn;
  }
}

class _CargoPayload {
  const _CargoPayload({this.weight, this.size, this.error});

  final double? weight;
  final String? size;
  final String? error;
}
