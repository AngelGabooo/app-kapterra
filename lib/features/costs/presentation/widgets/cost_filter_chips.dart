// lib/features/costs/presentation/widgets/cost_filter_chips.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/costs/data/models/cost_model.dart';

class CostFilterChips extends StatelessWidget {
  final CostCategory? selectedCategory;
  final Function(CostCategory?) onCategorySelected;
  final VoidCallback onClearFilters;

  const CostFilterChips({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final categories = CostCategory.values;

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
                _buildChip('Todos', selectedCategory == null, () => onCategorySelected(null)),
                const SizedBox(width: 8),
                ...categories.map((category) => _buildChip(
                  category.title,
                  selectedCategory == category,
                      () => onCategorySelected(category),
                )),
              ],
            ),
          ),
          if (selectedCategory != null)
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
          border: Border.all(color: isSelected ? AppTheme.primaryGreen : Colors.grey.withOpacity(0.3)),
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
        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(24)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.clear, size: 14, color: AppTheme.darkCoffee),
            const SizedBox(width: 4),
            Text('Limpiar filtros', style: TextStyle(fontSize: 12, color: AppTheme.darkCoffee)),
          ],
        ),
      ),
    );
  }
}