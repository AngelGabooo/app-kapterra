// lib/features/buyer/presentation/screens/reports/widgets/report_chart.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class ReportChart extends StatelessWidget {
  final bool isDark;
  final String title;
  final String period;

  const ReportChart({
    super.key,
    required this.isDark,
    required this.title,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark ? AppTheme.coffeeDeep : Colors.white;

    // Datos vacíos - barras con altura 0
    final List<double> emptyData = [0, 0, 0, 0, 0, 0, 0];
    final List<String> labels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title - $period',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(labels.length, (index) {
                final height = emptyData[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 24,
                      height: height,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: height > 0
                          ? Center(
                        child: Text(
                          height.toStringAsFixed(0),
                          style: const TextStyle(
                            fontSize: 8,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                          : null,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      labels[index],
                      style: TextStyle(
                        fontSize: 9,
                        color: textColor.withOpacity(0.3),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Sin datos para mostrar',
              style: TextStyle(
                fontSize: 11,
                color: textColor.withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}