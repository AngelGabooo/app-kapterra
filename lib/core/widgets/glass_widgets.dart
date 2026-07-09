import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

/// Panel de "cristal líquido" - SIN SOMBRAS
class LiquidGlassCard extends StatelessWidget {
  const LiquidGlassCard({
    super.key,
    required this.child,
    required this.isDark,
    this.radius = 28,
    this.padding = const EdgeInsets.all(18),
    this.blur = 18,
  });

  final Widget child;
  final bool isDark;
  final double radius;
  final EdgeInsets padding;
  final double blur;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [], // ✅ SIN SOMBRAS
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.coffeeDeep.withOpacity(0.35)
                  : const Color(0xFFE8E0D5).withOpacity(0.85),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                width: 1.2,
                color: isDark
                    ? Colors.white.withOpacity(0.08)
                    : AppTheme.darkCoffee.withOpacity(0.08),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  (isDark ? Colors.white : Colors.white).withOpacity(isDark ? 0.04 : 0.20),
                  Colors.transparent,
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Tarjeta "clay" - SIN SOMBRAS
class ClayCard extends StatelessWidget {
  const ClayCard({
    super.key,
    required this.child,
    required this.isDark,
    this.accent,
    this.radius = 26,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final bool isDark;
  final Color? accent;
  final double radius;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.coffeeDeep.withOpacity(0.7)
            : const Color(0xFFE8E0D5).withOpacity(0.9),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : AppTheme.darkCoffee.withOpacity(0.06),
          width: 0.5,
        ),
        boxShadow: const [], // ✅ SIN SOMBRAS
      ),
      child: child,
    );
  }
}

/// Botón de icono PLANO - SIN BRILLO
class GlowIconButton extends StatefulWidget {
  const GlowIconButton({
    super.key,
    required this.icon,
    required this.isDark,
    required this.onPressed,
    this.glowColor,
    this.size = 46,
  });

  final IconData icon;
  final bool isDark;
  final VoidCallback onPressed;
  final Color? glowColor;
  final double size;

  @override
  State<GlowIconButton> createState() => _GlowIconButtonState();
}

class _GlowIconButtonState extends State<GlowIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final iconColor = widget.isDark ? Colors.white.withOpacity(0.8) : AppTheme.darkCoffee;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.isDark
                ? AppTheme.coffeeDeep.withOpacity(0.5)
                : const Color(0xFFE8E0D5).withOpacity(0.8),
            border: Border.all(
              color: widget.isDark
                  ? Colors.white.withOpacity(0.06)
                  : AppTheme.darkCoffee.withOpacity(0.06),
              width: 0.5,
            ),
            boxShadow: const [], // ✅ SIN SOMBRAS
          ),
          child: Icon(widget.icon, size: 20, color: iconColor),
        ),
      ),
    );
  }
}

/// Barra de navegación PLANO - SIN BRILLO
class GlassBottomNav extends StatelessWidget {
  const GlassBottomNav({
    super.key,
    required this.isDark,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  final bool isDark;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<IconData> items;

  @override
  Widget build(BuildContext context) {
    final accent = isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isDark
              ? AppTheme.coffeeDeep.withOpacity(0.9)
              : const Color(0xFFE8E0D5).withOpacity(0.95),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : AppTheme.darkCoffee.withOpacity(0.05),
            width: 0.5,
          ),
          boxShadow: const [], // ✅ SIN SOMBRAS
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(items.length, (index) {
            final selected = index == currentIndex;
            final inactive =
            (isDark ? Colors.white : AppTheme.darkCoffee).withOpacity(0.35);
            return GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? accent.withOpacity(0.12)
                      : Colors.transparent,
                ),
                child: Icon(items[index], size: 22, color: selected ? accent : inactive),
              ),
            );
          }),
        ),
      ),
    );
  }
}

/// FAB PLANO - SIN BRILLO
class GlassFAB extends StatelessWidget {
  const GlassFAB({
    super.key,
    required this.label,
    required this.icon,
    required this.isDark,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool isDark;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final accent = isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen;

    return Tooltip(
      message: label,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: accent,
            shape: BoxShape.circle,
            boxShadow: const [], // ✅ SIN SOMBRAS
          ),
          child: Icon(icon, size: 26, color: Colors.white),
        ),
      ),
    );
  }
}