// lib/features/farms/presentation/qr/qr_generator.dart
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class QRGenerator extends StatelessWidget {
  final String data;
  final double size;
  final Color? foregroundColor;
  final Color? backgroundColor;

  const QRGenerator({
    super.key,
    required this.data,
    this.size = 200,
    this.foregroundColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fgColor = foregroundColor ?? (isDark ? Colors.white : AppTheme.darkCoffee);
    final bgColor = backgroundColor ?? (isDark ? AppTheme.coffeeDeep : Colors.white);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: QrImageView(
        data: data,
        version: QrVersions.auto,
        size: size,
        gapless: false,
        foregroundColor: fgColor,
        backgroundColor: bgColor,
        errorCorrectionLevel: QrErrorCorrectLevel.H,
        padding: const EdgeInsets.all(8),
      ),
    );
  }
}