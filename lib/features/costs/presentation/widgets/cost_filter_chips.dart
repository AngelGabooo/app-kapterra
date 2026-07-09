import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';
import 'package:kaabcafe/features/costs/data/models/cost_model.dart';

class CostFilterChips extends StatelessWidget {
  final CostCategory? selectedCategory;
  final Function(CostCategory?) onCategorySelected;
  final VoidCallback onClearFilters;
  final bool isDark;

  const CostFilterChips({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onClearFilters,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final categories = CostCategory.values;
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
                _buildChip('Todos', selectedCategory == null, () => onCategorySelected(null), textColor),
                const SizedBox(width: 8),
                ...categories.map((category) => _buildChip(
                  category.title,
                  selectedCategory == category,
                      () => onCategorySelected(category),
                  textColor,
                )),
              ],
            ),
          ),
          if (selectedCategory != null)
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