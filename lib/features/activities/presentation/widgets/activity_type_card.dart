import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/activities/data/models/activity_model.dart';

class ActivityTypeCard extends StatelessWidget {
  final ActivityType type;
  final bool isSelected;
  final VoidCallback onTap;

  const ActivityTypeCard({
    super.key,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6), // ✅ Reducido padding
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGreen.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(14), // ✅ Reducido de 16 a 14
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : Colors.grey.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // ✅ Importante para evitar overflow
          children: [
            Container(
              width: 40, // ✅ Reducido de 48 a 40
              height: 40, // ✅ Reducido de 48 a 40
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryGreen.withOpacity(0.2) : AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12), // ✅ Reducido de 14 a 12
              ),
              child: Icon(
                type.icon,
                size: 20, // ✅ Reducido de 24 a 20
                color: isSelected ? AppTheme.primaryGreen : AppTheme.primaryGreen.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 6), // ✅ Reducido de 8 a 6
            Text(
              type.title,
              style: TextStyle(
                fontSize: 10, // ✅ Reducido de 11 a 10
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppTheme.primaryGreen : AppTheme.darkCoffee,
              ),
              textAlign: TextAlign.center,
              maxLines: 2, // ✅ Permitir 2 líneas
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}