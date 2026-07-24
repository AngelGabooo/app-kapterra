// lib/features/auth/presentation/widgets/social_login_button.dart

import 'package:flutter/material.dart';
import 'neumorphic_box.dart';

class SocialLoginButton extends StatefulWidget {
  final String text;
  final String imageAsset;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.imageAsset,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  State<SocialLoginButton> createState() => _SocialLoginButtonState();
}

class _SocialLoginButtonState extends State<SocialLoginButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTapDown: widget.isLoading ? null : (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.isLoading ? null : widget.onPressed,
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: widget.isLoading
            ? NeumorphicBox.inset(
          borderRadius: 20,
          child: _loadingContent(theme),
        )
            : _pressed
            ? NeumorphicBox.inset(
          borderRadius: 20,
          child: _content(theme),
        )
            : NeumorphicBox(
          borderRadius: 20,
          intensity: 4,
          child: _content(theme),
        ),
      ),
    );
  }

  Widget _content(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Image.asset(
          widget.imageAsset,
          width: 22,
          height: 22,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.warning_amber_rounded,
              color: theme.colorScheme.error,
              size: 22,
            );
          },
        ),
        const SizedBox(width: 12),
        Text(
          widget.text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _loadingContent(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Cargando...',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}