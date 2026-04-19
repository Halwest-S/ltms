import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_domain/pj_domain.dart' as domain;

import 'api_provider.dart';

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
      newNotification: clearNew
          ? null
          : (newNotification ?? this.newNotification),
      seenIds: seenIds ?? this.seenIds,
      initialized: initialized ?? this.initialized,
    );
  }
}

class NotificationPollingNotifier
    extends StateNotifier<NotificationPollingState> {
  final Ref _ref;
  Timer? _timer;

  NotificationPollingNotifier(this._ref)
    : super(const NotificationPollingState(seenIds: {}));

  void start() {
    if (_timer != null) return;
    _poll();
    _timer = Timer.periodic(const Duration(seconds: 15), (_) => _poll());
  }

  Future<void> _poll() async {
    try {
      final response = await _ref.read(apiClientProvider).getNotifications();
      final List raw = response.data is List
          ? response.data as List
          : ((response.data as Map<String, dynamic>)['data'] ?? []) as List;

      final notifications = raw
          .map(
            (json) =>
                domain.Notification.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      if (!state.initialized) {
        state = NotificationPollingState(
          seenIds: notifications.map((n) => n.id).toSet(),
          initialized: true,
        );
        return;
      }

      final newOnes = notifications
          .where((n) => !n.isRead && !state.seenIds.contains(n.id))
          .toList();

      final updatedSeen = {...state.seenIds, ...notifications.map((n) => n.id)};

      if (newOnes.isNotEmpty) {
        state = NotificationPollingState(
          newNotification: newOnes.first,
          seenIds: updatedSeen,
          initialized: true,
        );
      } else {
        state = NotificationPollingState(
          newNotification: null,
          seenIds: updatedSeen,
          initialized: true,
        );
      }
    } catch (_) {
      // Polling failures should stay silent.
    }
  }

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

final notificationPollingProvider =
    StateNotifierProvider<
      NotificationPollingNotifier,
      NotificationPollingState
    >((ref) => NotificationPollingNotifier(ref));
