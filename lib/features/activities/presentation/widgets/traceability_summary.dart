import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class TraceabilitySummary extends StatelessWidget {
  const TraceabilitySummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryGreen.withOpacity(0.05),
            AppTheme.goldCoffee.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryGreen.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppTheme.primaryGreen),
              const SizedBox(width: 8),
              const Text(
                'Resumen de trazabilidad',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.darkCoffee,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Esta actividad quedará registrada en el historial del lote y formará parte del pasaporte digital de trazabilidad.',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.darkCoffee,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildTraceabilityIcon(Icons.qr_code, 'Trazabilidad'),
              const SizedBox(width: 16),
              _buildTraceabilityIcon(Icons.analytics, 'Indicadores'),
              const SizedBox(width: 16),
              _buildTraceabilityIcon(Icons.emoji_food_beverage, 'Calidad'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTraceabilityIcon(IconData icon, String label) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 14, color: AppTheme.primaryGreen),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppTheme.darkCoffee.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}