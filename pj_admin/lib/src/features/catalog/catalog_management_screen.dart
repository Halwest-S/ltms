import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_l10n/pj_l10n.dart';

import '../../core/admin_shell.dart';
import '../../core/api_provider.dart';
import '../../core/response_parsing.dart';
import '../../core/theme.dart';

final categoriesProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final response = await ref.read(apiClientProvider).getAdminCategories();
  return extractMapList(response.data);
});

final vehiclesProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final response = await ref.read(apiClientProvider).getAdminVehicles();
  return extractMapList(response.data);
});

class CatalogManagementScreen extends ConsumerWidget {
  const CatalogManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final catsAsync = ref.watch(categoriesProvider);
    final vehAsync = ref.watch(vehiclesProvider);
    final l10n = L10n.of(context)!;
    final isCompact = MediaQuery.sizeOf(context).width < 960;

    return AdminShell(
      activeRoute: '/catalog',
      title: l10n.catalogManagement,
      actions: [
        IconButton(
          onPressed: () {
            ref.invalidate(categoriesProvider);
            ref.invalidate(vehiclesProvider);
          },
          tooltip: l10n.refresh,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isCompact ? 16 : 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isCompact) ...[
              Text(l10n.catalogManagement, style: tt.headlineLarge),
              const SizedBox(height: 4),
              Text(
                'Review the current shipping categories and vehicle types.',
                style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
              ),
              const SizedBox(height: 20),
            ] else ...[
              Text(l10n.catalogManagement, style: tt.headlineSmall),
              const SizedBox(height: 16),
            ],
            Text(
              l10n.categories.toUpperCase(),
              style: tt.labelLarge?.copyWith(
                color: AppTheme.ink,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            catsAsync.when(
              data: (cats) => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: cats
                    .map(
                      (c) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.card,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.localeName == 'ku'
                                  ? (c['name_ku'] ?? c['name_en'] ?? '')
                                  : (c['name_en'] ?? ''),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.ink,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.amberLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '+\$${c['surcharge'] ?? 0}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF92400E),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('${l10n.error}: $e'),
            ),
            const SizedBox(height: 28),
            Text(
              l10n.vehicleTypes.toUpperCase(),
              style: tt.labelLarge?.copyWith(
                color: AppTheme.ink,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            vehAsync.when(
              data: (vehs) => Wrap(
                spacing: 10,
                runSpacing: 10,
                children: vehs.map((v) {
                  final emoji = switch (v['name_en']
                      ?.toString()
                      .toLowerCase()) {
                    'truck' => '🚛',
                    'van' => '🚐',
                    'air cargo' || 'air' => '✈️',
                    'motorcycle' => '🏍️',
                    _ => '🚗',
                  };
                  return Container(
                    width: isCompact ? double.infinity : 220,
                    constraints: isCompact
                        ? null
                        : const BoxConstraints(maxWidth: 220),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(emoji, style: const TextStyle(fontSize: 28)),
                        const SizedBox(height: 8),
                        Text(
                          l10n.localeName == 'ku'
                              ? (v['name_ku'] ?? v['name_en'] ?? '')
                              : (v['name_en'] ?? ''),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.ink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.tealLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '×${v['multiplier']}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF065F46),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.blueLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${v['delivery_days_offset'] >= 0 ? '+' : ''}${v['delivery_days_offset']}d',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1D4ED8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('${l10n.error}: $e'),
            ),
          ],
        ),
      ),
    );
  }
}
