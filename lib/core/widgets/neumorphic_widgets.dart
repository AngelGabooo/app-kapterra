import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

/// Caja neumórfica genérica. Úsala para envolver contenido plano (flat)
/// que necesite una superficie "suave" en vez de sombra tradicional.
class NeumorphicBox extends StatelessWidget {
  const NeumorphicBox({
    super.key,
    required this.child,
    this.isDark = false,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(16),
    this.pressed = false,
    this.intensity = 6,
    this.color,
    this.gradient,
  });

  final Widget child;
  final bool isDark;
  final double borderRadius;
  final EdgeInsets padding;
  final bool pressed;
  final double intensity;
  final Color? color;
  final Gradient? gradient;

  /// Constructor para versión "inset" (hundida)
  const NeumorphicBox.inset({
    super.key,
    required this.child,
    this.isDark = false,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(16),
    this.intensity = 4,
    this.color,
    this.gradient,
  }) : pressed = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = isDark || theme.brightness == Brightness.dark;

    // Si se proporciona color o gradient, usarlos
    final hasCustomStyle = color != null || gradient != null;

    if (hasCustomStyle) {
      // Versión con color personalizado - SIN SOMBRAS
      final baseColor = color ?? (isDarkMode
          ? AppTheme.coffeeDeep.withOpacity(0.7)
          : const Color(0xFFE8E0D5).withOpacity(0.9));

      return Container(
        padding: padding,
        decoration: BoxDecoration(
          color: gradient == null ? baseColor : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isDarkMode
                ? Colors.white.withOpacity(0.06)
                : AppTheme.darkCoffee.withOpacity(0.06),
            width: 0.5,
          ),
          boxShadow: const [], // ✅ SIN SOMBRAS
        ),
        child: child,
      );
    }

    // Versión original con neumorfismo (con sombras)
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: AppTheme.neuFillGradient(isDarkMode),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: pressed
            ? AppTheme.neuPressed(isDarkMode)
            : AppTheme.neuRaised(isDarkMode, intensity: intensity),
      ),
      child: child,
    );
  }
}

/// ============================================================
/// VERSIÓN FLAT (SIN SOMBRAS) - NUEVO
/// ============================================================
class NeumorphicBoxFlat extends StatelessWidget {
  const NeumorphicBoxFlat({
    super.key,
    required this.child,
    this.isDark = false,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.gradient,
  });

  final Widget child;
  final bool isDark;
  final double borderRadius;
  final EdgeInsets padding;
  final Color? color;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = isDark || theme.brightness == Brightness.dark;

    final baseColor = color ?? (isDarkMode
        ? AppTheme.coffeeDeep.withOpacity(0.7)
        : const Color(0xFFE8E0D5).withOpacity(0.9));

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? baseColor : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isDarkMode
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

/// ============================================================
/// VERSIÓN INSET FLAT (SIN SOMBRAS) - NUEVO
/// ============================================================
class NeumorphicBoxInsetFlat extends StatelessWidget {
  const NeumorphicBoxInsetFlat({
    super.key,
    required this.child,
    this.isDark = false,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(16),
    this.color,
  });

  final Widget child;
  final bool isDark;
  final double borderRadius;
  final EdgeInsets padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = isDark || theme.brightness == Brightness.dark;

    final baseColor = color ?? (isDarkMode
        ? AppTheme.coffeeDark.withOpacity(0.5)
        : const Color(0xFFE8E0D5).withOpacity(0.7));

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isDarkMode
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

/// ============================================================
/// NEUMORPHIC ICON BUTTON (ORIGINAL)
/// ============================================================
class NeumorphicIconButton extends StatefulWidget {
  const NeumorphicIconButton({
    super.key,
    required this.icon,
    required this.isDark,
    required this.onPressed,
    this.size = 46,
    this.iconSize = 20,
    this.color,
  });

  final IconData icon;
  final bool isDark;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;
  final Color? color;

  @override
  State<NeumorphicIconButton> createState() => _NeumorphicIconButtonState();
}

class _NeumorphicIconButtonState extends State<NeumorphicIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final iconColor = widget.color ??
        (widget.isDark ? AppTheme.coffeeGoldLight : AppTheme.darkCoffee);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppTheme.neuFillGradient(widget.isDark),
          boxShadow: _pressed
              ? AppTheme.neuPressed(widget.isDark)
              : AppTheme.neuRaised(widget.isDark),
        ),
        child: Icon(widget.icon, size: widget.iconSize, color: iconColor),
      ),
    );
  }
}

