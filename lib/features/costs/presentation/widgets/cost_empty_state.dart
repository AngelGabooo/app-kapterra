import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';

class CostEmptyState extends StatelessWidget {
  final VoidCallback onRegister;
  final bool isDark;

  const CostEmptyState({
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
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(isDark ? 0.15 : 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.attach_money_outlined,
                size: 64,
                color: AppTheme.primaryGreen.withOpacity(isDark ? 0.6 : 0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Aún no has registrado costos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Registra tus gastos para conocer la rentabilidad\nreal de tu producción.',
              style: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            NeumorphicActionButton(
              label: 'Registrar Costo',
              icon: Icons.add,
              isDark: isDark,
              onPressed: onRegister,
              accentColor: AppTheme.primaryGreen,
            ),
          ],
        ),
      ),
    );
  }
}