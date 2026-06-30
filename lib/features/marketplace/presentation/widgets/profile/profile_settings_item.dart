import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class ProfileSettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool? value;
  final bool isDark;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onTap;

  const ProfileSettingsItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
    this.value,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.coffeeMedium.withOpacity(0.3)
                  : AppTheme.primaryGreen.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 16,
              color: isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: textColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          if (value != null && onChanged != null)
            Switch(
              value: value!,
              onChanged: onChanged,
              activeColor: AppTheme.primaryGreen,
            ),
          if (value == null && onTap != null)
            GestureDetector(
              onTap: onTap,
              child: Icon(
                Icons.chevron_right,
                size: 18,
                color: textColor.withOpacity(0.3),
              ),
            ),
        ],
      ),
    );
  }
}