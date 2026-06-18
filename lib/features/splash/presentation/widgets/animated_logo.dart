import 'package:flutter/material.dart';
import 'package:kaabcafe/core/constants/app_constants.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo desde imagen
        Image.asset(
          'assets/img/logo_kaab_terra.png',
          width: 180,
          height: 180,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback si no encuentra la imagen
            return Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryGreen.withOpacity(0.1),
                    AppTheme.goldCoffee.withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryGreen.withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.agriculture,
                size: 80,
                color: AppTheme.primaryGreen,
              ),
            );
          },
        ),
        const SizedBox(height: 32),

        // Nombre de la app con gradiente
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              AppTheme.primaryGreen,
              AppTheme.goldCoffee,
            ],
          ).createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Text(
            AppConstants.appName,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: AppTheme.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Slogan
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryGreen.withOpacity(0.1),
                AppTheme.goldCoffee.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            AppConstants.slogan,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.darkCoffee,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}