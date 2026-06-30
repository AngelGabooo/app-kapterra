import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class ProfileDocumentItem extends StatelessWidget {
  final String emoji;
  final String label;
  final String status;
  final bool isDark;
  final VoidCallback? onTap;

  const ProfileDocumentItem({
    super.key,
    required this.emoji,
    required this.label,
    required this.status,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark
              ? AppTheme.coffeeDark.withOpacity(0.5)
              : Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 10,
                      color: textColor.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: textColor.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}