// lib/features/activities/presentation/widgets/activity_empty_state.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class ActivityEmptyState extends StatelessWidget {
  final VoidCallback onRegister;

  const ActivityEmptyState({super.key, required this.onRegister});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ilustración moderna
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.assignment_outlined,
                size: 72,
                color: AppTheme.primaryGreen.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),

            // Mensaje principal
            Text(
              'Aún no has registrado actividades',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkCoffee,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Subtexto
            Text(
              'Comienza documentando las labores realizadas\nen tus lotes para construir la trazabilidad.',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.darkCoffee.withOpacity(0.6),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Botón de acción
            Container(
              width: 220,
              child: ElevatedButton.icon(
                onPressed: onRegister,
                icon: const Icon(Icons.add, size: 20),
                label: const Text(
                  'Registrar Actividad',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 2,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Texto adicional
            Text(
              'o comienza explorando la documentación',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.darkCoffee.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}