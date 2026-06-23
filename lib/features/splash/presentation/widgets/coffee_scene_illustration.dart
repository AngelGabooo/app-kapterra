import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class CoffeeSceneIllustration extends StatelessWidget {
  const CoffeeSceneIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ScenePainter(),
      size: Size(MediaQuery.of(context).size.width, 260),
    );
  }
}

class _ScenePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    _drawMountain(canvas, [
      Offset(0, h * 0.66),
      Offset(w * 0.18, h * 0.47),
      Offset(w * 0.39, h * 0.54),
      Offset(0, h * 0.71),
    ], [AppTheme.primaryGreen, AppTheme.forestGreen], 0.5);

    _drawMountain(canvas, [
      Offset(w * 0.61, h * 0.68),
      Offset(w * 0.81, h * 0.46),
      Offset(w, h * 0.53),
      Offset(w, h * 0.73),
    ], [AppTheme.primaryGreen, AppTheme.forestGreen], 0.52);

    _drawMountain(canvas, [
      Offset(0, h * 0.74),
      Offset(w * 0.24, h * 0.53),
      Offset(w * 0.48, h * 0.60),
      Offset(w * 0.16, h * 0.75),
      Offset(0, h * 0.76),
    ], [AppTheme.forestGreen, AppTheme.coffeeDeep], 0.82);

    _drawMountain(canvas, [
      Offset(w * 0.52, h * 0.62),
      Offset(w * 0.76, h * 0.50),
      Offset(w, h * 0.57),
      Offset(w, h * 0.76),
      Offset(w * 0.40, h * 0.76),
    ], [AppTheme.forestGreen, AppTheme.coffeeDeep], 0.78);

    _drawMountain(canvas, [
      Offset(0, h * 0.78),
      Offset(w * 0.13, h * 0.62),
      Offset(w * 0.50, h * 0.54),
      Offset(w * 0.87, h * 0.63),
      Offset(w, h * 0.75),
      Offset(w, h * 0.82),
      Offset(0, h * 0.82),
    ], [AppTheme.forestGreen, AppTheme.coffeeDark], 1.0);

    final mistPaint = Paint()..color = AppTheme.primaryGreen.withOpacity(0.1);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.5, h * 0.71), width: w * 1.1, height: 44), mistPaint);

    final groundPath = Path()
      ..moveTo(0, h * 0.77)
      ..quadraticBezierTo(w * 0.13, h * 0.74, w * 0.29, h * 0.757)
      ..quadraticBezierTo(w * 0.44, h * 0.773, w * 0.60, h * 0.760)
      ..quadraticBezierTo(w * 0.76, h * 0.748, w, h * 0.763)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    final groundPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppTheme.coffeeDeep, AppTheme.coffeeDark],
      ).createShader(Rect.fromLTWH(0, h * 0.7, w, h * 0.3));
    canvas.drawPath(groundPath, groundPaint);

    _drawPlant(canvas, w * 0.07,  h * 0.777, 32);
    _drawPlant(canvas, w * 0.21,  h * 0.764, 38);
    _drawPlant(canvas, w * 0.37,  h * 0.771, 30);
    _drawPlant(canvas, w * 0.553, h * 0.763, 40);
    _drawPlant(canvas, w * 0.73,  h * 0.768, 34);
    _drawPlant(canvas, w * 0.89,  h * 0.773, 28);
  }

  void _drawMountain(Canvas canvas, List<Offset> points, List<Color> colors, double opacity) {
    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();

    final bounds = path.getBounds();
    final paint = Paint()
      ..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: colors).createShader(bounds)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint..color = paint.color.withOpacity(opacity));
  }

  void _drawPlant(Canvas canvas, double x, double y, double h) {
    final stemPaint = Paint()
      ..color = AppTheme.primaryGreen
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(x, y), Offset(x, y - h), stemPaint);

    final leafColors = [AppTheme.primaryGreen, AppTheme.leafGreenLight];

    for (int side = -1; side <= 1; side += 2) {
      for (int level = 0; level < 2; level++) {
        final lx = x + side * h * 0.38;
        final ly = y - h * (0.52 + level * 0.28);
        final angle = side * (0.44 + level * 0.1);

        canvas.save();
        canvas.translate(lx, ly);
        canvas.rotate(angle);

        final leafPath = Path()
          ..moveTo(0, 0)
          ..quadraticBezierTo(h * 0.28, -h * 0.12, h * 0.32, 0)
          ..quadraticBezierTo(h * 0.28, h * 0.12, 0, 0)
          ..close();

        canvas.drawPath(leafPath, Paint()..color = leafColors[level].withOpacity(0.92)..style = PaintingStyle.fill);
        canvas.restore();
      }
    }

    if (h > 30) {
      _drawBerry(canvas, x - h * 0.28, y - h * 0.48, h * 0.10, AppTheme.goldCoffee);
      _drawBerry(canvas, x + h * 0.28, y - h * 0.52, h * 0.09, AppTheme.berryRed);
      if (h > 36) {
        _drawBerry(canvas, x - h * 0.20, y - h * 0.74, h * 0.08, AppTheme.berryRed);
      }
    }
  }

  void _drawBerry(Canvas canvas, double x, double y, double r, Color color) {
    canvas.drawCircle(Offset(x, y), r, Paint()..color = color.withOpacity(0.92)..style = PaintingStyle.fill);
    canvas.drawCircle(Offset(x - r * 0.3, y - r * 0.3), r * 0.28, Paint()..color = Colors.white.withOpacity(0.3)..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}