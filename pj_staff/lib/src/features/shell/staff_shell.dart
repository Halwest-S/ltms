import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../core/layout_preferences.dart';
import 'staff_sidebar.dart';

class StaffShell extends ConsumerWidget {
  const StaffShell({
    super.key,
    required this.activeRoute,
    required this.title,
    required this.child,
    this.actions,
  });

  final String activeRoute;
  final String title;
  final Widget child;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCompact = useCompactStaffLayout(context, ref);

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: isCompact ? AppBar(title: Text(title), actions: actions) : null,
      drawer: isCompact
          ? Drawer(
              backgroundColor: AppTheme.ink,
              child: SafeArea(
                child: StaffSidebar(
                  activeRoute: activeRoute,
                  width: double.infinity,
                ),
              ),
            )
          : null,
      body: Row(
        children: [
          if (!isCompact) StaffSidebar(activeRoute: activeRoute),
          Expanded(child: child),
        ],
      ),
    );
  }
}
