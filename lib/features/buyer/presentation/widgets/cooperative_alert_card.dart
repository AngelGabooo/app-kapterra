import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class CooperativeAlertCard extends StatelessWidget {
  final String? title;
  final String? description;
  final String? date;
  final Color? color;
  final bool isDark;
  final bool isEmpty;

  const CooperativeAlertCard({
    super.key,
    this.title,
    this.description,
    this.date,
    this.color,
    required this.isDark,
    this.isEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    if (isEmpty || title == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.coffeeDeep : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: AppTheme.primaryGreen.withOpacity(0.3),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Sin alertas pendientes',
                style: TextStyle(
                  fontSize: 13,
                  color: textColor.withOpacity(0.4),
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
        border: Border.all(
          color: color!.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ),
                    Text(
                      date!,
                      style: TextStyle(
                        fontSize: 10,
                        color: textColor.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  description!,
                  style: TextStyle(
                    fontSize: 11,
                    color: textColor.withOpacity(0.6),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}