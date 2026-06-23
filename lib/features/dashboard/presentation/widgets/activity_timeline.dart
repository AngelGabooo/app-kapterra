import 'package:flutter/material.dart';
import 'package:kaabcafe/features/dashboard/data/models/activity_model.dart';

class ActivityTimeline extends StatelessWidget {
  final List<ActivityModel> activities;
  const ActivityTimeline({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final activity = activities[index];
        return Row(
          children: [
            Icon(activity.icon, size: 16, color: theme.colorScheme.primary.withOpacity(0.6)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(activity.title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: theme.colorScheme.onSurface)),
                  const SizedBox(height: 1),
                  Text(activity.description, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: theme.colorScheme.onSurface.withOpacity(0.45))),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}