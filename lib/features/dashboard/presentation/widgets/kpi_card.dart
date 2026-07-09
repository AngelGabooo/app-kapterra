import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart' hide NeumorphicBox;
import 'package:kaabcafe/features/dashboard/data/models/kpi_model.dart';

import '../../../auth/presentation/widgets/neumorphic_box.dart';

/// Crema/beige cálido usado en todo el flujo.
const Color _kCreamLight = Color(0xFFFBF3E6);

class KPICard extends StatelessWidget {
  final KPIModel kpi;
  final double? height;
  final bool useNeonAccent;
  final bool isDark;

  const KPICard({
    super.key,
    required this.kpi,
    this.height,
    this.useNeonAccent = false,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = isDark || theme.brightness == Brightness.dark;
    const accent = Color(0xFFFF6B00);
    final textColor = isDarkMode ? Colors.white : AppTheme.darkCoffee;

    return NeumorphicBox(
      borderRadius: 24,
      color: isDarkMode ? null : _kCreamLight,
      gradient: useNeonAccent
          ? LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDarkMode
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconBadge(theme, isDarkMode, accent),
                if (kpi.change != 0)
                  Flexible(
                    child: Text(
                      '${kpi.change > 0 ? '↑' : '↓'}${kpi.change.abs().toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: kpi.change > 0 ? Colors.green : Colors.red,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
            if (height != null && height! > 100) const Spacer() else const SizedBox(height: 6),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    kpi.title.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: textColor.withOpacity(useNeonAccent ? 0.6 : 0.4),
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    kpi.value,
                    style: TextStyle(
                      fontSize: height != null && height! > 100 ? 24 : 16,
                      fontWeight: FontWeight.w900,
                      color: useNeonAccent ? accent : textColor,
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

  Widget _iconBadge(ThemeData theme, bool isDark, Color accent) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: useNeonAccent
            ? accent.withOpacity(isDark ? 0.18 : 0.14)
            : theme.colorScheme.primary.withOpacity(isDark ? 0.16 : 0.10),
      ),
      child: Icon(
        kpi.icon,
        size: 14,
        color: useNeonAccent ? accent : theme.colorScheme.primary,
      ),
    );
  }
}