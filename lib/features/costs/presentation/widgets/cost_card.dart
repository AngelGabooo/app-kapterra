// lib/features/costs/presentation/widgets/cost_card.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/costs/data/models/cost_model.dart';

class CostCard extends StatelessWidget {
  final CostModel cost;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const CostCard({
    super.key,
    required this.cost,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: cost.category.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(cost.category.icon, size: 22, color: cost.category.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cost.concept, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkCoffee)),
                        Text(cost.category.title, style: TextStyle(fontSize: 12, color: cost.category.color)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(cost.formattedAmount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                      Text(cost.lotName, style: TextStyle(fontSize: 11, color: AppTheme.darkCoffee.withOpacity(0.5))),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildInfoChip(Icons.calendar_today, '${cost.date.day}/${cost.date.month}/${cost.date.year}'),
                  const SizedBox(width: 8),
                  if (cost.provider != null) _buildInfoChip(Icons.business, cost.provider!),
                  const SizedBox(width: 8),
                  if (cost.hasInvoice) _buildInfoChip(Icons.receipt, 'Comprobante'),
                ],
              ),
              const SizedBox(height: 12),
              Divider(color: Colors.grey.withOpacity(0.2), height: 1),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: onTap,
                    icon: Icon(Icons.visibility, size: 18, color: AppTheme.primaryGreen),
                    label: Text('Ver detalle', style: TextStyle(color: AppTheme.primaryGreen)),
                  ),
                  const SizedBox(width: 4),
                  TextButton.icon(
                    onPressed: onEdit,
                    icon: Icon(Icons.edit, size: 18, color: AppTheme.goldCoffee),
                    label: Text('Editar', style: TextStyle(color: AppTheme.goldCoffee)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.darkCoffee.withOpacity(0.5)),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, color: AppTheme.darkCoffee.withOpacity(0.7))),
        ],
      ),
    );
  }
}