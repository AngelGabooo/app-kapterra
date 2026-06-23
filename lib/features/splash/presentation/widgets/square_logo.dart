import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class SquareLogo extends StatelessWidget {
  const SquareLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148,
      height: 148,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.coffeeWarm, AppTheme.goldCoffee, AppTheme.coffeeWarm],
          stops: [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.goldCoffee.withOpacity(0.22),
            blurRadius: 36,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppTheme.coffeeWarm.withOpacity(0.35),
            blurRadius: 24,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.97),
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(18),
        child: Image.asset(
          'assets/img/logo_kaab_terra.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const _FallbackIcon(),
        ),
      ),
    );
  }
}

class _FallbackIcon extends StatelessWidget {
  const _FallbackIcon();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 56,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppTheme.coffeeWarm, AppTheme.goldCoffee],
            ),
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        Container(
          width: 2,
          height: 66,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.55),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        Positioned(
          top: 10,
          left: 5,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
            ),
          ),
        ),
        Positioned(
          top: 6,
          right: 4,
          child: Transform.rotate(
            angle: 0.6,
            child: Container(
              width: 18,
              height: 26,
              decoration: BoxDecoration(
                color: AppTheme.goldCoffee.withOpacity(0.9),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(2),
                  bottomLeft: Radius.circular(2),
                  bottomRight: Radius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}