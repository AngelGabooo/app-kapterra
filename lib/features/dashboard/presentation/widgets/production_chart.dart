// lib/features/dashboard/presentation/widgets/production_chart.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/providers/farm_provider.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/farms/data/models/lot_model.dart';

class ProductionChart extends StatelessWidget {
  const ProductionChart({super.key, required List<double> data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final farmProvider = Provider.of<FarmProvider>(context);

    // ✅ OBTENER DATOS REALES DE LOTES
    final allLots = _getAllLots(farmProvider);
    final productionData = _getMonthlyProduction(allLots);

    // ✅ DATOS PARA EL GRÁFICO
    final bool isEmpty = productionData.isEmpty;
    final maxValue = !isEmpty ? productionData.reduce((a, b) => a > b ? a : b) : 100.0;
    final minValue = !isEmpty ? productionData.reduce((a, b) => a < b ? a : b) : 0.0;
    final range = maxValue - minValue;
    final height = 130.0;
    final totalProduction = productionData.fold(0.0, (sum, val) => sum + val);
    final totalLots = allLots.length;
    final avgProduction = totalLots > 0 ? totalProduction / totalLots : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RENDIMIENTO DE COSECHA',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Trazabilidad Métrica',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // ✅ MOSTRAR TOTAL DE LOTES
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$totalLots lotes',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGreen,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // ✅ MOSTRAR RESUMEN DE PRODUCCIÓN
        Row(
          children: [
            Text(
              'Total: ${totalProduction.toStringAsFixed(0)} kg',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'Promedio: ${avgProduction.toStringAsFixed(0)} kg/lote',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(double.infinity, height),
                painter: GridLinesPainter(theme: theme),
              ),
              if (isEmpty)
                Positioned.fill(
                  child: Center(
                    child: Text(
                      'Registra lotes para generar métricas de producción.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface.withOpacity(0.3),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                CustomPaint(
                  size: Size(double.infinity, height),
                  painter: LineChartPainter(
                    data: productionData,
                    minValue: minValue,
                    maxValue: maxValue,
                    height: height,
                    theme: theme,
                  ),
                ),
              if (!isEmpty)
                ...List.generate(productionData.length, (index) {
                  final x = (index / (productionData.length - 1)) * (MediaQuery.of(context).size.width - 98);
                  final y = height - ((productionData[index] - minValue) / (range > 0 ? range : 1)) * height;
                  return Positioned(
                    left: x,
                    top: y - 5,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.colorScheme.surface, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryGreen.withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // ✅ ETIQUETAS DE MESES
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            productionData.length > 0 ? productionData.length : 6,
                (index) {
              return Text(
                _getMonthName(index),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface.withOpacity(0.2),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// ✅ OBTENER TODOS LOS LOTES DE TODAS LAS FINCAS
  List<LotModel> _getAllLots(FarmProvider farmProvider) {
    final List<LotModel> allLots = [];
    for (final farm in farmProvider.farms) {
      allLots.addAll(farmProvider.getLotsForFarm(farm.id));
    }
    return allLots;
  }

  /// ✅ GENERAR DATOS MENSUALES DESDE LOS LOTES
  List<double> _getMonthlyProduction(List<LotModel> lots) {
    if (lots.isEmpty) return [];

    // Agrupar por mes
    final Map<int, List<LotModel>> lotsByMonth = {};
    final now = DateTime.now();

    for (final lot in lots) {
      // Usar el mes de creación del lote o el mes actual como referencia
      final month = now.month - 1; // Empezamos desde el mes pasado
      // En una implementación real, usarías la fecha de creación del lote
      // Por ahora distribuimos los lotes en los últimos 6 meses
    }

    // ✅ GENERAR DATOS DISTRIBUIDOS EN 6 MESES
    final List<double> monthlyData = List.filled(6, 0.0);

    if (lots.isNotEmpty) {
      // Distribuir la producción de los lotes en los últimos 6 meses
      for (int i = 0; i < lots.length && i < 6; i++) {
        final lot = lots[i];
        // Distribuir la producción en los meses (simulado)
        // En una implementación real, usarías la fecha de cosecha del lote
        monthlyData[i % 6] += lot.estimatedProduction / 6;
      }
    }

    return monthlyData;
  }

  String _getMonthName(int index) {
    const months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    final now = DateTime.now();
    final monthIndex = (now.month - 6 + index) % 12;
    return months[monthIndex < 0 ? monthIndex + 12 : monthIndex];
  }
}

class GridLinesPainter extends CustomPainter {
  final ThemeData theme;
  GridLinesPainter({required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = theme.colorScheme.onSurface.withOpacity(0.03)
      ..strokeWidth = 1.0;

    for (int i = 0; i <= 2; i++) {
      final y = size.height * (i / 2);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LineChartPainter extends CustomPainter {
  final List<double> data;
  final double minValue;
  final double maxValue;
  final double height;
  final ThemeData theme;

  LineChartPainter({
    required this.data,
    required this.minValue,
    required this.maxValue,
    required this.height,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = AppTheme.primaryGreen
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final range = maxValue - minValue;
    final path = Path();

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = height - ((data[i] - minValue) / (range > 0 ? range : 1)) * height;
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);

    final areaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppTheme.primaryGreen.withOpacity(0.12),
          AppTheme.primaryGreen.withOpacity(0.00),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, height))
      ..style = PaintingStyle.fill;

    final areaPath = Path.from(path);
    areaPath.lineTo(size.width, height);
    areaPath.lineTo(0, height);
    areaPath.close();
    canvas.drawPath(areaPath, areaPaint);
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) => oldDelegate.data != data;
}