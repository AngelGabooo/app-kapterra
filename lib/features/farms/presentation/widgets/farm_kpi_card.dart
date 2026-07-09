import 'package:flutter/material.dart';
import '../../../../core/widgets/neumorphic_widgets.dart';

const Color _kCreamLight = Color(0xFFFBF3E6);

class FarmKPICard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final double? height;
  final bool useNeonAccent;
  final Color? color;
  final double? valueSize;
  final double? titleSize;

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
    const accent = Color(0xFFFF6B00);
    final Color activeColor = color ?? (useNeonAccent ? accent : theme.colorScheme.primary);

    return NeumorphicBox(
      borderRadius: 24,
      intensity: useNeonAccent ? 6 : 5,
      color: isDark ? null : _kCreamLight,
      gradient: useNeonAccent
          ? LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? [accent.withOpacity(0.14), accent.withOpacity(0.05)]
            : [accent.withOpacity(0.12), _kCreamLight],
      )
          : null,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: activeColor.withOpacity(isDark ? 0.18 : 0.10),
              ),
              child: Icon(icon, size: 16, color: activeColor),
            ),
            if (height != null && height! > 120) const Spacer() else const SizedBox(height: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: TextStyle(
                      fontSize: titleSize ?? 9,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface.withOpacity(useNeonAccent ? 0.6 : 0.4),
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: valueSize ?? (height != null && height! > 120 ? 26 : 18),
                      fontWeight: FontWeight.w900,
                      color: useNeonAccent ? accent : theme.colorScheme.onSurface,
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}