import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_l10n/pj_l10n.dart';

import '../../core/admin_shell.dart';
import '../../core/api_provider.dart';
import '../../core/response_parsing.dart';
import '../../core/theme.dart';
import 'vehicle_editor_dialog.dart';

final adminVehicleTypesProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final response = await ref.read(apiClientProvider).getAdminVehicles();
  return extractMapList(response.data);
});

class VehicleManagementScreen extends ConsumerWidget {
  const VehicleManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final tt = Theme.of(context).textTheme;
    final isCompact = MediaQuery.sizeOf(context).width < 960;
    final vehiclesAsync = ref.watch(adminVehicleTypesProvider);

    Future<void> openEditor([Map<String, dynamic>? vehicle]) async {
      final result = await VehicleEditorDialog.show(
        context,
        vehicle: vehicle,
      );
      if (result == true) {
        ref.invalidate(adminVehicleTypesProvider);
      }
    }

    Future<void> deleteVehicle(Map<String, dynamic> vehicle) async {
      await _deleteVehicle(context, ref, vehicle);
    }

    return AdminShell(
      activeRoute: '/vehicles',
      title: l10n.vehicleTypes,
      actions: [
        IconButton(
          onPressed: () => ref.refresh(adminVehicleTypesProvider),
          tooltip: l10n.refresh,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
      floatingActionButton: isCompact
          ? FloatingActionButton(
              onPressed: openEditor,
              child: const Icon(Icons.add_rounded),
            )
          : FloatingActionButton.extended(
              onPressed: openEditor,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.addVehicle),
            ),
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 16 : 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isCompact) ...[
              Text(l10n.vehicleTypes, style: tt.headlineLarge),
              const SizedBox(height: 4),
              Text(
                'Delivery vehicles, multipliers, and time offsets.',
                style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
              ),
              const SizedBox(height: 20),
            ] else ...[
              Text(l10n.vehicleTypes, style: tt.headlineSmall),
              const SizedBox(height: 16),
            ],
            Expanded(
              child: vehiclesAsync.when(
                data: (vehicles) {
                  if (vehicles.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.vehicleCrudPlaceholder,
                        style: tt.titleMedium?.copyWith(color: AppTheme.muted),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: vehicles.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final vehicle = vehicles[index];
                      final title = l10n.localeName == 'ku'
                          ? (vehicle['name_ku'] ?? vehicle['name_en'] ?? '')
                          : (vehicle['name_en'] ?? '');
                      final emoji = _vehicleEmoji(vehicle);

                      return Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppTheme.card,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: isCompact
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        emoji,
                                        style: const TextStyle(fontSize: 26),
                                      ),
                                      const SizedBox(width: 10),
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
                                  const SizedBox(height: 6),
                                  Text(
                                    'EN: ${vehicle['name_en'] ?? ''} | KU: ${vehicle['name_ku'] ?? ''}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.muted,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _chip(
                                        'x${vehicle['multiplier']}',
                                        AppTheme.tealLight,
                                        const Color(0xFF065F46),
                                      ),
                                      _chip(
                                        '${vehicle['delivery_days_offset'] >= 0 ? '+' : ''}${vehicle['delivery_days_offset']}d',
                                        AppTheme.blueLight,
                                        const Color(0xFF1D4ED8),
                                      ),
                                      TextButton.icon(
                                        onPressed: () => openEditor(vehicle),
                                        icon: const Icon(
                                          Icons.edit_rounded,
                                          size: 18,
                                        ),
                                        label: Text(l10n.edit),
                                      ),
                                      TextButton.icon(
                                        onPressed: () => deleteVehicle(vehicle),
                                        icon: const Icon(
                                          Icons.delete_outline_rounded,
                                          size: 18,
                                        ),
                                        style: TextButton.styleFrom(
                                          foregroundColor: AppTheme.rose,
                                        ),
                                        label: Text(l10n.delete),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Text(
                                    emoji,
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: AppTheme.ink,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'EN: ${vehicle['name_en'] ?? ''} | KU: ${vehicle['name_ku'] ?? ''}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.muted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _chip(
                                    'x${vehicle['multiplier']}',
                                    AppTheme.tealLight,
                                    const Color(0xFF065F46),
                                  ),
                                  const SizedBox(width: 8),
                                  _chip(
                                    '${vehicle['delivery_days_offset'] >= 0 ? '+' : ''}${vehicle['delivery_days_offset']}d',
                                    AppTheme.blueLight,
                                    const Color(0xFF1D4ED8),
                                  ),
                                  const SizedBox(width: 8),
                                  OutlinedButton.icon(
                                    onPressed: () => openEditor(vehicle),
                                    icon: const Icon(
                                      Icons.edit_rounded,
                                      size: 18,
                                    ),
                                    label: Text(l10n.edit),
                                  ),
                                  const SizedBox(width: 8),
                                  OutlinedButton.icon(
                                    onPressed: () => deleteVehicle(vehicle),
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      size: 18,
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppTheme.rose,
                                    ),
                                    label: Text(l10n.delete),
                                  ),
                                ],
                              ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text('${l10n.error}: $error'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _vehicleEmoji(Map<String, dynamic> vehicle) {
    final storedIcon = '${vehicle['icon'] ?? ''}'.trim();
    if (storedIcon.isNotEmpty && storedIcon != 'null') {
      return storedIcon;
    }

    final name = '${vehicle['name_en'] ?? ''}'.toLowerCase();
    if (name.contains('truck')) return '🚛';
    if (name.contains('van')) return '🚐';
    if (name.contains('motor')) return '🏍️';
    if (name.contains('air') || name.contains('plane')) return '✈️';
    return '🚗';
  }

  Widget _chip(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }

  String _screenText(
    BuildContext context, {
    required String ku,
    required String en,
  }) {
    return L10n.of(context)!.localeName == 'ku' ? ku : en;
  }

  String _extractErrorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        final map = Map<String, dynamic>.from(data);
        final errors = map['errors'];
        if (errors is Map) {
          for (final value in errors.values) {
            if (value is List && value.isNotEmpty) {
              return value.first.toString();
            }
            if (value != null) {
              return value.toString();
            }
          }
        }
        final message = map['message'];
        if (message is String && message.trim().isNotEmpty) {
          return message;
        }
      }
      if (error.message != null && error.message!.trim().isNotEmpty) {
        return error.message!;
      }
    }
    return error.toString();
  }

  Future<bool> _confirmDelete(
    BuildContext context,
    String title,
  ) async {
    final l10n = L10n.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.confirmAction),
        content: Text(
          _screenText(
            context,
            ku: 'دڵنیایت دەتەوێت "$title" بسڕیتەوە؟',
            en: 'Are you sure you want to delete "$title"?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.rose),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    return result == true;
  }

  int? _parseId(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value');
  }

  Future<void> _deleteVehicle(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> vehicle,
  ) async {
    final l10n = L10n.of(context)!;
    final vehicleId = _parseId(vehicle['id']);
    if (vehicleId == null) return;

    final title = l10n.localeName == 'ku'
        ? (vehicle['name_ku'] ?? vehicle['name_en'] ?? '')
        : (vehicle['name_en'] ?? '');

    final confirmed = await _confirmDelete(context, '$title');
    if (!confirmed || !context.mounted) return;

    try {
      await ref.read(apiClientProvider).deleteAdminVehicle(vehicleId);
      ref.invalidate(adminVehicleTypesProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              _screenText(
                context,
                ku: 'جۆری ئۆتۆمبێلەکە سڕایەوە',
                en: 'Vehicle deleted',
              ),
            ),
          ),
        );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('${l10n.error}: ${_extractErrorMessage(error)}')),
        );
    }
  }
}
