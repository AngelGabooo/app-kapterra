// lib/features/buyer/presentation/screens/reports/widgets/report_filter.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class ReportFilter extends StatelessWidget {
  final String selectedPeriod;
  final List<String> periods;
  final String selectedReportType;
  final List<String> reportTypes;
  final Function(String) onPeriodChanged;
  final Function(String) onReportTypeChanged;
  final bool isDark;

  const ReportFilter({
    super.key,
    required this.selectedPeriod,
    required this.periods,
    required this.selectedReportType,
    required this.reportTypes,
    required this.onPeriodChanged,
    required this.onReportTypeChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark ? AppTheme.coffeeDeep : Colors.white;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          // Filtro de periodo
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: AppTheme.primaryGreen),
              const SizedBox(width: 8),
              Text(
                'Periodo:',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedPeriod,
                    isExpanded: true,
                    icon: Icon(Icons.expand_more, color: AppTheme.primaryGreen),
                    style: TextStyle(color: textColor, fontSize: 13),
                    dropdownColor: isDark ? AppTheme.coffeeDeep : Colors.white,
                    items: periods.map((period) {
                      return DropdownMenuItem(
                        value: period,
                        child: Text(period),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) onPeriodChanged(value);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Filtro de tipo de reporte
          Row(
            children: [
              Icon(Icons.analytics, size: 16, color: AppTheme.goldCoffee),
              const SizedBox(width: 8),
              Text(
                'Tipo:',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedReportType,
                    isExpanded: true,
                    icon: Icon(Icons.expand_more, color: AppTheme.goldCoffee),
                    style: TextStyle(color: textColor, fontSize: 13),
                    dropdownColor: isDark ? AppTheme.coffeeDeep : Colors.white,
                    items: reportTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) onReportTypeChanged(value);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}