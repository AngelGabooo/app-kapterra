// lib/features/technician/presentation/widgets/diagnosis/diagnosis_prediction_card.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';
import 'package:kaabcafe/features/technician/data/models/technician_diagnosis_model.dart';

class DiagnosisPredictionCard extends StatelessWidget {
  final bool isDark;
  final TechnicianDiagnosisModel? diagnosis;

  const DiagnosisPredictionCard({
    super.key,
    required this.isDark,
    this.diagnosis,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    final predictions = _calculatePredictions(diagnosis);

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
          if (diagnosis == null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: textColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Completa el diagnóstico para ver las predicciones',
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor.withOpacity(0.5),
                  ),
                ),
              ),
            )
          else
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

  List<Map<String, dynamic>> _calculatePredictions(TechnicianDiagnosisModel? diagnosis) {
    if (diagnosis == null) {
      return [
        {'label': '📈 Producción esperada', 'value': '--', 'color': Colors.grey},
        {'label': '☕ Calidad estimada', 'value': '--', 'color': Colors.grey},
        {'label': '💰 Rentabilidad proyectada', 'value': '--', 'color': Colors.grey},
        {'label': '🌎 Nivel de sostenibilidad', 'value': '--', 'color': Colors.grey},
      ];
    }

    final healthScore = diagnosis.healthScore;
    final hasPests = diagnosis.issues.any((issue) =>
    issue.title.toLowerCase().contains('plaga') ||
        issue.title.toLowerCase().contains('pest')
    );
    final hasRisks = diagnosis.risks.isNotEmpty;

    String production;
    Color productionColor;
    if (healthScore >= 80 && !hasPests && !hasRisks) {
      production = '850 kg/ha';
      productionColor = AppTheme.primaryGreen;
    } else if (healthScore >= 60) {
      production = '650 kg/ha';
      productionColor = AppTheme.goldCoffee;
    } else {
      production = '450 kg/ha';
      productionColor = AppTheme.alertOrange;
    }

    String quality;
    Color qualityColor;
    if (healthScore >= 80) {
      quality = '87 pts';
      qualityColor = AppTheme.primaryGreen;
    } else if (healthScore >= 60) {
      quality = '78 pts';
      qualityColor = AppTheme.goldCoffee;
    } else {
      quality = '65 pts';
      qualityColor = AppTheme.alertOrange;
    }

    String profitability;
    Color profitabilityColor;
    if (healthScore >= 80 && !hasPests) {
      profitability = '+15%';
      profitabilityColor = AppTheme.primaryGreen;
    } else if (healthScore >= 60) {
      profitability = '+5%';
      profitabilityColor = AppTheme.goldCoffee;
    } else {
      profitability = '-10%';
      profitabilityColor = AppTheme.berryRed;
    }

    String sustainability;
    Color sustainabilityColor;
    if (healthScore >= 80 && !hasPests && !hasRisks) {
      sustainability = 'Excelente';
      sustainabilityColor = AppTheme.primaryGreen;
    } else if (healthScore >= 60) {
      sustainability = 'Bueno';
      sustainabilityColor = AppTheme.secondaryGreen;
    } else {
      sustainability = 'Requiere atención';
      sustainabilityColor = AppTheme.alertOrange;
    }

    return [
      {'label': '📈 Producción esperada', 'value': production, 'color': productionColor},
      {'label': '☕ Calidad estimada', 'value': quality, 'color': qualityColor},
      {'label': '💰 Rentabilidad proyectada', 'value': profitability, 'color': profitabilityColor},
      {'label': '🌎 Nivel de sostenibilidad', 'value': sustainability, 'color': sustainabilityColor},
    ];
  }
}