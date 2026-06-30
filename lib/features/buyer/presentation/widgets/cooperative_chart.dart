import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class CooperativeChart extends StatelessWidget {
  final List<double> productionData;
  final List<double> acopioData;
  final List<double> salesData;
  final bool isDark;

  const CooperativeChart({
    super.key,
    required this.productionData,
    required this.acopioData,
    required this.salesData,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    // ✅ Verificar si hay datos
    final hasData = productionData.any((v) => v > 0) ||
        acopioData.any((v) => v > 0) ||
        salesData.any((v) => v > 0);

    // ✅ Si no hay datos, mostrar mensaje
    if (!hasData || productionData.isEmpty) {
      return Container(
        height: 220,
        decoration: BoxDecoration(
          color: isDark ? AppTheme.coffeeDeep : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.show_chart_outlined,
                size: 40,
                color: textColor.withOpacity(0.2),
              ),
              const SizedBox(height: 12),
              Text(
                'Sin datos de producción',
                style: TextStyle(
                  fontSize: 14,
                  color: textColor.withOpacity(0.4),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Los datos se mostrarán aquí cuando los productores registren información',
                style: TextStyle(
                  fontSize: 11,
                  color: textColor.withOpacity(0.3),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // ✅ Calcular valores máximos y mínimos con seguridad
    final allValues = [...productionData, ...acopioData, ...salesData];
    final maxValue = allValues.reduce((a, b) => a > b ? a : b);
    final minValue = allValues.reduce((a, b) => a < b ? a : b);

    // ✅ Si todos los valores son iguales, usar un rango artificial
    final range = maxValue - minValue;
    final effectiveRange = range == 0 ? 1.0 : range;

    // Colores para modo oscuro
    final prodColor = isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen;
    final acopioColor = isDark ? AppTheme.coffeeWarm : AppTheme.goldCoffee;
    final salesColor = isDark ? AppTheme.leafGreenLight : AppTheme.secondaryGreen;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título con ícono
        Row(
          children: [
            Icon(Icons.timeline, size: 20, color: isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen),
            const SizedBox(width: 8),
            Text(
              'Evolución mensual',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const Spacer(),
            Text(
              '2024',
              style: TextStyle(
                fontSize: 12,
                color: textColor.withOpacity(0.4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Gráfica de líneas con puntos
        SizedBox(
          height: 200,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final chartWidth = constraints.maxWidth - 70;
              final chartHeight = 200.0;

              return Stack(
                children: [
                  // Líneas de cuadrícula horizontales
                  ...List.generate(4, (index) {
                    final y = 200 - (index / 4) * 180;
                    final value = minValue + (effectiveRange * (index / 4));
                    return Positioned(
                      left: 0,
                      right: 0,
                      top: y,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 35,
                            child: Text(
                              '${(value / 1000).toStringAsFixed(1)}k',
                              style: TextStyle(
                                fontSize: 9,
                                color: textColor.withOpacity(0.3),
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: 0.5,
                              color: textColor.withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  // Área sombreada (Producción)
                  CustomPaint(
                    size: Size(chartWidth, chartHeight),
                    painter: AreaPainter(
                      data: productionData,
                      minValue: minValue,
                      maxValue: maxValue,
                      height: chartHeight,
                      width: chartWidth,
                      color: prodColor.withOpacity(0.15),
                    ),
                  ),

                  // Línea de Producción
                  CustomPaint(
                    size: Size(chartWidth, chartHeight),
                    painter: LinePainter(
                      data: productionData,
                      minValue: minValue,
                      maxValue: maxValue,
                      height: chartHeight,
                      width: chartWidth,
                      color: prodColor,
                      strokeWidth: 2.5,
                    ),
                  ),

                  // Línea de Acopio
                  CustomPaint(
                    size: Size(chartWidth, chartHeight),
                    painter: LinePainter(
                      data: acopioData,
                      minValue: minValue,
                      maxValue: maxValue,
                      height: chartHeight,
                      width: chartWidth,
                      color: acopioColor,
                      strokeWidth: 2.5,
                    ),
                  ),

                  // Línea de Ventas
                  CustomPaint(
                    size: Size(chartWidth, chartHeight),
                    painter: LinePainter(
                      data: salesData,
                      minValue: minValue,
                      maxValue: maxValue,
                      height: chartHeight,
                      width: chartWidth,
                      color: salesColor,
                      strokeWidth: 2.5,
                    ),
                  ),

                  // Puntos de Producción
                  ...List.generate(productionData.length, (index) {
                    final x = 35 + (index / (productionData.length - 1)) * chartWidth;
                    final y = chartHeight - ((productionData[index] - minValue) / effectiveRange) * (chartHeight - 20);
                    return Positioned(
                      left: x - 6,
                      top: y - 6,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: prodColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? AppTheme.coffeeDark : Colors.white,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: prodColor.withOpacity(0.4),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  // Puntos de Acopio
                  ...List.generate(acopioData.length, (index) {
                    final x = 35 + (index / (acopioData.length - 1)) * chartWidth;
                    final y = chartHeight - ((acopioData[index] - minValue) / effectiveRange) * (chartHeight - 20);
                    return Positioned(
                      left: x - 6,
                      top: y - 6,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: acopioColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? AppTheme.coffeeDark : Colors.white,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: acopioColor.withOpacity(0.4),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  // Puntos de Ventas
                  ...List.generate(salesData.length, (index) {
                    final x = 35 + (index / (salesData.length - 1)) * chartWidth;
                    final y = chartHeight - ((salesData[index] - minValue) / effectiveRange) * (chartHeight - 20);
                    return Positioned(
                      left: x - 6,
                      top: y - 6,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: salesColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? AppTheme.coffeeDark : Colors.white,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: salesColor.withOpacity(0.4),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  // Eje X (Meses)
                  Positioned(
                    bottom: 0,
                    left: 35,
                    right: 0,
                    child: Row(
                      children: List.generate(6, (index) {
                        return Expanded(
                          child: Text(
                            _getMonthName(index),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: textColor.withOpacity(0.4),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        const SizedBox(height: 20),

        // Leyenda moderna
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(prodColor, 'Producción', isDark),
            const SizedBox(width: 20),
            _buildLegendItem(acopioColor, 'Acopio', isDark),
            const SizedBox(width: 20),
            _buildLegendItem(salesColor, 'Ventas', isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label, bool isDark) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    return Row(
      children: [
        Container(
          width: 16,
          height: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: textColor.withOpacity(0.6),
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

// Painter para la línea
class LinePainter extends CustomPainter {
  final List<double> data;
  final double minValue;
  final double maxValue;
  final double height;
  final double width;
  final Color color;
  final double strokeWidth;

  LinePainter({
    required this.data,
    required this.minValue,
    required this.maxValue,
    required this.height,
    required this.width,
    required this.color,
    this.strokeWidth = 2.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final range = maxValue - minValue;
    final effectiveRange = range == 0 ? 1.0 : range;
    final path = Path();

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * width;
      final y = height - ((data[i] - minValue) / effectiveRange) * (height - 20);

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

// Painter para el área sombreada
class AreaPainter extends CustomPainter {
  final List<double> data;
  final double minValue;
  final double maxValue;
  final double height;
  final double width;
  final Color color;

  AreaPainter({
    required this.data,
    required this.minValue,
    required this.maxValue,
    required this.height,
    required this.width,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final range = maxValue - minValue;
    final effectiveRange = range == 0 ? 1.0 : range;
    final path = Path();

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * width;
      final y = height - ((data[i] - minValue) / effectiveRange) * (height - 20);

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