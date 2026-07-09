// lib/features/activities/presentation/widgets/activity_empty_state.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';

class ActivityEmptyState extends StatelessWidget {
  final VoidCallback onRegister;
  final bool isDark;

  const ActivityEmptyState({
    super.key,
    required this.onRegister,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(isDark ? 0.15 : 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.assignment_outlined,
                size: 72,
                color: AppTheme.primaryGreen.withOpacity(isDark ? 0.6 : 0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Aún no has registrado actividades',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Comienza documentando las labores realizadas\nen tus lotes para construir la trazabilidad.',
              style: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.6),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            NeumorphicActionButton(
              label: 'Registrar Actividad',
              icon: Icons.add,
              isDark: isDark,
              onPressed: onRegister,
              accentColor: AppTheme.primaryGreen,
            ),
            const SizedBox(height: 16),
            Text(
              'o comienza explorando la documentación',
              style: TextStyle(
                fontSize: 12,
                color: textColor.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}