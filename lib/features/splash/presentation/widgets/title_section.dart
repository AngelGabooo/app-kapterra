import 'package:flutter/material.dart';
import 'package:kaabcafe/core/constants/app_constants.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [AppTheme.coffeeGoldLight, AppTheme.goldCoffee],
          ).createShader(bounds),
          child: const Text(
            'KAAB TERRA',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 8,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _OrnamentDot(size: 4, opacity: 0.3),
            const SizedBox(width: 6),
            _OrnamentDot(size: 5, opacity: 0.5),
            const SizedBox(width: 8),
            _OrnamentLine(),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: AppTheme.goldCoffee, shape: BoxShape.circle),
            ),
            _OrnamentLine(),
            const SizedBox(width: 8),
            _OrnamentDot(size: 5, opacity: 0.5),
            const SizedBox(width: 6),
            _OrnamentDot(size: 4, opacity: 0.3),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          AppConstants.slogan,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.55),
            fontStyle: FontStyle.italic,
            letterSpacing: 0.3,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: AppTheme.primaryGreen.withOpacity(0.2),
            border: Border.all(color: AppTheme.secondaryGreen.withOpacity(0.35), width: 0.8),
          ),
          child: const Text(
            'AGRITECH',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: AppTheme.secondaryGreen,
              letterSpacing: 2.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _OrnamentDot extends StatelessWidget {
  final double size;
  final double opacity;
  const _OrnamentDot({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: AppTheme.goldCoffee.withOpacity(opacity), shape: BoxShape.circle),
    );
  }
}

class _OrnamentLine extends StatelessWidget {
  const _OrnamentLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 0.8,
      color: AppTheme.goldCoffee.withOpacity(0.3),
    );
  }
}