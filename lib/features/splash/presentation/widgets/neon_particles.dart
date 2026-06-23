import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class GoldenParticles extends StatelessWidget {
  const GoldenParticles({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ParticlesPainter(),
      size: Size(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height,
      ),
    );
  }
}

class _ParticlesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final goldPaint = Paint()..style = PaintingStyle.fill;
    final whitePaint = Paint()..style = PaintingStyle.fill;

    final particles = [
      (x: 0.145, y: 0.105, r: 1.0,  isGold: true,  opacity: 0.35),
      (x: 0.342, y: 0.085, r: 0.8,  isGold: false, opacity: 0.22),
      (x: 0.579, y: 0.098, r: 1.0,  isGold: true,  opacity: 0.28),
      (x: 0.816, y: 0.079, r: 0.8,  isGold: false, opacity: 0.18),
      (x: 0.921, y: 0.118, r: 1.2,  isGold: true,  opacity: 0.25),
      (x: 0.074, y: 0.145, r: 0.8,  isGold: false, opacity: 0.16),
      (x: 0.447, y: 0.072, r: 0.7,  isGold: false, opacity: 0.18),
      (x: 0.724, y: 0.116, r: 1.0,  isGold: true,  opacity: 0.20),
      (x: 0.789, y: 0.138, r: 18.0, isGold: true,  opacity: 0.07),
    ];

    for (final p in particles) {
      final color = p.isGold
          ? AppTheme.goldCoffee.withOpacity(p.opacity)
          : Colors.white.withOpacity(p.opacity);

      if (p.r > 5) {
        goldPaint.color = AppTheme.goldCoffee.withOpacity(0.07);
        canvas.drawCircle(Offset(p.x * size.width, p.y * size.height), p.r, goldPaint);
        goldPaint.color = AppTheme.coffeeGoldLight.withOpacity(0.15);
        canvas.drawCircle(Offset(p.x * size.width, p.y * size.height), p.r * 0.7, goldPaint);
      } else {
        (p.isGold ? goldPaint : whitePaint).color = color;
        canvas.drawCircle(
          Offset(p.x * size.width, p.y * size.height),
          p.r,
          p.isGold ? goldPaint : whitePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}