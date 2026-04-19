import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_domain/pj_domain.dart' as domain;
import 'api_provider.dart';

// ── State ────────────────────────────────────────────────────────────────────

class NotificationPollingState {
  final domain.Notification? newNotification;
  final Set<int> seenIds;
  final bool initialized;

  const NotificationPollingState({
    this.newNotification,
    required this.seenIds,
    this.initialized = false,
  });

  NotificationPollingState copyWith({
    domain.Notification? newNotification,
    bool clearNew = false,
    Set<int>? seenIds,
    bool? initialized,
  }) {
    return NotificationPollingState(
      newNotification:
          clearNew ? null : (newNotification ?? this.newNotification),
      seenIds: seenIds ?? this.seenIds,
      initialized: initialized ?? this.initialized,
    );
  }
}

// ── Notifier ─────────────────────────────────────────────────────────────────

class NotificationPollingNotifier
    extends StateNotifier<NotificationPollingState> {
  final Ref _ref;
  Timer? _timer;

  NotificationPollingNotifier(this._ref)
      : super(const NotificationPollingState(seenIds: {}));

  /// Call once after the user has logged in and the shell is mounted.
  void start() {
    if (_timer != null) return; // already running
    _poll(); // immediate first poll to seed the seen-IDs
    _timer =
        Timer.periodic(const Duration(seconds: 15), (_) => _poll());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    state = const NotificationPollingState(seenIds: {});
  }

  Future<void> _poll() async {
    try {
      final response =
          await _ref.read(apiClientProvider).getNotifications();

      final List raw = response.data is List
          ? response.data as List
          : ((response.data as Map<String, dynamic>)['data'] ?? []) as List;

      final notifications = raw
          .map((json) =>
              domain.Notification.fromJson(json as Map<String, dynamic>))
          .toList();

      if (!state.initialized) {
        // ── First poll: seed all current IDs as "seen" so we never
        //    surface old notifications as new banners.
        state = NotificationPollingState(
          seenIds: notifications.map((n) => n.id).toSet(),
          initialized: true,
        );
        return;
      }

      // ── Subsequent polls: find unread notifications we haven't seen yet.
      final newOnes = notifications
          .where((n) => !n.isRead && !state.seenIds.contains(n.id))
          .toList();

      // Always expand the seen set with everything returned by the server.
      final updatedSeen = {
        ...state.seenIds,
        ...notifications.map((n) => n.id),
      };

      if (newOnes.isNotEmpty) {
        // Surface the most-recent new notification (first in descending list).
        state = NotificationPollingState(
          newNotification: newOnes.first,
          seenIds: updatedSeen,
          initialized: true,
        );
      } else {
        // Nothing new, just update seen set quietly.
        state = NotificationPollingState(
          newNotification: null,
          seenIds: updatedSeen,
          initialized: true,
        );
      }
    } catch (_) {
      // Polling errors are silent — we never want to crash the UI.
    }
  }

  /// Called by the UI after the banner has been shown/dismissed.
  void dismissNotification() {
    if (state.newNotification == null) return;
    state = state.copyWith(clearNew: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// ── Provider ─────────────────────────────────────────────────────────────────

final notificationPollingProvider = StateNotifierProvider<
    NotificationPollingNotifier, NotificationPollingState>(
  (ref) => NotificationPollingNotifier(ref),
);
