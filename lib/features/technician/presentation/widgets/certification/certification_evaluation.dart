// lib/features/technician/presentation/widgets/certification/certification_evaluation.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';

class CertificationEvaluation extends StatelessWidget {
  final bool isDark;
  final int value;
  final ValueChanged<int> onChanged;

  const CertificationEvaluation({
    super.key,
    required this.isDark,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    final options = [
      {'label': 'Aprobado', 'color': AppTheme.primaryGreen, 'emoji': '🟢'},
      {'label': 'Aprobado con observaciones', 'color': AppTheme.goldCoffee, 'emoji': '🟡'},
      {'label': 'Solicitar correcciones', 'color': AppTheme.alertOrange, 'emoji': '🟠'},
      {'label': 'Rechazado', 'color': AppTheme.berryRed, 'emoji': '🔴'},
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
          final color = option['color'] as Color;

          return GestureDetector(
            onTap: () => onChanged(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? color : textColor.withOpacity(0.1),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(option['emoji'] as String, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    option['label'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? color : textColor,
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