import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class DigitalPassportCard extends StatelessWidget {
  final VoidCallback onViewPassport;

  const DigitalPassportCard({super.key, required this.onViewPassport});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.goldCoffee.withOpacity(0.1),
            AppTheme.primaryGreen.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.goldCoffee.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.goldCoffee.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.verified, size: 24, color: AppTheme.goldCoffee),
              ),
              const SizedBox(width: 12),
              const Text(
                'Pasaporte Digital',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkCoffee,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPassportItem(Icons.qr_code, 'Estado de trazabilidad', 'Activo'),
          const SizedBox(height: 12),
          _buildPassportItem(Icons.location_on, 'Origen verificado', 'Chiapas, México'),
          const SizedBox(height: 12),
          _buildPassportItem(Icons.history, 'Historial completo', '12 registros'),
          const SizedBox(height: 12),
          _buildPassportItem(Icons.verified_user, 'Certificaciones', 'Orgánico, Comercio Justo'),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onViewPassport,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.goldCoffee,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Ver Pasaporte Completo'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassportItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.goldCoffee),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.darkCoffee.withOpacity(0.7),
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkCoffee,
          ),
        ),
      ],
    );
  }
}