import 'package:flutter/material.dart';

class FarmKPICard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final double? height;
  final bool useNeonAccent;
  final Color? color;
  final double? valueSize; // 🚀 Nuevo parámetro opcional
  final double? titleSize; // 🚀 Nuevo parámetro opcional

  const FarmKPICard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.height,
    this.useNeonAccent = false,
    this.color,
    this.valueSize,
    this.titleSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color activeColor = color ?? (useNeonAccent ? const Color(0xFFFF6B00) : theme.colorScheme.primary);

    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: useNeonAccent
            ? const Color(0xFFFF6B00).withOpacity(isDark ? 0.08 : 0.05)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: useNeonAccent
              ? const Color(0xFFFF6B00).withOpacity(0.3)
              : activeColor.withOpacity(isDark ? 0.1 : 0.15),
          width: useNeonAccent ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: activeColor),

          if (height != null && height! > 120)
            const Spacer()
          else
            const SizedBox(height: 8),

          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                      fontSize: titleSize ?? 9, // 🚀 Si no se envía nada, usa 9 por defecto
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface.withOpacity(useNeonAccent ? 0.6 : 0.4),
                      letterSpacing: 0.5
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: TextStyle(
                      fontSize: valueSize ?? (height != null && height! > 120 ? 26 : 18), // 🚀 Customizado o dinámico
                      fontWeight: FontWeight.w900,
                      color: useNeonAccent ? const Color(0xFFFF6B00) : theme.colorScheme.onSurface,
                      letterSpacing: -0.5,
                      height: 1.1
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}