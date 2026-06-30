import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class ProfilePreferenceChip extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isDark;
  final VoidCallback? onTap;

  const ProfilePreferenceChip({
    super.key,
    required this.emoji,
    required this.label,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isDark
              ? AppTheme.coffeeDeep.withOpacity(0.5)
              : Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? AppTheme.coffeeGoldLight.withOpacity(0.2)
                : AppTheme.goldCoffee.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}