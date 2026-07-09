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
  final bool isDark;

  const ActivityFilterChips({
    super.key,
    required this.selectedType,
    required this.selectedStatus,
    required this.onTypeSelected,
    required this.onStatusSelected,
    required this.onClearFilters,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final types = ActivityType.values;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

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
                _buildChip('Todos', selectedType == null, () => onTypeSelected(null), textColor),
                const SizedBox(width: 8),
                ...types.map((type) => _buildChip(
                  type.title,
                  selectedType == type,
                      () => onTypeSelected(type),
                  textColor,
                )),
              ],
            ),
          ),
          if (selectedType != null || selectedStatus != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _buildClearChip(textColor),
            ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected, VoidCallback onTap, Color textColor) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGreen : (isDark ? AppTheme.coffeeDeep.withOpacity(0.7) : Colors.white),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : textColor.withOpacity(0.15),
          ),
          boxShadow: isDark ? const [] : [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Colors.white : textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildClearChip(Color textColor) {
    return GestureDetector(
      onTap: onClearFilters,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : AppTheme.darkCoffee.withOpacity(0.04),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.clear, size: 14, color: textColor),
            const SizedBox(width: 4),
            Text(
              'Limpiar filtros',
              style: TextStyle(fontSize: 12, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}