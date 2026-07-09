import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';
import 'package:kaabcafe/features/costs/data/models/cost_model.dart';

class CostCompactCard extends StatelessWidget {
  final CostModel cost;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final bool isDark;

  const CostCompactCard({
    super.key,
    required this.cost,
    required this.onTap,
    required this.onEdit,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return NeumorphicBox(
      isDark: isDark,
      borderRadius: 16,
      padding: const EdgeInsets.all(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cost.category.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(cost.category.icon, size: 22, color: cost.category.color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cost.concept,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    cost.lotName,
                    style: TextStyle(
                      fontSize: 11,
                      color: textColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  cost.formattedAmount,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${cost.date.day}/${cost.date.month}',
                  style: TextStyle(
                    fontSize: 10,
                    color: textColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            NeumorphicIconButton(
              icon: Icons.edit,
              isDark: isDark,
              onPressed: onEdit,
              size: 36,
              iconSize: 16,
              color: AppTheme.goldCoffee,
            ),
          ],
        ),
      ),
    );
  }
}