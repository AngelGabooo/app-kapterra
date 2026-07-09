// lib/features/technician/presentation/widgets/diagnosis/diagnosis_risk_indicator.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';

class DiagnosisRiskIndicator extends StatelessWidget {
  final bool isDark;
  final String label;
  final String level;
  final Color color;

  const DiagnosisRiskIndicator({
    super.key,
    required this.isDark,
    required this.label,
    required this.level,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.coffeeDeep.withOpacity(0.7)
            : const Color(0xFFE8E0D5).withOpacity(0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: textColor.withOpacity(0.06),
          width: 0.5,
        ),
        boxShadow: const [],
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            level,
            style: TextStyle(
              fontSize: 11,
              color: textColor.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}