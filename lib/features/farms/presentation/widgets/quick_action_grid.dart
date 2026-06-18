import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class QuickActionGrid extends StatelessWidget {
  final List<Map<String, dynamic>> actions;
  final Function(String) onActionTap;

  const QuickActionGrid({
    super.key,
    required this.actions,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return GestureDetector(
          onTap: () => onActionTap(action['title']),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(action['icon'], size: 28, color: AppTheme.primaryGreen),
              ),
              const SizedBox(height: 8),
              Text(
                action['title'],
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.darkCoffee.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}