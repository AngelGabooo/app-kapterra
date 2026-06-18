// lib/features/costs/presentation/widgets/cost_category_chart.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/costs/data/models/cost_model.dart';

class CostCategoryChart extends StatelessWidget {
  final Map<CostCategory, double> distribution;

  const CostCategoryChart({super.key, required this.distribution});

  @override
  Widget build(BuildContext context) {
    final entries = distribution.entries.toList();
    if (entries.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Distribución de gastos', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.darkCoffee)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildPieChart(entries),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildLegend(entries),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart(List<MapEntry<CostCategory, double>> entries) {
    return SizedBox(
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 90,
            width: 90,
            child: CustomPaint(
              painter: _PieChartPainter(entries),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.attach_money, size: 20, color: AppTheme.primaryGreen),
              const SizedBox(height: 2),
              Text(
                '${entries.fold(0.0, (sum, e) => sum + e.value).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.darkCoffee),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(List<MapEntry<CostCategory, double>> entries) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: entries.take(4).map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              Container(width: 10, height: 10, decoration: BoxDecoration(color: entry.key.color, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  entry.key.title,
                  style: TextStyle(fontSize: 10, color: AppTheme.darkCoffee.withOpacity(0.7)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text('${entry.value.toStringAsFixed(0)}%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppTheme.darkCoffee)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<MapEntry<CostCategory, double>> entries;

  _PieChartPainter(this.entries);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    double startAngle = -90 * (3.14159 / 180);
    final total = entries.fold(0.0, (sum, e) => sum + e.value);

    for (var entry in entries) {
      final sweepAngle = (entry.value / total) * 360 * (3.14159 / 180);
      final paint = Paint()
        ..color = entry.key.color
        ..style = PaintingStyle.fill;
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}