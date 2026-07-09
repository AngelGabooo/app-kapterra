// lib/features/technician/presentation/widgets/lot_inspection/priority_selector.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';

class PrioritySelector extends StatelessWidget {
  final bool isDark;
  final int value;
  final ValueChanged<int> onChanged;

  const PrioritySelector({
    super.key,
    required this.isDark,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    final List<Map<String, dynamic>> options = [
      {'label': 'Baja', 'color': AppTheme.primaryGreen, 'emoji': '🟢'},
      {'label': 'Media', 'color': AppTheme.goldCoffee, 'emoji': '🟡'},
      {'label': 'Alta', 'color': AppTheme.alertOrange, 'emoji': '🟠'},
      {'label': 'Crítica', 'color': AppTheme.berryRed, 'emoji': '🔴'},
    ];

    return NeumorphicBox(
      isDark: isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(14),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(options.length, (index) {
          final option = options[index];
          final isSelected = value == index;
          return GestureDetector(
            onTap: () => onChanged(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                      fontSize: 13,
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