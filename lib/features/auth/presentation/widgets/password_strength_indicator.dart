import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({super.key, required this.password});

  String _getStrengthText() {
    final score = _calculateStrength();
    if (score <= 2) return 'Débil';
    if (score <= 3) return 'Media';
    if (score <= 4) return 'Fuerte';
    return 'Muy fuerte';
  }

  Color _getStrengthColor() {
    final score = _calculateStrength();
    if (score <= 2) return Colors.red;
    if (score <= 3) return Colors.orange;
    if (score <= 4) return AppTheme.goldCoffee;
    return AppTheme.primaryGreen;
  }

  double _getStrengthProgress() {
    return _calculateStrength() / 5;
  }

  int _calculateStrength() {
    int strength = 0;
    if (password.isEmpty) return 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    return strength;
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: _getStrengthProgress(),
          backgroundColor: Colors.grey.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(_getStrengthColor()),
          minHeight: 4,
          borderRadius: BorderRadius.circular(2),
        ),
        const SizedBox(height: 4),
        Text(
          'Fortaleza: ${_getStrengthText()}',
          style: TextStyle(
            fontSize: 12,
            color: _getStrengthColor(),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}