/// ============================================================
/// NEUMORPHIC ICON BUTTON FLAT (SIN SOMBRAS) - NUEVO
/// ============================================================
class NeumorphicIconButtonFlat extends StatefulWidget {
  const NeumorphicIconButtonFlat({
    super.key,
    required this.icon,
    required this.isDark,
    required this.onPressed,
    this.size = 46,
    this.iconSize = 20,
    this.color,
  });

  final IconData icon;
  final bool isDark;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;
  final Color? color;

  @override
  State<NeumorphicIconButtonFlat> createState() =>
      _NeumorphicIconButtonFlatState();
}

class _NeumorphicIconButtonFlatState
    extends State<NeumorphicIconButtonFlat> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDark ? Colors.white : AppTheme.darkCoffee;
    final iconColor = widget.color ?? textColor;

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
                ? AppTheme.coffeeDeep.withOpacity(0.7)
                : const Color(0xFFE8E0D5).withOpacity(0.9),
            border: Border.all(
              color: textColor.withOpacity(0.06),
              width: 0.5,
            ),
            boxShadow: const [],
          ),
          child: Icon(
            widget.icon,
            size: widget.iconSize,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}

/// ============================================================
/// NEUMORPHIC ACTION BUTTON (ORIGINAL)
/// ============================================================
class NeumorphicActionButton extends StatefulWidget {
  const NeumorphicActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isDark,
    required this.onPressed,
    this.accentColor,
  });

  final String label;
  final IconData icon;
  final bool isDark;
  final VoidCallback onPressed;
  final Color? accentColor;

  @override
  State<NeumorphicActionButton> createState() =>
      _NeumorphicActionButtonState();
}

class _NeumorphicActionButtonState extends State<NeumorphicActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor ??
        (widget.isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        decoration: BoxDecoration(
          gradient: AppTheme.neuFillGradient(widget.isDark),
          borderRadius: BorderRadius.circular(18),
          boxShadow: _pressed
              ? AppTheme.neuPressed(widget.isDark)
              : AppTheme.neuRaised(widget.isDark),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, size: 18, color: accent),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================
/// NEUMORPHIC ACTION BUTTON FLAT (SIN SOMBRAS) - NUEVO
/// ============================================================
class NeumorphicActionButtonFlat extends StatefulWidget {
  const NeumorphicActionButtonFlat({
    super.key,
    required this.label,
    required this.icon,
    required this.isDark,
    required this.onPressed,
    this.accentColor,
  });

  final String label;
  final IconData icon;
  final bool isDark;
  final VoidCallback onPressed;
  final Color? accentColor;

  @override
  State<NeumorphicActionButtonFlat> createState() =>
      _NeumorphicActionButtonFlatState();
}

class _NeumorphicActionButtonFlatState
    extends State<NeumorphicActionButtonFlat> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor ??
        (widget.isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen);
    final textColor = widget.isDark ? Colors.white : AppTheme.darkCoffee;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          decoration: BoxDecoration(
            color: widget.isDark
                ? AppTheme.coffeeDeep.withOpacity(0.7)
                : const Color(0xFFE8E0D5).withOpacity(0.9),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: textColor.withOpacity(0.06),
              width: 0.5,
            ),
            boxShadow: const [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 18, color: accent),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ============================================================
/// NEUMORPHIC BOTTOM NAV (ORIGINAL)
/// ============================================================
class NeumorphicBottomNav extends StatelessWidget {
  const NeumorphicBottomNav({
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          gradient: AppTheme.neuFillGradient(isDark),
          borderRadius: BorderRadius.circular(28),
          boxShadow: AppTheme.neuRaised(isDark),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(items.length, (index) {
            final isSelected = index == currentIndex;
            final accent =
            isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen;
            final inactive =
            (isDark ? Colors.white : AppTheme.darkCoffee).withOpacity(0.35);

            return GestureDetector(
              onTap: () => onTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: isSelected ? AppTheme.neuPressed(isDark) : [],
                ),
                child: Icon(
                  items[index],
                  size: 22,
                  color: isSelected ? accent : inactive,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

/// ============================================================
/// NEUMORPHIC BOTTOM NAV FLAT (SIN SOMBRAS) - NUEVO
/// ============================================================
class NeumorphicBottomNavFlat extends StatelessWidget {
  const NeumorphicBottomNavFlat({
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
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final accent = isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isDark
              ? AppTheme.coffeeDeep.withOpacity(0.9)
              : const Color(0xFFE8E0D5).withOpacity(0.9),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: textColor.withOpacity(0.06),
            width: 0.5,
          ),
          boxShadow: const [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(items.length, (index) {
            final isSelected = index == currentIndex;
            final inactive = textColor.withOpacity(0.35);

            return GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? accent.withOpacity(0.12)
                      : Colors.transparent,
                ),
                child: Icon(
                  items[index],
                  size: 22,
                  color: isSelected ? accent : inactive,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}