// lib/features/technician/presentation/widgets/lot_inspection/crop_evaluation_list.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';

class CropEvaluationList extends StatelessWidget {
  final bool isDark;
  final List<Map<String, dynamic>> items;
  final Function(int, int) onChanged;

  const CropEvaluationList({
    super.key,
    required this.isDark,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final options = ['Excelente', 'Bueno', 'Regular', 'Deficiente'];

    return NeumorphicBox(
      isDark: isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(14),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    item['label'],
                    style: TextStyle(
                      fontSize: 13,
                      color: textColor,
                    ),
                  ),
                ),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: item['value'],
                    isExpanded: true,
                    dropdownColor: isDark ? AppTheme.coffeeDeep : Colors.white,
                    style: TextStyle(color: textColor, fontSize: 12),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: textColor.withOpacity(0.1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: textColor.withOpacity(0.1)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      isDense: true,
                    ),
                    items: options.asMap().entries.map((e) {
                      return DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value),
                      );
                    }).toList(),
                    onChanged: (value) => onChanged(index, value ?? 1),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}