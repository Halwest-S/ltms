import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardBackButton extends StatelessWidget {
  const DashboardBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BackButton(
      onPressed: () => context.go('/'),
    );
  }
}
