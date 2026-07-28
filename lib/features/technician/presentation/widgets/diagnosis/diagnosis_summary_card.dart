// lib/features/technician/presentation/widgets/diagnosis/diagnosis_summary_card.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';
import 'package:kaabcafe/features/technician/data/models/technician_diagnosis_model.dart';

class DiagnosisSummaryCard extends StatelessWidget {
  final bool isDark;
  final TechnicianDiagnosisModel? diagnosis;

  const DiagnosisSummaryCard({
    super.key,
    required this.isDark,
    this.diagnosis,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    // ✅ Usar datos del diagnóstico si están disponibles
    final String status = diagnosis?.status ?? 'Sin evaluar';
    final int score = diagnosis?.healthScore?.toInt() ?? 0;
    final Color statusColor = diagnosis != null
        ? diagnosis!.healthScore >= 80
        ? AppTheme.primaryGreen
        : diagnosis!.healthScore >= 60
        ? AppTheme.goldCoffee
        : AppTheme.berryRed
        : Colors.grey;

    final String description = diagnosis != null
        ? diagnosis!.healthScore >= 80
        ? 'El cultivo presenta condiciones óptimas de producción.'
        : diagnosis!.healthScore >= 60
        ? 'Se recomienda atención en este cultivo.'
        : '¡Alerta! El cultivo requiere intervención inmediata.'
        : 'Selecciona un productor y comienza el diagnóstico.';

    return NeumorphicBox(
      isDark: isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Indicador circular
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: score > 0 ? score / 100 : 0,
                  strokeWidth: 8,
                  backgroundColor: textColor.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      score > 0 ? '$score' : '--',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    Text(
                      '/100',
                      style: TextStyle(
                        fontSize: 10,
                        color: textColor.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Estado del cultivo:',
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor.withOpacity(0.7),
                    height: 1.3,
                  ),
                ),
                if (diagnosis != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.person, size: 12, color: textColor.withOpacity(0.4)),
                      const SizedBox(width: 4),
                      Text(
                        'Técnico: ${diagnosis!.technicianName}',
                        style: TextStyle(
                          fontSize: 11,
                          color: textColor.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.calendar_today, size: 12, color: textColor.withOpacity(0.4)),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(diagnosis!.diagnosisDate),
                        style: TextStyle(
                          fontSize: 11,
                          color: textColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}