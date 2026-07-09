import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart' hide NeumorphicBox;
import 'package:kaabcafe/features/dashboard/data/models/farm_summary_model.dart';

import '../../../auth/presentation/widgets/neumorphic_box.dart';

const Color _kCreamLight = Color(0xFFFBF3E6);

class FarmCard extends StatelessWidget {
  final FarmSummaryModel farm;
  final bool isDark;

  const FarmCard({
    super.key,
    required this.farm,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = isDark || theme.brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : AppTheme.darkCoffee;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NeumorphicBox(
        borderRadius: 22,
        color: isDarkMode ? null : _kCreamLight,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 28,
              decoration: BoxDecoration(
                color: farm.statusColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    farm.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    '${farm.hectares} HA  •  ${farm.production} KG',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: textColor.withOpacity(0.35),
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withOpacity(isDarkMode ? 0.14 : 0.08),
              ),
              child: Icon(
                Icons.north_east_rounded,
                size: 14,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}