import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/auth_provider.dart';
import '../features/auth/splash_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/shipments/main_shell.dart';
import '../features/shipments/shipment_detail_screen.dart';
import '../features/shipments/report_submission_screen.dart';
import '../features/shipments/create_shipment_screen.dart';
import '../features/settings/faq_screen.dart';
import '../features/notifications/notification_screen.dart';

// ── Transition helpers ─────────────────────────────────────────────────────────

CustomTransitionPage<T> _fadePage<T>({
  required LocalKey key,
  required Widget child,
  Duration duration = const Duration(milliseconds: 320),
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

CustomTransitionPage<T> _slideUpPage<T>({
  required LocalKey key,
  required Widget child,
  Duration duration = const Duration(milliseconds: 380),
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: const Duration(milliseconds: 260),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideAnim = Tween<Offset>(
        begin: const Offset(0.0, 0.06),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

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

CustomTransitionPage<T> _slideRightPage<T>({
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
        begin: const Offset(0.04, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

      final fadeAnim = CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.60, curve: Curves.easeOut),
      );

      // Secondary: push current screen slightly left when navigating forward
      final secondarySlide = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-0.03, 0.0),
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
    initialLocation: auth != null ? '/' : '/splash',
    redirect: (context, state) {
      final loggedIn = auth != null;
      final location = state.uri.path;
      final isGuestRoute = location == '/splash' ||
          location == '/login' ||
          location == '/register';

      if (!loggedIn && !isGuestRoute) return '/splash';
      if (loggedIn && isGuestRoute) return '/';
      return null;
    },
    routes: [
      // ── Splash ──
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => _fadePage(
          key: state.pageKey,
          child: const SplashScreen(),
          duration: const Duration(milliseconds: 400),
        ),
      ),

      // ── Login ──
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _slideUpPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),

      // ── Register ──
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => _slideUpPage(
          key: state.pageKey,
          child: const RegisterScreen(),
        ),
      ),

      // ── Main shell (home tabs) ──
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => _fadePage(
          key: state.pageKey,
          child: const MainShell(),
          duration: const Duration(milliseconds: 350),
        ),
      ),

      // ── Create shipment ──
      GoRoute(
        path: '/create-shipment',
        pageBuilder: (context, state) => _slideUpPage(
          key: state.pageKey,
          child: const CreateShipmentScreen(),
        ),
      ),

      // ── Shipment detail ──
      GoRoute(
        path: '/shipments/:id',
        pageBuilder: (context, state) => _slideRightPage(
          key: state.pageKey,
          child: ShipmentDetailScreen(
            shipmentId: state.pathParameters['id']!,
          ),
        ),
      ),

      // ── Report submission ──
      GoRoute(
        path: '/shipments/:id/report',
        pageBuilder: (context, state) => _slideUpPage(
          key: state.pageKey,
          child: ReportSubmissionScreen(
            shipmentId: state.pathParameters['id']!,
          ),
        ),
      ),

      // ── FAQ ──
      GoRoute(
        path: '/faq',
        pageBuilder: (context, state) => _slideRightPage(
          key: state.pageKey,
          child: const FaqScreen(),
        ),
      ),
      // ── Notifications ──
      GoRoute(
        path: '/notifications',
        pageBuilder: (context, state) => _slideRightPage(
          key: state.pageKey,
          child: const NotificationScreen(),
        ),
      ),
    ],
  );
});
