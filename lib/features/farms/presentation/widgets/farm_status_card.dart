import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';

class FarmStatusCard extends StatelessWidget {
  final FarmDetailsModel farm;

  const FarmStatusCard({super.key, required this.farm});

  @override
  Widget build(BuildContext context) {
    final score = farm.status == FarmHealthStatus.healthy ? 92 :
    farm.status == FarmHealthStatus.attention ? 65 : 40;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            farm.statusColor.withOpacity(0.1),
            farm.statusColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: farm.statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estado actual',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkCoffee,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: farm.statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                farm.statusText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: farm.statusColor,
                ),
              ),
              const Spacer(),
              Text(
                '$score/100',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkCoffee,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            farm.status == FarmHealthStatus.healthy
                ? 'La finca presenta condiciones favorables de producción y crecimiento.'
                : farm.status == FarmHealthStatus.attention
                ? 'Se recomienda atención en algunas áreas de la finca.'
                : 'Se requiere acción inmediata en ciertos lotes.',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.darkCoffee.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: score / 100,
              backgroundColor: Colors.grey.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(farm.statusColor),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}