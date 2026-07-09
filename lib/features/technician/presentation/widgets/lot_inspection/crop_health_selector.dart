// lib/features/technician/presentation/widgets/lot_inspection/crop_health_selector.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';

class CropHealthSelector extends StatelessWidget {
  final bool isDark;
  final int value;
  final ValueChanged<int> onChanged;

  const CropHealthSelector({
    super.key,
    required this.isDark,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    final List<Map<String, dynamic>> options = [
      {'label': 'Excelente', 'color': AppTheme.primaryGreen, 'emoji': '🟢'},
      {'label': 'Bueno', 'color': AppTheme.secondaryGreen, 'emoji': '🟢'},
      {'label': 'Regular', 'color': AppTheme.goldCoffee, 'emoji': '🟡'},
      {'label': 'Requiere atención', 'color': AppTheme.alertOrange, 'emoji': '🟠'},
      {'label': 'Crítico', 'color': AppTheme.berryRed, 'emoji': '🔴'},
    ];

    return NeumorphicBox(
      isDark: isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(14),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: List.generate(options.length, (index) {
          final option = options[index];
          final isSelected = value == index;
          return GestureDetector(
            onTap: () => onChanged(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? (option['color'] as Color).withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? (option['color'] as Color)
                      : textColor.withOpacity(0.1),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(option['emoji'], style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    option['label'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? (option['color'] as Color) : textColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}