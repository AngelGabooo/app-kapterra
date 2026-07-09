// lib/features/technician/presentation/widgets/lot_inspection/inspection_summary_card.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';

class InspectionSummaryCard extends StatelessWidget {
  final bool isDark;
  final int cropHealth;
  final List<Map<String, dynamic>> pests;
  final int photosCount;
  final bool hasObservations;
  final int priority;

  const InspectionSummaryCard({
    super.key,
    required this.isDark,
    required this.cropHealth,
    required this.pests,
    required this.photosCount,
    required this.hasObservations,
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final totalPests = pests.where((p) => p['checked'] == true && p['label'] != 'Ninguna').length;
    final cropHealthOptions = ['Excelente', 'Bueno', 'Regular', 'Requiere atención', 'Crítico'];
    final priorityOptions = [
      {'label': 'Baja', 'color': AppTheme.primaryGreen},
      {'label': 'Media', 'color': AppTheme.goldCoffee},
      {'label': 'Alta', 'color': AppTheme.alertOrange},
      {'label': 'Crítica', 'color': AppTheme.berryRed},
    ];

    final priorityColor = priorityOptions[priority]['color'] as Color;
    final priorityLabel = priorityOptions[priority]['label'] as String;

    return NeumorphicBox(
      isDark: isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _buildSummaryRow('📊 Estado general', cropHealthOptions[cropHealth], textColor),
          const SizedBox(height: 6),
          _buildSummaryRow('🦠 Plagas detectadas', '$totalPests', textColor),
          const SizedBox(height: 6),
          _buildSummaryRow('📷 Fotografías', '$photosCount', textColor),
          const SizedBox(height: 6),
          _buildSummaryRow(
            '📝 Observaciones',
            hasObservations ? '✓ Registradas' : '✗ Pendientes',
            textColor,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                '⚡ Prioridad:',
                style: TextStyle(
                  fontSize: 12,
                  color: textColor.withOpacity(0.6),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  priorityLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: priorityColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color textColor) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textColor.withOpacity(0.6),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ],
    );
  }
}