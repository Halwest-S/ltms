import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pj_l10n/pj_l10n.dart';

import '../features/auth/auth_provider.dart';
import 'theme.dart';

class AdminSidebar extends ConsumerWidget {
  final String activeRoute;
  final double width;

  const AdminSidebar({super.key, required this.activeRoute, this.width = 240});

  bool _isActive(String route) => activeRoute == route;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    return Container(
      width: width,
      color: AppTheme.ink,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.rose, Color(0xFFFB7185)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.rose.withAlpha(80),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('\u{1F6E1}', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      L10n.of(context)!.ltmsAdmin,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            _AdminSidebarItem(
              emoji: '\u{1F3E0}',
              label: L10n.of(context)!.overview,
              active: _isActive('/'),
              onTap: () => context.go('/'),
            ),
            _AdminSidebarItem(
              emoji: '\u{1F465}',
              label: L10n.of(context)!.usersLabel,
              active: _isActive('/users'),
              onTap: () => context.go('/users'),
            ),
            _AdminSidebarItem(
              emoji: '\u{1F4E6}',
              label: L10n.of(context)!.catalogLabel,
              active: _isActive('/catalog'),
              onTap: () => context.go('/catalog'),
            ),
            _AdminSidebarItem(
              emoji: '\u{1F5C2}',
              label: L10n.of(context)!.categories,
              active: _isActive('/categories'),
              onTap: () => context.go('/categories'),
            ),
            _AdminSidebarItem(
              emoji: '\u{1F69B}',
              label: L10n.of(context)!.vehiclesLabel,
              active: _isActive('/vehicles'),
              onTap: () => context.go('/vehicles'),
            ),
            _AdminSidebarItem(
              emoji: '\u{2753}',
              label: L10n.of(context)!.faqLabel,
              active: _isActive('/faq'),
              onTap: () => context.go('/faq'),
            ),
            _AdminSidebarItem(
              emoji: '\u{1F4B0}',
              label: L10n.of(context)!.pricingLabel,
              active: _isActive('/pricing'),
              onTap: () => context.go('/pricing'),
            ),
            _AdminSidebarItem(
              emoji: '\u{1F4CA}',
              label: L10n.of(context)!.reportsLabel,
              active: _isActive('/reports'),
              onTap: () => context.go('/reports'),
            ),
            _AdminSidebarItem(
              emoji: '\u{1F514}',
              label: L10n.of(context)!.notifications,
              active: _isActive('/notifications'),
              onTap: () => context.go('/notifications'),
            ),
            _AdminSidebarItem(
              emoji: '\u{2699}',
              label: L10n.of(context)!.settings,
              active: _isActive('/settings'),
              onTap: () => context.go('/settings'),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(13),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withAlpha(18)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.rose, Color(0xFFFB7185)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          (user?.name ?? 'A')[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? L10n.of(context)!.adminRole,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            L10n.of(context)!.adminRole,
                            style: TextStyle(
                              color: Colors.white.withAlpha(100),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ref.read(authProvider.notifier).logout();
                        context.go('/login');
                      },
                      icon: Icon(
                        Icons.logout_rounded,
                        size: 18,
                        color: Colors.white.withAlpha(180),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminSidebarItem extends StatelessWidget {
  final String emoji;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _AdminSidebarItem({
    required this.emoji,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: active ? Colors.white.withAlpha(20) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: active ? Border.all(color: Colors.white.withAlpha(15)) : null,
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: active ? Colors.white : Colors.white.withAlpha(128),
                ),
              ),
            ),
            if (active)
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.rose,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
