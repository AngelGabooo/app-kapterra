// lib/features/activities/presentation/widgets/activity_compact_card.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/activities/data/models/activity_model.dart';
import 'package:kaabcafe/features/farms/data/models/lot_model.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';

class ActivityCompactCard extends StatelessWidget {
  final ActivityModel activity;
  final String lotName;
  final LotModel lot;
  final FarmDetailsModel farm;
  final VoidCallback onTap;

  const ActivityCompactCard({
    super.key,
    required this.activity,
    required this.lotName,
    required this.lot,
    required this.farm,
    required this.onTap,
  });

  void _editActivity(BuildContext context) {
    context.push(
      RouteNames.editActivity,
      extra: {
        'activity': activity,
        'lot': lot,
        'farm': farm,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPending = activity.date.isAfter(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: activity.type.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  activity.type.icon,
                  size: 22,
                  color: activity.type.color,
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
                            activity.type.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkCoffee,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isPending ? AppTheme.alertOrange.withOpacity(0.1) : AppTheme.primaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isPending ? 'Pendiente' : 'Completada',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: isPending ? AppTheme.alertOrange : AppTheme.primaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.landscape, size: 10, color: AppTheme.darkCoffee.withOpacity(0.4)),
                        const SizedBox(width: 4),
                        Text(
                          lotName,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.darkCoffee.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.calendar_today, size: 10, color: AppTheme.darkCoffee.withOpacity(0.4)),
                        const SizedBox(width: 4),
                        Text(
                          '${activity.date.day}/${activity.date.month}',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.darkCoffee.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _editActivity(context),
                icon: Icon(Icons.edit, size: 18, color: AppTheme.goldCoffee),
              ),
            ],
          ),
        ),
      ),
    );
  }
}