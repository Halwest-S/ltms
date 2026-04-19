import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import 'package:pj_l10n/pj_l10n.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Controllers ──────────────────────────────────────────────────────────
  late final AnimationController _pulseCtrl;
  late final AnimationController _contentCtrl;
  late final AnimationController _buttonCtrl;
  late final AnimationController _floatCtrl;

  // ── Pulse glow ────────────────────────────────────────────────────────────
  late final Animation<double> _pulseScale;
  late final Animation<double> _pulseOpacity;

  // ── Secondary glow ────────────────────────────────────────────────────────
  late final Animation<double> _glow2Opacity;

  // ── Logo ─────────────────────────────────────────────────────────────────
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoFloat;

  // ── Title text ────────────────────────────────────────────────────────────
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleOpacity;

  // ── Subtitle text ─────────────────────────────────────────────────────────
  late final Animation<Offset> _subtitleSlide;
  late final Animation<double> _subtitleOpacity;

  // ── Buttons ───────────────────────────────────────────────────────────────
  late final Animation<Offset> _buttonSlide;
  late final Animation<double> _buttonOpacity;

  @override
  void initState() {
    super.initState();

    // Pulse: repeating breathe effect on glow circle
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    // Main content entrance (logo + text)
    _contentCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Buttons entrance (delayed after content)
    _buttonCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Continuous logo float
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    // ── Pulse animations ──
    _pulseScale = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _pulseOpacity = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _glow2Opacity = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(
        parent: _pulseCtrl,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // ── Logo animations ──
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.0, 0.55, curve: Curves.elasticOut),
      ),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
      ),
    );
    _logoFloat = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );

    // ── Title animations ──
    _titleSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.6),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.35, 0.70, curve: Curves.easeOutCubic),
      ),
    );
    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
      ),
    );

    // ── Subtitle animations ──
    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.6),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.50, 0.85, curve: Curves.easeOutCubic),
      ),
    );
    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.50, 0.80, curve: Curves.easeOut),
      ),
    );

    // ── Button animations ──
    _buttonSlide = Tween<Offset>(
      begin: const Offset(0.0, 1.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _buttonCtrl, curve: Curves.easeOutCubic),
    );
    _buttonOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonCtrl, curve: Curves.easeOut),
    );

    // Start sequence: content first, then buttons
    _contentCtrl.forward().then((_) {
      if (mounted) _buttonCtrl.forward();
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _contentCtrl.dispose();
    _buttonCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D1B14), Color(0xFF0A1628)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // ── Primary pulsing glow ──────────────────────────────────
              Positioned(
                top: 40, left: 0, right: 0,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _pulseCtrl,
                    builder: (_, _) => Transform.scale(
                      scale: _pulseScale.value,
                      child: Opacity(
                        opacity: _pulseOpacity.value,
                        child: Container(
                          width: 300, height: 300,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppTheme.teal.withAlpha(55),
                                AppTheme.teal.withAlpha(18),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Secondary accent glow (bottom-right) ─────────────────
              Positioned(
                bottom: 120, right: -30,
                child: AnimatedBuilder(
                  animation: _pulseCtrl,
                  builder: (_, _) => Opacity(
                    opacity: _glow2Opacity.value * 0.6,
                    child: Container(
                      width: 180, height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF3B82F6).withAlpha(40),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Tertiary accent glow (top-left) ──────────────────────
              Positioned(
                top: 0, left: -40,
                child: AnimatedBuilder(
                  animation: _pulseCtrl,
                  builder: (_, _) => Opacity(
                    opacity: (1.0 - (_pulseOpacity.value - 0.5)) * 0.4,
                    child: Container(
                      width: 160, height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF6EE7B7).withAlpha(30),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Main content ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(flex: 3),

                    // Logo with elastic entrance + continuous float
                    AnimatedBuilder(
                      animation: Listenable.merge([_contentCtrl, _floatCtrl]),
                      builder: (_, _) => Transform.translate(
                        offset: Offset(0, _logoFloat.value),
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: Opacity(
                            opacity: _logoOpacity.value.clamp(0.0, 1.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Glowing icon container
                                Container(
                                  width: 88, height: 88,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        AppTheme.teal.withAlpha(60),
                                        Colors.transparent,
                                      ],
                                    ),
                                    border: Border.all(
                                      color: AppTheme.teal.withAlpha(80),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '\u{1F30D}', // Earth 🌍
                                      style: TextStyle(fontSize: 44),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Title
                    AnimatedBuilder(
                      animation: _contentCtrl,
                      builder: (_, child) => SlideTransition(
                        position: _titleSlide,
                        child: FadeTransition(
                          opacity: _titleOpacity,
                          child: child,
                        ),
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(color: Colors.white, height: 1.15),
                          children: [
                            TextSpan(text: L10n.of(context)!.splashTagline),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Subtitle
                    AnimatedBuilder(
                      animation: _contentCtrl,
                      builder: (_, child) => SlideTransition(
                        position: _subtitleSlide,
                        child: FadeTransition(
                          opacity: _subtitleOpacity,
                          child: child,
                        ),
                      ),
                      child: Text(
                        L10n.of(context)!.splashSubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withAlpha(115),
                          height: 1.65,
                        ),
                      ),
                    ),

                    const Spacer(flex: 2),

                    // Buttons
                    AnimatedBuilder(
                      animation: _buttonCtrl,
                      builder: (_, child) => SlideTransition(
                        position: _buttonSlide,
                        child: FadeTransition(
                          opacity: _buttonOpacity,
                          child: child,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _PressableButton(
                            onTap: () => context.go('/register'),
                            backgroundColor: AppTheme.teal,
                            child: Text(
                              L10n.of(context)!.getStarted,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _PressableButton(
                            onTap: () => context.go('/login'),
                            backgroundColor: Colors.transparent,
                            borderColor: Colors.white.withAlpha(35),
                            child: Text(
                              L10n.of(context)!.signInToAccount,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withAlpha(180),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 52),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Pressable button with scale + opacity feedback ────────────────────────────

class _PressableButton extends StatefulWidget {
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color? borderColor;
  final Widget child;

  const _PressableButton({
    required this.onTap,
    required this.backgroundColor,
    required this.child,
    this.borderColor,
  });

  @override
  State<_PressableButton> createState() => _PressableButtonState();
}

class _PressableButtonState extends State<_PressableButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _opacity = Tween<double>(begin: 1.0, end: 0.80).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _ctrl.forward();
  void _onTapUp(TapUpDetails _) {
    _ctrl.reverse();
    widget.onTap();
  }
  void _onTapCancel() => _ctrl.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) => Transform.scale(
          scale: _scale.value,
          child: Opacity(
            opacity: _opacity.value,
            child: child,
          ),
        ),
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: widget.borderColor != null
                ? Border.all(color: widget.borderColor!, width: 1.5)
                : null,
          ),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}
