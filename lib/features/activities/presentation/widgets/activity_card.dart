// lib/features/activities/presentation/widgets/activity_card.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/activities/data/models/activity_model.dart';
import 'package:kaabcafe/features/farms/data/models/lot_model.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';

class ActivityCard extends StatelessWidget {
  final ActivityModel activity;
  final String lotName;
  final LotModel lot;
  final FarmDetailsModel farm;
  final VoidCallback onTap;

  const ActivityCard({
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
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: activity.type.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
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
                        Text(
                          activity.type.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkCoffee,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.landscape, size: 12, color: AppTheme.darkCoffee.withOpacity(0.5)),
                            const SizedBox(width: 4),
                            Text(
                              lotName,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.darkCoffee.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isPending ? AppTheme.alertOrange.withOpacity(0.1) : AppTheme.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isPending ? 'Programada' : 'Completada',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isPending ? AppTheme.alertOrange : AppTheme.primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                activity.description,
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.darkCoffee.withOpacity(0.7),
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildInfoChip(Icons.person, activity.responsible),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    Icons.calendar_today,
                    '${activity.date.day}/${activity.date.month}/${activity.date.year}',
                  ),
                  if (activity.evidenceUrls.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    _buildInfoChip(Icons.image, '${activity.evidenceUrls.length}'),
                  ],
                  if (activity.cost > 0) ...[
                    const SizedBox(width: 8),
                    _buildInfoChip(Icons.attach_money, '\$${activity.cost.toStringAsFixed(0)}'),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Divider(color: Colors.grey.withOpacity(0.2), height: 1),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: onTap,
                    icon: Icon(Icons.visibility, size: 18, color: AppTheme.primaryGreen),
                    label: Text(
                      'Ver detalle',
                      style: TextStyle(color: AppTheme.primaryGreen),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                  const SizedBox(width: 4),
                  TextButton.icon(
                    onPressed: () => _editActivity(context),
                    icon: Icon(Icons.edit, size: 18, color: AppTheme.goldCoffee),
                    label: Text(
                      'Editar',
                      style: TextStyle(color: AppTheme.goldCoffee),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.darkCoffee.withOpacity(0.5)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.darkCoffee.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}