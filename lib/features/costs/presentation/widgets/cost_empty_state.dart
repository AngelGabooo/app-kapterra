// lib/features/costs/presentation/widgets/cost_empty_state.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class CostEmptyState extends StatelessWidget {
  final VoidCallback onRegister;

  const CostEmptyState({super.key, required this.onRegister});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(color: AppTheme.primaryGreen.withOpacity(0.08), shape: BoxShape.circle),
              child: Icon(Icons.attach_money_outlined, size: 64, color: AppTheme.primaryGreen.withOpacity(0.5)),
            ),
            const SizedBox(height: 24),
            Text(
              'Aún no has registrado costos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.darkCoffee),
            ),
            const SizedBox(height: 8),
            Text(
              'Registra tus gastos para conocer la rentabilidad\nreal de tu producción.',
              style: TextStyle(fontSize: 14, color: AppTheme.darkCoffee.withOpacity(0.6)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRegister,
              icon: const Icon(Icons.add),
              label: const Text('Registrar Costo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}