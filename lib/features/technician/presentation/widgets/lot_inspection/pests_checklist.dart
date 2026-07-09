// lib/features/technician/presentation/widgets/lot_inspection/pests_checklist.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';

class PestsChecklist extends StatelessWidget {
  final bool isDark;
  final List<Map<String, dynamic>> pests;
  final double affectionPercentage;
  final Function(int) onPestToggled;
  final Function(double) onPercentageChanged;

  const PestsChecklist({
    super.key,
    required this.isDark,
    required this.pests,
    required this.affectionPercentage,
    required this.onPestToggled,
    required this.onPercentageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final hasPests = pests.any((p) => p['checked'] == true && p['label'] != 'Ninguna');

    return NeumorphicBox(
      isDark: isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          ...pests.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: GestureDetector(
                onTap: () => onPestToggled(index),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: item['checked']
                            ? AppTheme.primaryGreen
                            : Colors.transparent,
                        border: Border.all(
                          color: item['checked']
                              ? AppTheme.primaryGreen
                              : textColor.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: item['checked']
                          ? const Icon(Icons.check, size: 12, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item['label'],
                        style: TextStyle(
                          fontSize: 13,
                          color: textColor,
                          decoration: item['checked']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: textColor.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 10),
          if (hasPests) ...[
            Row(
              children: [
                Text(
                  'Porcentaje estimado de afectación:',
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.6),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Slider(
                    value: affectionPercentage,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    activeColor: affectionPercentage > 50
                        ? AppTheme.berryRed
                        : affectionPercentage > 25
                        ? AppTheme.alertOrange
                        : AppTheme.primaryGreen,
                    onChanged: onPercentageChanged,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${affectionPercentage.toInt()}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}