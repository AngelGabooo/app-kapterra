import 'package:flutter/material.dart';

/// Contenedor neumórfico reutilizable ("soft UI").
class NeumorphicBox extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Gradient? gradient;
  final Color? color;
  final double intensity;
  final bool inset;
  final bool isDark;

  const NeumorphicBox({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.padding,
    this.gradient,
    this.color,
    this.intensity = 6,
    this.inset = false,
    this.isDark = false,
  });

  const NeumorphicBox.inset({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.padding,
    this.gradient,
    this.color,
    this.intensity = 4,
    this.isDark = false,
  }) : inset = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = isDark || theme.brightness == Brightness.dark;

    // ✅ Usar el color proporcionado o el color de superficie del tema
    final baseColor = color ?? theme.colorScheme.surface;

    final Color lightShadow = isDarkMode
        ? Colors.white.withOpacity(0.035)
        : Colors.white.withOpacity(0.85);
    final Color darkShadow = isDarkMode
        ? Colors.black.withOpacity(0.55)
        : theme.colorScheme.primary.withOpacity(0.16);

    final decoratedChild = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? baseColor : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: inset
            ? Border.all(
          color: isDarkMode
              ? Colors.black.withOpacity(0.4)
              : theme.colorScheme.primary.withOpacity(0.10),
          width: 1,
        )
            : null,
        boxShadow: [
          BoxShadow(
            color: darkShadow,
            offset: Offset(inset ? intensity * 0.4 : intensity, inset ? intensity * 0.4 : intensity),
            blurRadius: intensity * (inset ? 1.2 : 2.4),
            spreadRadius: inset ? -1 : 0,
          ),
          BoxShadow(
            color: lightShadow,
            offset: Offset(
                inset ? -intensity * 0.4 : -intensity, inset ? -intensity * 0.4 : -intensity),
            blurRadius: intensity * (inset ? 1.2 : 2.4),
            spreadRadius: inset ? -1 : 0,
          ),
        ],
      ),
      child: child,
    );

    return decoratedChild;
  }
}