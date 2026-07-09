// lib/features/technician/presentation/widgets/certification/certification_checklist.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';

class CertificationChecklist extends StatelessWidget {
  final bool isDark;
  final List<Map<String, dynamic>> items;
  final Function(int) onToggle;

  const CertificationChecklist({
    super.key,
    required this.isDark,
    required this.items,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final total = items.length;
    final completed = items.where((item) => item['checked'] == true).length;
    final progress = total > 0 ? completed / total : 0.0;

    return NeumorphicBox(
      isDark: isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Checklist de requisitos',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: GestureDetector(
                onTap: () => onToggle(index),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: item['checked']
                            ? AppTheme.primaryGreen
                            : Colors.transparent,
                        border: Border.all(
                          color: item['checked']
                              ? AppTheme.primaryGreen
                              : textColor.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: item['checked']
                          ? const Icon(Icons.check, size: 12, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item['label'],
                        style: TextStyle(
                          fontSize: 13,
                          color: item['checked']
                              ? textColor.withOpacity(0.7)
                              : textColor,
                          decoration: item['checked']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: textColor.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress, // ✅ Ahora es double
              minHeight: 4,
              backgroundColor: textColor.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(AppTheme.primaryGreen),
            ),
          ),
        ],
      ),
    );
  }
}