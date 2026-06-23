import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String text;
  final String imageAsset;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.imageAsset,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.15)),
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // 🟢 Compacta el contenido al centro
          children: [
            Image.asset(
              imageAsset,
              width: 22, // Tamaño ideal estándar para el logo de Google
              height: 22,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Si ves este ícono de advertencia, es la señal de que la ruta sigue mal declarada
                return Icon(
                  Icons.warning_amber_rounded,
                  color: theme.colorScheme.error,
                  size: 22,
                );
              },
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}