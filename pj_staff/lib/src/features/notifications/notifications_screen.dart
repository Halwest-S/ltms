import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/api_provider.dart';
import '../../core/theme.dart';
import 'package:pj_l10n/pj_l10n.dart';
import '../shell/staff_shell.dart';

// ── Providers ──────────────────────────────────────────────────────────────

final customersProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final res = await ref.read(apiClientProvider).getCustomers();
  final List data = res.data is List ? res.data : (res.data['data'] ?? []);
  return data.cast<Map<String, dynamic>>();
});

final driversProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final res = await ref.read(apiClientProvider).getDrivers();
  final List data = res.data is List ? res.data : (res.data['data'] ?? []);
  return data.cast<Map<String, dynamic>>();
});

final sentNotificationsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final res = await ref.read(apiClientProvider).getSentNotifications();
  final List data = res.data['data'] ?? [];
  return data.cast<Map<String, dynamic>>();
});

enum _NotificationRecipientType { customer, driver }

// ── Main Screen ─────────────────────────────────────────────────────────────

class StaffNotificationsScreen extends ConsumerStatefulWidget {
  const StaffNotificationsScreen({super.key});

  @override
  ConsumerState<StaffNotificationsScreen> createState() =>
      _StaffNotificationsScreenState();
}

class _StaffNotificationsScreenState
    extends ConsumerState<StaffNotificationsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return StaffShell(
      activeRoute: '/notifications',
      title: L10n.of(context)!.notifications,
      actions: [
        IconButton(
          onPressed: () => _openCompose(context),
          icon: const Icon(Icons.send_rounded),
          tooltip: L10n.of(context)!.sendNotification,
        ),
      ],
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          L10n.of(context)!.notifications,
                          style: tt.displaySmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          L10n.of(context)!.sendUpdatesSubtitle,
                          style: tt.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  // Compose button
                  ElevatedButton.icon(
                    onPressed: () => _openCompose(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.indigo,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.send_rounded, size: 16),
                    label: Text(
                      L10n.of(context)!.sendBtn,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── Tab Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: TabBar(
                  controller: _tab,
                  indicator: BoxDecoration(
                    color: AppTheme.indigo,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppTheme.muted,
                  labelStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  tabs: [
                    Tab(text: L10n.of(context)!.sentTab),
                    Tab(text: L10n.of(context)!.customersTab),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Tab Views ──
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  _SentTab(onCompose: () => _openCompose(context)),
                  _CustomersTab(
                    onSelect: (id, name) {
                      _openCompose(
                        context,
                        preselectedId: id,
                        preselectedName: name,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCompose(
    BuildContext context, {
    int? preselectedId,
    String? preselectedName,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ComposeSheet(
        preselectedCustomerId: preselectedId,
        preselectedCustomerName: preselectedName,
        onSent: () {
          ref.invalidate(sentNotificationsProvider);
        },
      ),
    );
  }
}

// ── Sent Tab ────────────────────────────────────────────────────────────────

class _SentTab extends ConsumerWidget {
  final VoidCallback onCompose;
  const _SentTab({required this.onCompose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final sentAsync = ref.watch(sentNotificationsProvider);

    return sentAsync.when(
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('📭', style: TextStyle(fontSize: 44)),
                const SizedBox(height: 10),
                Text(
                  L10n.of(context)!.noNotificationsSent,
                  style: tt.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(L10n.of(context)!.tapSendToNotify, style: tt.bodySmall),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onCompose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.indigo,
                    minimumSize: const Size(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(L10n.of(context)!.sendNotification),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () => ref.refresh(sentNotificationsProvider.future),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, i) => _SentCard(notif: list[i]),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('⚠️', style: TextStyle(fontSize: 36)),
            const SizedBox(height: 8),
            Text(L10n.of(context)!.failedToLoad, style: tt.titleMedium),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => ref.refresh(sentNotificationsProvider.future),
              child: Text(L10n.of(context)!.retry),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sent Notification Card ───────────────────────────────────────────────────

class _SentCard extends StatelessWidget {
  final Map<String, dynamic> notif;
  const _SentCard({required this.notif});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final recipient = notif['user'] as Map<String, dynamic>?;
    final imageUrl = notif['image_url'] as String?;
    final location = notif['location'] as String?;
    final recipientPhone = recipient?['phone_number'] as String?;
    final recipientRole = recipient?['role'] as String?;
    final recipientLabel = recipientRole == 'driver'
        ? L10n.of(context)!.driver
        : L10n.of(context)!.customer;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          if (imageUrl != null && imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(17),
              ),
              child: Image.network(
                resolveApiUrl(imageUrl),
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: 160,
                  color: AppTheme.surface,
                  child: const Center(
                    child: Text('🖼️', style: TextStyle(fontSize: 36)),
                  ),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppTheme.indigoLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text('👤', style: TextStyle(fontSize: 15)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipient?['name'] ?? recipientLabel,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.ink,
                            ),
                          ),
                          if (recipient?['email'] != null)
                            Text(
                              recipient!['email'],
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.muted,
                              ),
                            ),
                          if (recipientPhone != null &&
                              recipientPhone.isNotEmpty)
                            Text(
                              'Phone: $recipientPhone',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.muted,
                              ),
                            ),
                          Text(
                            recipientLabel,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.muted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.tealLight,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        L10n.of(context)!.sentBadge,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.teal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Message
                Text(notif['message_en'] ?? '', style: tt.bodyMedium),

                // Location
                if (location != null && location.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 14,
                        color: AppTheme.indigo,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.indigo,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Customers Tab ────────────────────────────────────────────────────────────

class _CustomersTab extends ConsumerWidget {
  final void Function(int id, String name) onSelect;
  const _CustomersTab({required this.onSelect});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final customersAsync = ref.watch(customersProvider);

    return customersAsync.when(
      data: (customers) {
        if (customers.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('👥', style: TextStyle(fontSize: 44)),
                const SizedBox(height: 10),
                Text(L10n.of(context)!.noCustomersFound, style: tt.titleMedium),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          itemCount: customers.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, i) {
            final c = customers[i];
            final name = c['name'] as String? ?? L10n.of(context)!.customer;
            final email = c['email'] as String? ?? '';
            final phone = c['phone_number'] as String? ?? '';
            final id = c['id'] as int;
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppTheme.indigoLight,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.indigo,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.ink,
                          ),
                        ),
                        Text(
                          email,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.muted,
                          ),
                        ),
                        if (phone.isNotEmpty)
                          Text(
                            'Phone: $phone',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.muted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => onSelect(id, name),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.indigo,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 34),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      L10n.of(context)!.notifyBtn,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('⚠️', style: TextStyle(fontSize: 36)),
            const SizedBox(height: 8),
            Text(
              L10n.of(context)!.failedToLoadCustomers,
              style: tt.titleMedium,
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => ref.refresh(customersProvider.future),
              child: Text(L10n.of(context)!.retry),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Compose Sheet ────────────────────────────────────────────────────────────

class _ComposeSheet extends ConsumerStatefulWidget {
  final int? preselectedCustomerId;
  final String? preselectedCustomerName;
  final VoidCallback onSent;

  const _ComposeSheet({
    this.preselectedCustomerId,
    this.preselectedCustomerName,
    required this.onSent,
  });

  @override
  ConsumerState<_ComposeSheet> createState() => _ComposeSheetState();
}

class _ComposeSheetState extends ConsumerState<_ComposeSheet> {
  final _msgEnCtrl = TextEditingController();
  final _msgKuCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  _NotificationRecipientType _recipientType =
      _NotificationRecipientType.customer;
  int? _selectedRecipientId;
  String? _selectedRecipientName;
  XFile? _pickedImage;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _selectedRecipientId = widget.preselectedCustomerId;
    _selectedRecipientName = widget.preselectedCustomerName;
  }

  @override
  void dispose() {
    _msgEnCtrl.dispose();
    _msgKuCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  bool get _isDriverRecipient =>
      _recipientType == _NotificationRecipientType.driver;

  String _recipientPickerTitle(BuildContext context) =>
      _isDriverRecipient ? 'Select Driver' : L10n.of(context)!.selectCustomer;

  String _recipientHint(BuildContext context) => _isDriverRecipient
      ? 'Select a driver...'
      : L10n.of(context)!.selectCustomerHint;

  String _recipientError(BuildContext context) => _isDriverRecipient
      ? 'Please select a driver'
      : L10n.of(context)!.selectCustomerError;

  String _recipientFieldLabel(BuildContext context) => _isDriverRecipient
      ? 'TO (${L10n.of(context)!.driver})'
      : L10n.of(context)!.toCustomerLabel;

  String _noRecipientsFound(BuildContext context) => _isDriverRecipient
      ? L10n.of(context)!.noDriversFound
      : L10n.of(context)!.noCustomersFound;

  String _recipientFallbackLabel(BuildContext context) => _isDriverRecipient
      ? L10n.of(context)!.driver
      : L10n.of(context)!.customer;

  IconData get _recipientIcon =>
      _isDriverRecipient ? Icons.local_shipping_rounded : Icons.person_rounded;

  // ── Image Picker ──
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1200,
    );
    if (picked != null) {
      setState(() => _pickedImage = picked);
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              L10n.of(context)!.addPhoto,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppTheme.ink,
              ),
            ),
            const SizedBox(height: 16),
            _imageOptionTile(
              emoji: '📷',
              label: L10n.of(context)!.takePhoto,
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            const SizedBox(height: 8),
            _imageOptionTile(
              emoji: '🖼️',
              label: L10n.of(context)!.chooseGallery,
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_pickedImage != null) ...[
              const SizedBox(height: 8),
              _imageOptionTile(
                emoji: '🗑️',
                label: L10n.of(context)!.removePhoto,
                color: AppTheme.red,
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _pickedImage = null);
                },
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _imageOptionTile({
    required String emoji,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color != null ? color.withAlpha(15) : AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color != null ? color.withAlpha(60) : AppTheme.border,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color ?? AppTheme.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Customer Picker ──
  void _setRecipientType(_NotificationRecipientType type) {
    if (_recipientType == type) return;

    setState(() {
      _recipientType = type;
      _selectedRecipientId = null;
      _selectedRecipientName = null;
      _error = null;
    });
  }

  Widget _recipientTypeCard({
    required _NotificationRecipientType type,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _recipientType == type;

    return GestureDetector(
      onTap: () => _setRecipientType(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.indigoLight : AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppTheme.indigo : AppTheme.border,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppTheme.indigo : AppTheme.muted,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppTheme.indigo : AppTheme.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCustomerPicker() async {
    final customers = _isDriverRecipient
        ? await ref.read(driversProvider.future)
        : await ref.read(customersProvider.future);

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (_, scrollCtrl) => Container(
          decoration: const BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  _recipientPickerTitle(context),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.ink,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(height: 1),
              Expanded(
                child: customers.isEmpty
                    ? Center(child: Text(_noRecipientsFound(context)))
                    : ListView.builder(
                        controller: scrollCtrl,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: customers.length,
                        itemBuilder: (ctx, i) {
                          final c = customers[i];
                          final name =
                              c['name'] as String? ??
                              _recipientFallbackLabel(context);
                          final email = c['email'] as String? ?? '';
                          final phone = c['phone_number'] as String? ?? '';
                          final id = c['id'] as int;
                          final isSelected = _selectedRecipientId == id;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedRecipientId = id;
                                _selectedRecipientName = name;
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.indigoLight
                                    : AppTheme.surface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.indigo
                                      : AppTheme.border,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppTheme.indigo.withAlpha(30)
                                          : AppTheme.card,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        name.isNotEmpty
                                            ? name[0].toUpperCase()
                                            : '?',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: isSelected
                                              ? AppTheme.indigo
                                              : AppTheme.muted,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: isSelected
                                                ? AppTheme.indigo
                                                : AppTheme.ink,
                                          ),
                                        ),
                                        Text(
                                          email,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.muted,
                                          ),
                                        ),
                                        if (phone.isNotEmpty)
                                          Text(
                                            'Phone: $phone',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppTheme.muted,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: AppTheme.indigo,
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Send ──
  Future<void> _send() async {
    if (_selectedRecipientId == null) {
      setState(() => _error = _recipientError(context));
      return;
    }
    if (_msgEnCtrl.text.trim().isEmpty) {
      setState(() => _error = L10n.of(context)!.messageEnRequired);
      return;
    }
    if (_msgKuCtrl.text.trim().isEmpty) {
      setState(() => _error = L10n.of(context)!.messageKuRequired);
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final bytes = _pickedImage != null
          ? await _pickedImage!.readAsBytes()
          : null;
      await ref
          .read(apiClientProvider)
          .sendNotification(
            userId: _selectedRecipientId!,
            messageEn: _msgEnCtrl.text.trim(),
            messageku: _msgKuCtrl.text.trim(),
            location: _locationCtrl.text.trim().isNotEmpty
                ? _locationCtrl.text.trim()
                : null,
            imageBytes: bytes,
            imageFilename: _pickedImage?.name,
          );

      widget.onSent();
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(L10n.of(context)!.notificationSentSuccess),
            backgroundColor: AppTheme.teal,
          ),
        );
      }
    } catch (e) {
      setState(() => _error = '${L10n.of(context)!.failedToSend}: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ── Build ──
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (_, scrollCtrl) => Container(
          decoration: const BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: scrollCtrl,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.indigoLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text('📢', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      L10n.of(context)!.sendNotification,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Error
                if (_error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.redLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.red.withAlpha(60)),
                    ),
                    child: Row(
                      children: [
                        const Text('⚠️', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _error!,
                            style: const TextStyle(
                              color: AppTheme.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // ── Customer Picker ──
                Row(
                  children: [
                    Expanded(
                      child: _recipientTypeCard(
                        type: _NotificationRecipientType.customer,
                        icon: Icons.person_rounded,
                        label: L10n.of(context)!.customer,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _recipientTypeCard(
                        type: _NotificationRecipientType.driver,
                        icon: Icons.local_shipping_rounded,
                        label: L10n.of(context)!.driver,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _recipientFieldLabel(context),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.muted,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _showCustomerPicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedRecipientId != null
                            ? AppTheme.indigo
                            : AppTheme.border,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _recipientIcon,
                          size: 18,
                          color: _selectedRecipientId != null
                              ? AppTheme.indigo
                              : AppTheme.muted,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _selectedRecipientName ?? _recipientHint(context),
                            style: TextStyle(
                              fontSize: 14,
                              color: _selectedRecipientId != null
                                  ? AppTheme.ink
                                  : AppTheme.muted,
                              fontWeight: _selectedRecipientId != null
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: _selectedRecipientId != null
                              ? AppTheme.indigo
                              : AppTheme.muted,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Location ──
                Text(
                  L10n.of(context)!.locationLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.muted,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _locationCtrl,
                  decoration: InputDecoration(
                    hintText: L10n.of(context)!.locationHint,
                    prefixIcon: const Icon(
                      Icons.location_on_rounded,
                      size: 18,
                      color: AppTheme.indigo,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Message EN ──
                Text(
                  L10n.of(context)!.messageEnLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.muted,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _msgEnCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: L10n.of(context)!.messageEnHint,
                  ),
                ),
                const SizedBox(height: 16),

                // ── Message KU ──
                Text(
                  L10n.of(context)!.messageKuLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.muted,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _msgKuCtrl,
                  maxLines: 3,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    hintText: L10n.of(context)!.messageKuHint,
                  ),
                ),
                const SizedBox(height: 16),

                // ── Image ──
                Text(
                  L10n.of(context)!.photoOptionalLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.muted,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _showImageOptions,
                  child: _pickedImage != null
                      ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: kIsWeb
                                  ? Image.network(
                                      _pickedImage!.path,
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(_pickedImage!.path),
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _pickedImage = null),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(140),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withAlpha(140),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  L10n.of(context)!.tapToChange,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          height: 110,
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.border,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppTheme.indigoLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text(
                                    '📷',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                L10n.of(context)!.tapToAddPhoto,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.indigo,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                L10n.of(context)!.cameraOrGallery,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                const SizedBox(height: 24),

                // ── Send Button ──
                ElevatedButton(
                  onPressed: _loading ? null : _send,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.indigo,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.send_rounded, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              L10n.of(context)!.sendNotification,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
