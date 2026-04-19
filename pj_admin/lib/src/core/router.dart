import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pj_domain/pj_domain.dart';
import '../features/auth/auth_provider.dart';
import '../features/auth/login_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/users/user_management_screen.dart';
import '../features/catalog/catalog_management_screen.dart';
import '../features/categories/category_management_screen.dart';
import '../features/vehicles/vehicle_management_screen.dart';
import '../features/faq/faq_management_screen.dart';
import '../features/pricing/pricing_config_screen.dart';
import '../features/reports/admin_report_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/shipments/shipment_detail_screen.dart';

// ── Transition helpers ─────────────────────────────────────────────────────────

CustomTransitionPage<T> _fadePage<T>({
  required LocalKey key,
  required Widget child,
  Duration duration = const Duration(milliseconds: 300),
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      );
    },
  );
}

CustomTransitionPage<T> _slideUpFadePage<T>({
  required LocalKey key,
  required Widget child,
  Duration duration = const Duration(milliseconds: 360),
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: const Duration(milliseconds: 260),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideAnim = Tween<Offset>(
        begin: const Offset(0.0, 0.05),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
      );

      final fadeAnim = CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      );

      return SlideTransition(
        position: slideAnim,
        child: FadeTransition(opacity: fadeAnim, child: child),
      );
    },
  );
}

CustomTransitionPage<T> _slideRightFadePage<T>({
  required LocalKey key,
  required Widget child,
  Duration duration = const Duration(milliseconds: 340),
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: const Duration(milliseconds: 240),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideAnim = Tween<Offset>(
        begin: const Offset(0.04, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
      );

      final fadeAnim = CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.60, curve: Curves.easeOut),
      );

      // Slightly push old screen left on forward navigation
      final secondarySlide = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-0.025, 0.0),
      ).animate(
        CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeIn),
      );

      return SlideTransition(
        position: secondarySlide,
        child: SlideTransition(
          position: slideAnim,
          child: FadeTransition(opacity: fadeAnim, child: child),
        ),
      );
    },
  );
}

// ── Router ────────────────────────────────────────────────────────────────────

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    initialLocation: auth != null ? '/' : '/login',
    redirect: (context, state) {
      final currentUser = auth;
      final loggedIn = currentUser != null;
      final onLogin = state.matchedLocation == '/login';
      final onUsers = state.matchedLocation == '/users';

      if (!loggedIn && !onLogin) {
        return '/login';
      }

      if (loggedIn && onLogin) {
        return '/';
      }

      if (loggedIn && onUsers && currentUser.role != UserRole.superAdmin) {
        return '/';
      }

      return null;
    },
    routes: [
      // ── Login ──
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _fadePage(
          key: state.pageKey,
          child: const LoginScreen(),
          duration: const Duration(milliseconds: 400),
        ),
      ),

      // ── Dashboard ──
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => _slideUpFadePage(
          key: state.pageKey,
          child: const DashboardScreen(),
        ),
      ),

      // ── Shipment detail ──
      GoRoute(
        path: '/shipments/:id',
        pageBuilder: (context, state) => _slideRightFadePage(
          key: state.pageKey,
          child: ShipmentDetailScreen(
            shipmentId: state.pathParameters['id'] ?? '',
          ),
        ),
      ),

      // ── Users ──
      GoRoute(
        path: '/users',
        pageBuilder: (context, state) => _slideUpFadePage(
          key: state.pageKey,
          child: const UserManagementScreen(),
        ),
      ),

      // ── Catalog ──
      GoRoute(
        path: '/catalog',
        pageBuilder: (context, state) => _slideUpFadePage(
          key: state.pageKey,
          child: const CatalogManagementScreen(),
        ),
      ),

      // ── Categories ──
      GoRoute(
        path: '/categories',
        pageBuilder: (context, state) => _slideUpFadePage(
          key: state.pageKey,
          child: const CategoryManagementScreen(),
        ),
      ),

      // ── Vehicles ──
      GoRoute(
        path: '/vehicles',
        pageBuilder: (context, state) => _slideUpFadePage(
          key: state.pageKey,
          child: const VehicleManagementScreen(),
        ),
      ),

      // ── FAQ ──
      GoRoute(
        path: '/faq',
        pageBuilder: (context, state) => _slideUpFadePage(
          key: state.pageKey,
          child: const FaqManagementScreen(),
        ),
      ),

      // ── Pricing ──
      GoRoute(
        path: '/pricing',
        pageBuilder: (context, state) => _slideUpFadePage(
          key: state.pageKey,
          child: const PricingConfigScreen(),
        ),
      ),

      // ── Reports ──
      GoRoute(
        path: '/reports',
        pageBuilder: (context, state) => _slideUpFadePage(
          key: state.pageKey,
          child: const AdminReportScreen(),
        ),
      ),

      // ── Notifications ──
      GoRoute(
        path: '/notifications',
        pageBuilder: (context, state) => _slideUpFadePage(
          key: state.pageKey,
          child: const AdminNotificationsScreen(),
        ),
      ),

      // ── Settings ──
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => _slideUpFadePage(
          key: state.pageKey,
          child: const AdminSettingsScreen(),
        ),
      ),
    ],
  );
});
