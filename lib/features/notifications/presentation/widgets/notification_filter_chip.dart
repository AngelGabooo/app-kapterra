import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import '../data/models/notification_model.dart';

class NotificationFilterChip extends StatelessWidget {
  final NotificationCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const NotificationFilterChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  String get _label {
    switch (category) {
      case NotificationCategory.all:
        return 'Todos';
      case NotificationCategory.critical:
        return 'Críticas';
      case NotificationCategory.aiRecommendation:
        return 'Recomendaciones IA';
      case NotificationCategory.production:
        return 'Producción';
      case NotificationCategory.costs:
        return 'Costos';
      case NotificationCategory.traceability:
        return 'Trazabilidad';
      case NotificationCategory.system:
        return 'Sistema';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Text(
          _label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Colors.white : AppTheme.darkCoffee,
          ),
        ),
      ),
    );
  }
}