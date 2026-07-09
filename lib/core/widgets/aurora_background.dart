import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class AuroraBackground extends StatelessWidget {
  const AuroraBackground({super.key, required this.isDark, this.child});

  final bool isDark;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.auroraColors(isDark);
    final base = AppTheme.neuBase(isDark);

    return Stack(
      children: [
        // Fondo base sólido
        Positioned.fill(child: Container(color: base)),

        // Blob 1 — superior izquierda
        Positioned(
          top: -80,
          left: -60,
          child: _blob(colors[0], 260),
        ),

        // Blob 2 — superior derecha
        Positioned(
          top: 40,
          right: -100,
          child: _blob(colors[1], 220),
        ),

        // Blob 3 — inferior centro
        Positioned(
          bottom: -100,
          left: 60,
          child: _blob(colors[2], 300),
        ),

        // Blob 4 — acento extra
        Positioned(
          top: 220,
          right: 40,
          child: _blob(colors[0].withOpacity(colors[0].opacity * 0.6), 160),
        ),

        // Difuminado global para fundir los blobs con el fondo
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
            child: Container(color: Colors.transparent),
          ),
        ),

        // Puntos sutiles tipo "estrellas" — solo en modo oscuro
        if (isDark)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _StarsPainter()),
            ),
          ),

        if (child != null) Positioned.fill(child: child!),
      ],
    );
  }

  Widget _blob(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withOpacity(0)],
        ),
      ),
    );
  }
}

class _StarsPainter extends CustomPainter {
  static final List<Offset> _seeds = List.generate(40, (i) {
    final x = (i * 37) % 100 / 100;
    final y = (i * 53) % 100 / 100;
    return Offset(x, y);
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.18);
    for (final seed in _seeds) {
      final radius = (seed.dx * 1.6) % 1.2 + 0.4;
      canvas.drawCircle(
        Offset(seed.dx * size.width, seed.dy * size.height),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}