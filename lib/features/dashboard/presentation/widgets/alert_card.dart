import 'package:flutter/material.dart';
import 'package:kaabcafe/features/dashboard/data/models/alert_model.dart';

class AlertCard extends StatelessWidget {
  final AlertModel alert;
  const AlertCard({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: alert.priorityColor.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: alert.priorityColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(alert.icon, color: alert.priorityColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title.toUpperCase(),
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: alert.priorityColor, letterSpacing: 0.3), // 🚀 Corregido w900
                ),
                Text(alert.description, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withOpacity(0.7)), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_rounded, color: alert.priorityColor, size: 16),
        ],
      ),
    );
  }
}