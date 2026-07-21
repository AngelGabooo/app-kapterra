// lib/features/auth/presentation/widgets/login_button.dart
import 'package:flutter/material.dart';

class LoginButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled; // ✅ Nombre principal
  final bool isEnabled; // ✅ Compatibilidad con código antiguo

  const LoginButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.isEnabled = true, // ✅ Default para compatibilidad
  });

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  bool _pressed = false;

  // ✅ Usar enabled o isEnabled (el que esté disponible)
  bool get _active {
    // Si enabled fue pasado explícitamente, usarlo
    // Si no, usar isEnabled
    return (widget.enabled && widget.isEnabled) && !widget.isLoading;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onColor = isDark ? Colors.black : Colors.white;

    final gradientColors = _active
        ? [theme.colorScheme.primary, theme.colorScheme.tertiary]
        : [
      theme.colorScheme.primary.withOpacity(0.35),
      theme.colorScheme.tertiary.withOpacity(0.35),
    ];

    final darkShadow = isDark
        ? Colors.black.withOpacity(0.55)
        : theme.colorScheme.primary.withOpacity(0.30);
    final lightShadow = isDark
        ? Colors.white.withOpacity(0.05)
        : Colors.white.withOpacity(0.7);

    return GestureDetector(
      onTapDown: _active ? (_) => setState(() => _pressed = true) : null,
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: _active ? widget.onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        width: double.infinity,
        height: 56,
        transform: Matrix4.identity()..scale(_pressed ? 0.98 : 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          boxShadow: _pressed || !_active
              ? []
              : [
            BoxShadow(
              color: darkShadow,
              offset: const Offset(0, 8),
              blurRadius: 20,
            ),
            BoxShadow(
              color: lightShadow,
              offset: const Offset(-4, -4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Center(
          child: widget.isLoading
              ? SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(onColor),
            ),
          )
              : Text(
            widget.text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: onColor,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}