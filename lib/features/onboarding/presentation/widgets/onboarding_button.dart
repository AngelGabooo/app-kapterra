import 'package:flutter/material.dart';

class OnboardingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isLastPage;

  const OnboardingButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isLastPage = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!isPrimary) {
      return TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      );
    }

    // Definición de colores dinámicos para los degradados
    final List<Color> gradientColors;
    if (theme.brightness == Brightness.dark) {
      gradientColors = isLastPage
          ? [theme.colorScheme.tertiary, theme.colorScheme.secondary]
          : [theme.colorScheme.secondary, theme.colorScheme.primary];
    } else {
      gradientColors = isLastPage
          ? [theme.colorScheme.tertiary, theme.colorScheme.primary]
          : [theme.colorScheme.primary, theme.colorScheme.secondary];
    }

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}