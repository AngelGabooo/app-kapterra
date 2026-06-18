// lib/features/activities/presentation/widgets/activity_filter_chips.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/activities/data/models/activity_model.dart';

class ActivityFilterChips extends StatelessWidget {
  final ActivityType? selectedType;
  final ActivityStatus? selectedStatus;
  final Function(ActivityType?) onTypeSelected;
  final Function(ActivityStatus?) onStatusSelected;
  final VoidCallback onClearFilters;

  const ActivityFilterChips({
    super.key,
    required this.selectedType,
    required this.selectedStatus,
    required this.onTypeSelected,
    required this.onStatusSelected,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final types = ActivityType.values;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildChip('Todos', selectedType == null, () => onTypeSelected(null)),
                const SizedBox(width: 8),
                ...types.map((type) => _buildChip(
                  type.title,
                  selectedType == type,
                      () => onTypeSelected(type),
                )),
              ],
            ),
          ),
          if (selectedType != null || selectedStatus != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _buildClearChip(),
            ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Colors.white : AppTheme.darkCoffee,
          ),
        ),
      ),
    );
  }

  Widget _buildClearChip() {
    return GestureDetector(
      onTap: onClearFilters,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.clear, size: 14, color: AppTheme.darkCoffee),
            const SizedBox(width: 4),
            Text(
              'Limpiar filtros',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.darkCoffee,
              ),
            ),
          ],
        ),
      ),
    );
  }
}