import 'package:flutter/material.dart';
import 'neumorphic_box.dart';

class SocialLoginButton extends StatefulWidget {
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
  State<SocialLoginButton> createState() => _SocialLoginButtonState();
}

class _SocialLoginButtonState extends State<SocialLoginButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onPressed,
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: _pressed
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
}