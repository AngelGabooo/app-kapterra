import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/technician/data/models/technician_model.dart';

class TechnicianProducerCard extends StatelessWidget {
  const TechnicianProducerCard({
    super.key,
    required this.producer,
    required this.isDark,
    required this.onTap,
  });

  final TechnicianProducerModel producer;
  final bool isDark;
  final VoidCallback onTap;

  Color _statusColor() {
    switch (producer.status) {
      case ProducerStatus.excellent:
        return AppTheme.primaryGreen;
      case ProducerStatus.requiresAttention:
        return AppTheme.alertOrange;
      case ProducerStatus.risk:
        return AppTheme.berryRed;
    }
  }

  String _statusLabel() {
    switch (producer.status) {
      case ProducerStatus.excellent:
        return 'Excelente';
      case ProducerStatus.requiresAttention:
        return 'Atención';
      case ProducerStatus.risk:
        return 'Riesgo';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final statusColor = _statusColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 168,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark
              ? AppTheme.coffeeDeep.withOpacity(0.6)
              : const Color(0xFFE8E0D5).withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : AppTheme.darkCoffee.withOpacity(0.04),
            width: 0.5,
          ),
          boxShadow: const [], // ✅ SIN SOMBRAS
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _statusLabel(),
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: statusColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              producer.name,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: textColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              producer.location,
              style: TextStyle(fontSize: 10.5, color: textColor.withOpacity(0.55)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              children: [
                Icon(Icons.eco, size: 12, color: AppTheme.primaryGreen),
                const SizedBox(width: 4),
                Text('${producer.production} kg', style: TextStyle(fontSize: 10.5, color: textColor.withOpacity(0.7))),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: producer.traceability / 100,
                minHeight: 4,
                backgroundColor: (isDark ? Colors.white : AppTheme.darkCoffee).withOpacity(0.08),
                valueColor: AlwaysStoppedAnimation(statusColor),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Trazabilidad ${producer.traceability}%',
              style: TextStyle(fontSize: 9, color: textColor.withOpacity(0.5)),
            ),
          ],
        ),
      ),
    );
  }
}