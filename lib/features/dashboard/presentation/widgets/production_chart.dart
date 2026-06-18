import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class ProductionChart extends StatelessWidget {
  final List<double> data;

  const ProductionChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final minValue = data.reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;
    final height = 140.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Producción Mensual (kg)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkCoffee,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: height,
          child: Stack(
            children: [
              // Líneas de fondo
              CustomPaint(
                size: Size(double.infinity, height),
                painter: GridLinesPainter(),
              ),
              // Línea de la gráfica
              CustomPaint(
                size: Size(double.infinity, height),
                painter: LineChartPainter(
                  data: data,
                  minValue: minValue,
                  maxValue: maxValue,
                  height: height,
                ),
              ),
              // Puntos y valores
              ...List.generate(data.length, (index) {
                final x = (index / (data.length - 1)) * MediaQuery.of(context).size.width - 40;
                final y = height - ((data[index] - minValue) / range) * height;
                return Positioned(
                  left: x,
                  top: y - 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Eje X (meses)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(data.length, (index) {
              return SizedBox(
                width: (MediaQuery.of(context).size.width - 40) / data.length,
                child: Text(
                  _getMonthName(index),
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.darkCoffee.withOpacity(0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  String _getMonthName(int index) {
    const months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return months[index % months.length];
  }
}

// Painter para las líneas de fondo
class GridLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 0.5;

    // Líneas horizontales
    for (int i = 0; i <= 4; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Painter para la línea de la gráfica
class LineChartPainter extends CustomPainter {
  final List<double> data;
  final double minValue;
  final double maxValue;
  final double height;

  LineChartPainter({
    required this.data,
    required this.minValue,
    required this.maxValue,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = AppTheme.primaryGreen
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final range = maxValue - minValue;
    final path = Path();

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = height - ((data[i] - minValue) / range) * height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Área debajo de la línea (opcional)
    final areaPaint = Paint()
      ..color = AppTheme.primaryGreen.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final areaPath = Path();
    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = height - ((data[i] - minValue) / range) * height;

      if (i == 0) {
        areaPath.moveTo(x, y);
      } else {
        areaPath.lineTo(x, y);
      }
    }
    areaPath.lineTo(size.width, height);
    areaPath.lineTo(0, height);
    areaPath.close();

    canvas.drawPath(areaPath, areaPaint);
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}