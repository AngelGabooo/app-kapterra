import 'package:flutter/material.dart';
import 'package:kaabcafe/features/dashboard/data/models/farm_summary_model.dart';

class FarmCard extends StatelessWidget {
  final FarmSummaryModel farm;
  const FarmCard({super.key, required this.farm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 28,
            decoration: BoxDecoration(
              color: farm.statusColor,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(farm.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: theme.colorScheme.onSurface, letterSpacing: -0.3)),
                const SizedBox(height: 1),
                Text(
                  '${farm.hectares} HA  •  ${farm.production} KG',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface.withOpacity(0.35), letterSpacing: 0.2), // 🚀 Corregido w900
                ),              ],
            ),
          ),
          Icon(Icons.north_east_rounded, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.25)),
        ],
      ),
    );
  }
}