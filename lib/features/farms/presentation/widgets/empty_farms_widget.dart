import 'package:flutter/material.dart';

class EmptyFarmsWidget extends StatelessWidget {
  final VoidCallback onRegister;
  const EmptyFarmsWidget({super.key, required this.onRegister});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.colorScheme.primary.withOpacity(0.12), const Color(0xFFFF6B00).withOpacity(0.04)],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.grid_view_rounded, size: 60, color: theme.colorScheme.primary.withOpacity(0.6)),
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
            ElevatedButton(
              onPressed: onRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B00),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              child: const Text('Registrar mi primera finca', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }
}