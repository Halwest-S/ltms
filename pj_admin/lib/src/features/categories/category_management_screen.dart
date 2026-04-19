import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_l10n/pj_l10n.dart';

import '../../core/admin_shell.dart';
import '../../core/api_provider.dart';
import '../../core/response_parsing.dart';
import '../../core/theme.dart';
import 'category_editor_dialog.dart';

final adminCategoryListProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final response = await ref.read(apiClientProvider).getAdminCategories();
  return extractMapList(response.data);
});

class CategoryManagementScreen extends ConsumerWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context)!;
    final tt = Theme.of(context).textTheme;
    final isCompact = MediaQuery.sizeOf(context).width < 960;
    final categoriesAsync = ref.watch(adminCategoryListProvider);

    Future<void> openEditor([Map<String, dynamic>? category]) async {
      final result = await CategoryEditorDialog.show(
        context,
        category: category,
      );
      if (result == true) {
        ref.invalidate(adminCategoryListProvider);
      }
    }

    Future<void> deleteCategory(Map<String, dynamic> category) async {
      await _deleteCategory(context, ref, category);
    }

    return AdminShell(
      activeRoute: '/categories',
      title: l10n.categories,
      actions: [
        IconButton(
          onPressed: () => ref.refresh(adminCategoryListProvider),
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
              label: Text(l10n.addCategory),
            ),
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 16 : 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isCompact) ...[
              Text(l10n.categories, style: tt.headlineLarge),
              const SizedBox(height: 4),
              Text(
                'Active shipment categories and their surcharge rules.',
                style: tt.bodyMedium?.copyWith(color: AppTheme.muted),
              ),
              const SizedBox(height: 20),
            ] else ...[
              Text(l10n.categories, style: tt.headlineSmall),
              const SizedBox(height: 16),
            ],
            Expanded(
              child: categoriesAsync.when(
                data: (categories) {
                  if (categories.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.categoryCrudPlaceholder,
                        style: tt.titleMedium?.copyWith(color: AppTheme.muted),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: categories.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final title = l10n.localeName == 'ku'
                          ? (category['name_ku'] ?? category['name_en'] ?? '')
                          : (category['name_en'] ?? '');

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
                                    'EN: ${category['name_en'] ?? ''} | KU: ${category['name_ku'] ?? ''}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.muted,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      _surchargeChip(category['surcharge']),
                                      const Spacer(),
                                      TextButton.icon(
                                        onPressed: () => openEditor(category),
                                        icon: const Icon(
                                          Icons.edit_rounded,
                                          size: 18,
                                        ),
                                        label: Text(l10n.edit),
                                      ),
                                      TextButton.icon(
                                        onPressed: () => deleteCategory(category),
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
                                          'EN: ${category['name_en'] ?? ''} | KU: ${category['name_ku'] ?? ''}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.muted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _surchargeChip(category['surcharge']),
                                  const SizedBox(width: 8),
                                  OutlinedButton.icon(
                                    onPressed: () => openEditor(category),
                                    icon: const Icon(
                                      Icons.edit_rounded,
                                      size: 18,
                                    ),
                                    label: Text(l10n.edit),
                                  ),
                                  const SizedBox(width: 8),
                                  OutlinedButton.icon(
                                    onPressed: () => deleteCategory(category),
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

  Widget _surchargeChip(dynamic surcharge) {
    final value = surcharge is num
        ? surcharge.toStringAsFixed(surcharge % 1 == 0 ? 0 : 2)
        : '${surcharge ?? 0}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.amberLight,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '+\$$value',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF92400E),
        ),
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

  int? _parseId(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value');
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

  Future<void> _deleteCategory(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> category,
  ) async {
    final l10n = L10n.of(context)!;
    final categoryId = _parseId(category['id']);
    if (categoryId == null) return;

    final title = l10n.localeName == 'ku'
        ? (category['name_ku'] ?? category['name_en'] ?? '')
        : (category['name_en'] ?? '');

    final confirmed = await _confirmDelete(context, '$title');
    if (!confirmed || !context.mounted) return;

    try {
      await ref.read(apiClientProvider).deleteAdminCategory(categoryId);
      ref.invalidate(adminCategoryListProvider);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              _screenText(
                context,
                ku: 'هاوپۆلەکە سڕایەوە',
                en: 'Category deleted',
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
