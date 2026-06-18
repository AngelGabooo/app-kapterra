import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class OnboardingItem {
  final String imageAsset;
  final String title;
  final String description;
  final IconData? icon;
  final Color? iconColor;

  OnboardingItem({
    required this.imageAsset,
    required this.title,
    required this.description,
    this.icon,
    this.iconColor,
  });
}

class OnboardingData {
  static List<OnboardingItem> getItems() {
    return [
      OnboardingItem(
        imageAsset: 'assets/img/screen.png',  // ✅ Primera imagen
        title: 'Tu finca en la palma de tu mano',
        description: 'Registra actividades, costos, cosechas y observaciones de cada lote de café desde cualquier lugar.',
        icon: Icons.agriculture,
        iconColor: AppTheme.primaryGreen,
      ),
      OnboardingItem(
        imageAsset: 'assets/img/screen1.png',  // ✅ Segunda imagen
        title: 'Decide con datos, no con suposiciones',
        description: 'Visualiza costos, producción y rentabilidad para tomar mejores decisiones en cada temporada.',
        icon: Icons.analytics,
        iconColor: AppTheme.goldCoffee,
      ),
      OnboardingItem(
        imageAsset: 'assets/img/screen2.png',  // ✅ Tercera imagen
        title: 'Demuestra el valor de tu café',
        description: 'Genera trazabilidad digital y conecta directamente con compradores especializados.',
        icon: Icons.qr_code,
        iconColor: AppTheme.primaryGreen,
      ),
    ];
  }
}