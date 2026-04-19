import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pj_domain/pj_domain.dart' as domain;
import 'package:pj_l10n/pj_l10n.dart';
import '../../core/theme.dart';

/// A self-contained animated banner that slides down from the top of the
/// screen when staff sends a notification to this customer.
///
/// Usage — insert via [Overlay]:
/// ```dart
/// final entry = OverlayEntry(
///   builder: (_) => InAppNotificationBanner(
///     notification: n,
///     onDismiss: () { entry.remove(); },
///     onTap:     () { entry.remove(); /* navigate */ },
///   ),
/// );
/// Overlay.of(context).insert(entry);
/// ```
class InAppNotificationBanner extends StatefulWidget {
  final domain.Notification notification;
  final VoidCallback onDismiss;
  final VoidCallback onTap;

  /// How long the banner stays visible before auto-dismissing.
  final Duration displayDuration;

  const InAppNotificationBanner({
    super.key,
    required this.notification,
    required this.onDismiss,
    required this.onTap,
    this.displayDuration = const Duration(seconds: 5),
  });

  @override
  State<InAppNotificationBanner> createState() =>
      _InAppNotificationBannerState();
}

class _InAppNotificationBannerState extends State<InAppNotificationBanner>
    with TickerProviderStateMixin {
  // ── Animation ──────────────────────────────────────────────────────────────
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  // ── Auto-dismiss progress ──────────────────────────────────────────────────
  late final AnimationController _progressCtrl;
  Timer? _dismissTimer;
  bool _dismissing = false;

  @override
  void initState() {
    super.initState();

    // Main slide + fade controller
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
      reverseDuration: const Duration(milliseconds: 320),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInCubic,
    ));

    _fade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      reverseCurve: Curves.easeIn,
    );

    // Progress bar controller (runs over displayDuration)
    _progressCtrl = AnimationController(
      vsync: this,
      duration: widget.displayDuration,
    );

    // Slide in, then start the progress + auto-dismiss timer
    _ctrl.forward().then((_) {
      if (!mounted) return;
      _progressCtrl.forward();
      _dismissTimer = Timer(widget.displayDuration, _dismiss);
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _ctrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  // ── Dismiss (slide out then callback) ─────────────────────────────────────
  Future<void> _dismiss() async {
    if (_dismissing || !mounted) return;
    _dismissing = true;
    _dismissTimer?.cancel();
    _progressCtrl.stop();
    await _ctrl.reverse();
    widget.onDismiss();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  (String emoji, Color color) get _typeInfo =>
      switch (widget.notification.type) {
        domain.NotificationType.statusUpdate =>
          ('\u{1F69B}', AppTheme.teal), // Truck 🚚
        domain.NotificationType.reportUpdate =>
          ('\u{26A0}\u{FE0F}', AppTheme.red), // Warning ⚠️
        domain.NotificationType.assignment =>
          ('\u{1F4CB}', AppTheme.blue), // Clipboard 📋
      };

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final (emoji, accentColor) = _typeInfo;
    final n = widget.notification;
    final safeTop = MediaQuery.of(context).padding.top;
    final label = switch (n.type) {
      domain.NotificationType.statusUpdate => L10n.of(context)!.statusUpdate,
      domain.NotificationType.reportUpdate => L10n.of(context)!.reportUpdate,
      domain.NotificationType.assignment => L10n.of(context)!.assignment,
    };

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                _dismissTimer?.cancel();
                _dismissing = true;
                _progressCtrl.stop();
                _ctrl.reverse().then((_) => widget.onTap());
              },
              // Allow vertical swipe-up to dismiss
              onVerticalDragUpdate: (details) {
                if (details.primaryDelta != null &&
                    details.primaryDelta! < -6) {
                  _dismiss();
                }
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(12, safeTop + 8, 12, 0),
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: accentColor.withAlpha(80),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withAlpha(40),
                      blurRadius: 20,
                      spreadRadius: 0,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: Colors.black.withAlpha(18),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Body ─────────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Emoji icon badge
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: accentColor.withAlpha(28),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  emoji,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Text content
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  // App name + type label row
                                  Row(
                                    children: [
                                      Container(
                                        padding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 7,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: accentColor.withAlpha(22),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          label,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            color: accentColor,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      // Close button
                                      GestureDetector(
                                        onTap: _dismiss,
                                        child: Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            color: AppTheme.border,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close_rounded,
                                            size: 13,
                                            color: AppTheme.muted,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),

                                  // Message
                                  Text(
                                    L10n.of(context)!.localeName == 'ku'
                                        ? n.messageKu
                                        : n.messageEn,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.ink,
                                      height: 1.4,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  // Location chip (if present)
                                  if (n.location != null &&
                                      n.location!.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_rounded,
                                          size: 12,
                                          color: accentColor,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            n.location!,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: accentColor,
                                            ),
                                            maxLines: 1,
                                            overflow:
                                                TextOverflow.ellipsis,
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
                      ),

                      // ── Auto-dismiss progress bar ─────────────────────
                      AnimatedBuilder(
                        animation: _progressCtrl,
                        builder: (_, child) {
                          return LinearProgressIndicator(
                            value: 1.0 - _progressCtrl.value,
                            minHeight: 3,
                            backgroundColor:
                                accentColor.withAlpha(20),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(accentColor),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
