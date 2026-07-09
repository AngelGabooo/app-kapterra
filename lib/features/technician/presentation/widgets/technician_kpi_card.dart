import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class TechnicianKPICard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;
  final double? change;

  const TechnicianKPICard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
    this.change,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark
              ? AppTheme.coffeeDeep.withOpacity(0.7)
              : const Color(0xFFE8E0D5).withOpacity(0.9),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : AppTheme.darkCoffee.withOpacity(0.05),
            width: 0.5,
          ),
          boxShadow: const [], // ✅ SIN SOMBRAS
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.12),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                color: textColor.withOpacity(0.5),
              ),
            ),
            if (change != null) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: change! >= 0
                      ? AppTheme.primaryGreen.withOpacity(0.12)
                      : AppTheme.berryRed.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${change! >= 0 ? '+' : ''}${change!.abs().toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: change! >= 0 ? AppTheme.primaryGreen : AppTheme.berryRed,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}