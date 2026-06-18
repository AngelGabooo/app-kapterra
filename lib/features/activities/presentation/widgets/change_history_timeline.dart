// lib/features/activities/presentation/widgets/change_history_timeline.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class ChangeHistoryTimeline extends StatelessWidget {
  final List<Map<String, dynamic>> history;

  const ChangeHistoryTimeline({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Historial de modificaciones', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkCoffee)),
          const SizedBox(height: 16),
          ...history.asMap().entries.map((entry) => _buildTimelineItem(entry.value, entry.key == history.length - 1)),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(Map<String, dynamic> item, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item['icon'], size: 16, color: AppTheme.primaryGreen),
            ),
            if (!isLast) Container(width: 2, height: 30, color: Colors.grey.withOpacity(0.2)),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['action'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.darkCoffee)),
                const SizedBox(height: 2),
                Text('${item['date']} • ${item['user']}', style: TextStyle(fontSize: 11, color: AppTheme.darkCoffee.withOpacity(0.5))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}