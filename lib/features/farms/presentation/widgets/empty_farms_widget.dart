import 'package:flutter/material.dart';
import '../../../../core/widgets/neumorphic_widgets.dart';

const Color _kCreamLight = Color(0xFFFBF3E6);

class EmptyFarmsWidget extends StatelessWidget {
  final VoidCallback onRegister;
  const EmptyFarmsWidget({super.key, required this.onRegister});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    const accent = Color(0xFFFF6B00);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NeumorphicBox(
              borderRadius: 80,
              intensity: 7,
              color: isDark ? null : _kCreamLight,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.primary.withOpacity(0.12), accent.withOpacity(0.05)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.grid_view_rounded, size: 60, color: theme.colorScheme.primary.withOpacity(0.6)),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Ninguna finca en el radar',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface, letterSpacing: -0.5),
            ),
            const SizedBox(height: 8),
            Text(
              'Comienza dando de alta tu primera unidad de producción para activar los mapas satelitales.',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.colorScheme.onSurface.withOpacity(0.45), height: 1.3),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: onRegister,
              child: NeumorphicBox(
                borderRadius: 20,
                intensity: 5,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [accent, theme.colorScheme.tertiary],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                child: const Text(
                  'Registrar mi primera finca',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}