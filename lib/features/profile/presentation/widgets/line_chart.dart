import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class ChartData {
  final String month;
  final double value;

  ChartData({required this.month, required this.value});
}

class LineChartWidget extends StatelessWidget {
  final List<ChartData> data;

  const LineChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    final maxValue = data.map((d) => d.value).reduce((a, b) => a > b ? a : b);
    final minValue = data.map((d) => d.value).reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;
    final chartHeight = 160.0;

    return Column(
      children: [
        SizedBox(
          height: chartHeight,
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final chartWidth = constraints.maxWidth;
              return Stack(
                children: [
                  // Líneas de cuadrícula horizontales
                  ...List.generate(4, (index) {
                    final y = chartHeight * (index / 4);
                    return Positioned(
                      left: 0,
                      right: 0,
                      top: y,
                      child: Container(
                        height: 1,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    );
                  }),

                  // Área debajo de la línea
                  CustomPaint(
                    size: Size(chartWidth, chartHeight),
                    painter: AreaPainter(
                      data: data,
                      minValue: minValue,
                      maxValue: maxValue,
                      height: chartHeight,
                      width: chartWidth,
                    ),
                  ),

                  // Línea principal
                  CustomPaint(
                    size: Size(chartWidth, chartHeight),
                    painter: LinePainter(
                      data: data,
                      minValue: minValue,
                      maxValue: maxValue,
                      height: chartHeight,
                      width: chartWidth,
                    ),
                  ),

                  // Puntos de datos
                  ...List.generate(data.length, (index) {
                    final x = (index / (data.length - 1)) * chartWidth;
                    final y = chartHeight - ((data[index].value - minValue) / range) * chartHeight;
                    return Positioned(
                      left: x - 8,
                      top: y - 8,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.primaryGreen,
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryGreen.withOpacity(0.3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  // Etiquetas de valores
                  ...List.generate(data.length, (index) {
                    final x = (index / (data.length - 1)) * chartWidth;
                    final y = chartHeight - ((data[index].value - minValue) / range) * chartHeight;
                    // Solo mostrar etiquetas si hay suficiente espacio
                    if (x >= 20 && x <= chartWidth - 20) {
                      return Positioned(
                        left: x - 20,
                        top: y - 28,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${data[index].value.toInt()}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Etiquetas de meses - CORREGIDO para evitar overflow
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: List.generate(data.length, (index) {
              return SizedBox(
                width: MediaQuery.of(context).size.width / data.length,
                child: Text(
                  data[index].month,
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
}

// Painter para la línea
class LinePainter extends CustomPainter {
  final List<ChartData> data;
  final double minValue;
  final double maxValue;
  final double height;
  final double width;

  LinePainter({
    required this.data,
    required this.minValue,
    required this.maxValue,
    required this.height,
    required this.width,
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
      final x = (i / (data.length - 1)) * width;
      final y = height - ((data[i].value - minValue) / range) * height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant LinePainter oldDelegate) {
    return oldDelegate.data != data;
  }
}

// Painter para el área debajo de la línea
class AreaPainter extends CustomPainter {
  final List<ChartData> data;
  final double minValue;
  final double maxValue;
  final double height;
  final double width;

  AreaPainter({
    required this.data,
    required this.minValue,
    required this.maxValue,
    required this.height,
    required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = AppTheme.primaryGreen.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    final range = maxValue - minValue;
    final path = Path();

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * width;
      final y = height - ((data[i].value - minValue) / range) * height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant AreaPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}