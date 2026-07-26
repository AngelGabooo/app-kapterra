// lib/features/buyer/presentation/widgets/producer_ranking_card.dart

import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/buyer/data/models/producer_summary_model.dart';

class ProducerRankingCard extends StatelessWidget {
  final ProducerSummaryModel? producer;
  final bool isDark;
  final int? rank; // ✅ Agregar rank como parámetro

  const ProducerRankingCard({
    super.key,
    this.producer,
    required this.isDark,
    this.rank,
  });

  String get _medal {
    if (rank == null) return '--';
    switch (rank) {
      case 1: return '🥇';
      case 2: return '🥈';
      case 3: return '🥉';
      default: return '$rank';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    if (producer == null) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.coffeeDeep : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_outline, size: 16, color: Colors.grey),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Sin productores registrados',
                style: TextStyle(
                  fontSize: 14,
                  color: textColor.withOpacity(0.3),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.coffeeDeep : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              _medal,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producer!.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    // ✅ Usar campos existentes
                    _buildChip(Icons.eco, '${producer!.totalProduction.toStringAsFixed(0)} kg', Colors.green),
                    const SizedBox(width: 6),
                    _buildChip(Icons.agriculture, '${producer!.farmsCount} fincas', AppTheme.goldCoffee),
                    const SizedBox(width: 6),
                    _buildChip(Icons.people, '${producer!.lotsCount} lotes', AppTheme.secondaryGreen),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}