import 'package:flutter/material.dart';

import 'admin_sidebar.dart';
import 'theme.dart';

class AdminShell extends StatelessWidget {
  final String activeRoute;
  final String title;
  final List<Widget>? actions;
  final Widget child;
  final Widget? floatingActionButton;

  const AdminShell({
    super.key,
    required this.activeRoute,
    required this.title,
    this.actions,
    required this.child,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 960;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: isCompact ? AppBar(title: Text(title), actions: actions) : null,
      drawer: isCompact
          ? Drawer(
              backgroundColor: AppTheme.ink,
              child: AdminSidebar(
                activeRoute: activeRoute,
                width: double.infinity,
              ),
            )
          : null,
      floatingActionButton: floatingActionButton,
      body: Row(
        children: [
          if (!isCompact) AdminSidebar(activeRoute: activeRoute),
          Expanded(child: child),
        ],
      ),
    );
  }
}
