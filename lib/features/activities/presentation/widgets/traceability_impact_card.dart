// lib/features/activities/presentation/widgets/traceability_impact_card.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class TraceabilityImpactCard extends StatelessWidget {
  const TraceabilityImpactCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primaryGreen.withOpacity(0.05), AppTheme.goldCoffee.withOpacity(0.02)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppTheme.primaryGreen),
              const SizedBox(width: 8),
              const Text('Impacto en trazabilidad', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCoffee)),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Los cambios realizados quedarán registrados para mantener la transparencia y trazabilidad del lote.',
            style: TextStyle(fontSize: 12, color: AppTheme.darkCoffee),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildIconLabel(Icons.history, 'Historial'),
              const SizedBox(width: 16),
              _buildIconLabel(Icons.analytics, 'Indicadores'),
              const SizedBox(width: 16),
              _buildIconLabel(Icons.emoji_food_beverage, 'Calidad'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconLabel(IconData icon, String label) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: AppTheme.primaryGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 14, color: AppTheme.primaryGreen),
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, color: AppTheme.darkCoffee.withOpacity(0.7))),
      ],
    );
  }
}