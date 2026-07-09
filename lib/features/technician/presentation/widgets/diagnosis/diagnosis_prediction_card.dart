// lib/features/technician/presentation/widgets/diagnosis/diagnosis_prediction_card.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';

class DiagnosisPredictionCard extends StatelessWidget {
  final bool isDark;

  const DiagnosisPredictionCard({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    final predictions = [
      {'label': '📈 Producción esperada', 'value': '850 kg/ha', 'color': AppTheme.primaryGreen},
      {'label': '☕ Calidad estimada', 'value': '87 pts', 'color': AppTheme.goldCoffee},
      {'label': '💰 Rentabilidad proyectada', 'value': '+12%', 'color': AppTheme.secondaryGreen},
      {'label': '🌎 Nivel de sostenibilidad', 'value': 'Bueno', 'color': AppTheme.primaryGreen},
    ];

    return NeumorphicBox(
      isDark: isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Predicción del cultivo',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: predictions.map((pred) {
              final color = pred['color'] as Color;
              return Container(
                padding: const EdgeInsets.all(12),
                width: (MediaQuery.of(context).size.width - 56) / 2,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: color.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pred['label'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        color: textColor.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pred['value'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}