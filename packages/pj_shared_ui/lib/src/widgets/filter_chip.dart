import 'package:flutter/material.dart';

class ShipmentFilterChip extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;
  final Color borderColor;
  final Color activeTextColor;
  final Color inactiveTextColor;

  const ShipmentFilterChip({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.activeColor = const Color(0xFF12131A),
    this.inactiveColor = Colors.white,
    this.borderColor = const Color(0xFFE8E6E0),
    this.activeTextColor = Colors.white,
    this.inactiveTextColor = const Color(0xFF9A9AA8),
  });

  @override
  State<ShipmentFilterChip> createState() => _ShipmentFilterChipState();
}

class _ShipmentFilterChipState extends State<ShipmentFilterChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      reverseDuration: const Duration(milliseconds: 160),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            color: widget.isActive ? widget.activeColor : widget.inactiveColor,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: widget.isActive ? widget.activeColor : widget.borderColor,
              width: 1.5,
            ),
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: widget.activeColor.withAlpha(40),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: widget.isActive ? widget.activeTextColor : widget.inactiveTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
