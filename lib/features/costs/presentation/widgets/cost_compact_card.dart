// lib/features/costs/presentation/widgets/cost_compact_card.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/costs/data/models/cost_model.dart';

class CostCompactCard extends StatelessWidget {
  final CostModel cost;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const CostCompactCard({
    super.key,
    required this.cost,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: cost.category.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(cost.category.icon, size: 22, color: cost.category.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cost.concept, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCoffee)),
                    const SizedBox(height: 2),
                    Text(cost.lotName, style: TextStyle(fontSize: 11, color: AppTheme.darkCoffee.withOpacity(0.6))),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(cost.formattedAmount, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                  const SizedBox(height: 2),
                  Text('${cost.date.day}/${cost.date.month}', style: TextStyle(fontSize: 10, color: AppTheme.darkCoffee.withOpacity(0.5))),
                ],
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onEdit,
                icon: Icon(Icons.edit, size: 18, color: AppTheme.goldCoffee),
              ),
            ],
          ),
        ),
      ),
    );
  }
}