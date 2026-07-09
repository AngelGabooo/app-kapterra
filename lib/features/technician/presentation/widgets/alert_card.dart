import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/technician/data/models/technician_model.dart';

class TechnicianAlertCard extends StatelessWidget {
  const TechnicianAlertCard({super.key, required this.alert, required this.isDark});

  final TechnicianAlertModel alert;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final accent = alert.isCritical ? AppTheme.berryRed : AppTheme.alertOrange;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.coffeeDeep.withOpacity(0.5)
            : const Color(0xFFE8E0D5).withOpacity(0.85),
        borderRadius: BorderRadius.circular(18),
        border: Border(
          left: BorderSide(color: accent, width: 3.5),
          top: BorderSide(color: isDark ? Colors.white.withOpacity(0.06) : AppTheme.darkCoffee.withOpacity(0.04)),
          right: BorderSide(color: isDark ? Colors.white.withOpacity(0.06) : AppTheme.darkCoffee.withOpacity(0.04)),
          bottom: BorderSide(color: isDark ? Colors.white.withOpacity(0.06) : AppTheme.darkCoffee.withOpacity(0.04)),
        ),
        boxShadow: const [], // ✅ SIN SOMBRAS
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withOpacity(0.15),
            ),
            child: Icon(
              alert.isCritical ? Icons.priority_high : Icons.info_outline,
              size: 16,
              color: accent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: textColor),
                ),
                const SizedBox(height: 2),
                Text(
                  alert.description,
                  style: TextStyle(fontSize: 11.5, color: textColor.withOpacity(0.6)),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, size: 18, color: textColor.withOpacity(0.3)),
        ],
      ),
    );
  }
}