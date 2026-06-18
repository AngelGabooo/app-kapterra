import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryGreen.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              'assets/img/logo_kaab_terra.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                  child: const Icon(
                    Icons.agriculture,
                    size: 50,
                    color: AppTheme.primaryGreen,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Nombre de la app
        const Text(
          'KAAB TERRA',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkCoffee,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),

        // Título
        const Text(
          'Bienvenido',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),

        // Subtítulo
        Text(
          'Inicia sesión para gestionar tu producción cafetalera.',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppTheme.darkCoffee.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}