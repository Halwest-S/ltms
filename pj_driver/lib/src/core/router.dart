import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/auth_provider.dart';
import '../features/auth/login_screen.dart';
import '../features/shell/main_shell.dart';
import '../features/shipments/shipment_action_screen.dart';
import '../features/notifications/notification_screen.dart';
import '../features/shipments/shipment_history_screen.dart';

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
        builder: (_, _) => const DriverLoginScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (_, _) => const DriverMainShell(),
      ),
      GoRoute(
        path: '/shipments/:id',
        builder: (_, state) =>
            ShipmentActionScreen(shipmentId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/notifications',
        builder: (_, _) => const DriverNotificationScreen(),
      ),
      GoRoute(
        path: '/history',
        builder: (_, _) => const ShipmentHistoryScreen(),
      ),
    ],
  );
});
