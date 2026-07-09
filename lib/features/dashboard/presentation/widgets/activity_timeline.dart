import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart' hide NeumorphicBox;
import 'package:kaabcafe/features/dashboard/data/models/activity_model.dart';

import '../../../auth/presentation/widgets/neumorphic_box.dart';

const Color _kCreamLightAlt = Color(0xFFF6ECDA);

class ActivityTimeline extends StatelessWidget {
  final List<ActivityModel> activities;

  const ActivityTimeline({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      separatorBuilder: (context, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final activity = activities[index];
        return Row(
          children: [
            NeumorphicBox(
              borderRadius: 14,
              color: isDark ? null : _kCreamLightAlt,
              padding: const EdgeInsets.all(8),
              child: Icon(
                activity.icon,
                size: 16,
                color: theme.colorScheme.primary.withOpacity(0.8),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    activity.description,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: textColor.withOpacity(0.45),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}