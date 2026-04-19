import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/auth_provider.dart';
import '../features/auth/login_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/reports/report_management_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/settings/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    initialLocation: auth != null ? '/' : '/login',
    redirect: (context, state) {
      final loggedIn = auth != null;
      final onLogin = state.uri.path == '/login';
      if (!loggedIn && !onLogin) return '/login';
      if (loggedIn && onLogin) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, _) => const StaffLoginScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (_, _) => const StaffDashboardScreen(),
      ),
      GoRoute(
        path: '/reports',
        builder: (_, _) => const ReportManagementScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (_, _) => const StaffNotificationsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (_, _) => const StaffSettingsScreen(),
      ),
    ],
  );
});
