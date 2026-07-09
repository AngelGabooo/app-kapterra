// lib/features/technician/presentation/widgets/certification/certification_preview.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';

class CertificationPreview extends StatelessWidget {
  final bool isDark;
  final String lotName;
  final String producerName;
  final String certificationType;

  const CertificationPreview({
    super.key,
    required this.isDark,
    required this.lotName,
    required this.producerName,
    required this.certificationType,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return NeumorphicBox(
      isDark: isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.goldCoffee.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.verified_outlined,
                  size: 18,
                  color: AppTheme.goldCoffee,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Vista previa del certificado',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.goldCoffee.withOpacity(0.08),
                  AppTheme.primaryGreen.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppTheme.goldCoffee.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.verified,
                  size: 32,
                  color: AppTheme.goldCoffee,
                ),
                const SizedBox(height: 8),
                Text(
                  '🏅 Certificado de Lote',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Divider(color: textColor.withOpacity(0.1)),
                const SizedBox(height: 8),
                _buildPreviewRow('Nombre del lote', lotName, textColor),
                const SizedBox(height: 6),
                _buildPreviewRow('Productor', producerName, textColor),
                const SizedBox(height: 6),
                _buildPreviewRow('Tipo de certificación', certificationType, textColor),
                const SizedBox(height: 6),
                _buildPreviewRow('Fecha de emisión', '15 junio 2026', textColor),
                const SizedBox(height: 6),
                _buildPreviewRow('Vigencia', '15 junio 2027', textColor),
                const SizedBox(height: 8),
                Divider(color: textColor.withOpacity(0.1)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code,
                      size: 20,
                      color: textColor.withOpacity(0.3),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'KAAB-2026-001',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textColor.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewRow(String label, String value, Color textColor) {
    return Row(
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 12,
            color: textColor.withOpacity(0.5),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    );
  }
}