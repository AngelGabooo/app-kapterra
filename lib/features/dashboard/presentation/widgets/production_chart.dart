import 'package:flutter/material.dart';

class ProductionChart extends StatelessWidget {
  final List<double> data;

  const ProductionChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 🟢 VALIDACIÓN DE ESTADO VACÍO: Evita errores matemáticos si no hay datos
    final bool isEmpty = data.isEmpty;
    final maxValue = !isEmpty ? data.reduce((a, b) => a > b ? a : b) : 100.0;
    final minValue = !isEmpty ? data.reduce((a, b) => a < b ? a : b) : 0.0;
    final range = maxValue - minValue;
    final height = 130.0;

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
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface.withOpacity(0.3), letterSpacing: 1.0),
                ),
                const SizedBox(height: 2),
                Text(
                  'Trazabilidad Métrica',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface, letterSpacing: -0.4),
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: theme.scaffoldBackgroundColor, borderRadius: BorderRadius.circular(8)),
              child: const Text('6M', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFFF6B00))),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(double.infinity, height),
                painter: GridLinesPainter(theme: theme),
              ),

              // Si no hay datos, renderiza una interfaz limpia en espera, si los hay dibuja la línea neón
              isEmpty
                  ? Positioned.fill(
                child: Center(
                  child: Text(
                    'Registra cosechas mensuales para generar métricas.',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface.withOpacity(0.3)
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
                  : CustomPaint(
                size: Size(double.infinity, height),
                painter: LineChartPainter(
                  data: data,
                  minValue: minValue,
                  maxValue: maxValue,
                  height: height,
                  theme: theme,
                ),
              ),

              if (!isEmpty)
                ...List.generate(data.length, (index) {
                  final x = (index / (data.length - 1)) * (MediaQuery.of(context).size.width - 98);
                  final y = height - ((data[index] - minValue) / range) * height;
                  return Positioned(
                    left: x,
                    top: y - 5,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          color: const Color(0xFFFF6B00),
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.colorScheme.surface, width: 2),
                          boxShadow: [
                            BoxShadow(color: const Color(0xFFFF6B00).withOpacity(0.4), blurRadius: 10, spreadRadius: 1)
                          ]
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return Text(
              _getMonthName(index),
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface.withOpacity(0.2)),
            );
          }),
        ),
      ],
    );
  }

  String _getMonthName(int index) {
    const months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return months[index % months.length];
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

  LineChartPainter({required this.data, required this.minValue, required this.maxValue, required this.height, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = const Color(0xFFFF6B00)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final range = maxValue - minValue;
    final path = Path();

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = height - ((data[i] - minValue) / range) * height;
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);

    final areaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xFFFF6B00).withOpacity(0.12), const Color(0xFFFF6B00).withOpacity(0.00)],
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