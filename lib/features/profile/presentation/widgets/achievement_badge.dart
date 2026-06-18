import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class AchievementBadge extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isLocked;

  const AchievementBadge({
    super.key,
    required this.title,
    required this.icon,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isLocked ? Colors.grey.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLocked ? Colors.grey.withOpacity(0.2) : AppTheme.goldCoffee.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isLocked
                  ? Colors.grey.withOpacity(0.2)
                  : AppTheme.goldCoffee.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              size: 24,
              color: isLocked ? Colors.grey : AppTheme.goldCoffee,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isLocked ? Colors.grey : AppTheme.darkCoffee,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}