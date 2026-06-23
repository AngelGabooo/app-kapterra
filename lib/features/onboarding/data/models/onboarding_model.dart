import 'package:flutter/material.dart';

class OnboardingItem {
  final String imageAsset;
  final String title;
  final String description;
  final IconData? icon;

  OnboardingItem({
    required this.imageAsset,
    required this.title,
    required this.description,
    this.icon,
  });
}

class OnboardingData {
  static List<OnboardingItem> getItems() {
    return [
      OnboardingItem(
        imageAsset: 'assets/img/screen.png',
        title: 'Tu finca en la palma de tu mano',
        description: 'Registra actividades, costos, cosechas y observaciones de cada lote de café desde cualquier lugar.',
        icon: Icons.agriculture,
      ),
      OnboardingItem(
        imageAsset: 'assets/img/screen1.png',
        title: 'Decide con datos, no con suposiciones',
        description: 'Visualiza costos, producción y rentabilidad para tomar mejores decisiones en cada temporada.',
        icon: Icons.analytics,
      ),
      OnboardingItem(
        imageAsset: 'assets/img/screen2.png',
        title: 'Demuestra el valor de tu café',
        description: 'Genera trazabilidad digital y conecta directamente con compradores especializados.',
        icon: Icons.qr_code,
      ),
    ];
  }
}