// lib/features/technician/presentation/widgets/certification/certification_signature.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';

class CertificationSignature extends StatelessWidget {
  final bool isDark;
  final VoidCallback onSignTechnician;
  final VoidCallback onSignProducer;
  final bool technicianSigned;
  final bool producerSigned;
  final String technicianDate;
  final String producerDate;

  const CertificationSignature({
    super.key,
    required this.isDark,
    required this.onSignTechnician,
    required this.onSignProducer,
    this.technicianSigned = false,
    this.producerSigned = false,
    this.technicianDate = '',
    this.producerDate = '',
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
                  color: AppTheme.primaryGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.edit_document,
                  size: 18,
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Firma digital *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(requerido)',
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.berryRed.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onSignTechnician,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: technicianSigned
                          ? AppTheme.primaryGreen.withOpacity(0.1)
                          : isDark
                          ? Colors.white.withOpacity(0.05)
                          : AppTheme.darkCoffee.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: technicianSigned
                            ? AppTheme.primaryGreen
                            : textColor.withOpacity(0.1),
                        width: technicianSigned ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          technicianSigned ? Icons.check_circle : Icons.edit_outlined,
                          size: 28,
                          color: technicianSigned ? AppTheme.primaryGreen : textColor.withOpacity(0.4),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          technicianSigned ? '✅ Firmado' : 'Firma del técnico',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: technicianSigned ? FontWeight.w600 : FontWeight.w400,
                            color: technicianSigned ? AppTheme.primaryGreen : textColor.withOpacity(0.6),
                          ),
                        ),
                        if (technicianSigned && technicianDate.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            '📅 $technicianDate',
                            style: TextStyle(
                              fontSize: 9,
                              color: textColor.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: onSignProducer,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: producerSigned
                          ? AppTheme.primaryGreen.withOpacity(0.1)
                          : isDark
                          ? Colors.white.withOpacity(0.05)
                          : AppTheme.darkCoffee.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: producerSigned
                            ? AppTheme.primaryGreen
                            : textColor.withOpacity(0.1),
                        width: producerSigned ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          producerSigned ? Icons.check_circle : Icons.edit_outlined,
                          size: 28,
                          color: producerSigned ? AppTheme.primaryGreen : textColor.withOpacity(0.4),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          producerSigned ? '✅ Firmado' : 'Firma del productor',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: producerSigned ? FontWeight.w600 : FontWeight.w400,
                            color: producerSigned ? AppTheme.primaryGreen : textColor.withOpacity(0.6),
                          ),
                        ),
                        if (producerSigned && producerDate.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            '📅 $producerDate',
                            style: TextStyle(
                              fontSize: 9,
                              color: textColor.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (technicianSigned && producerSigned) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppTheme.primaryGreen.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.verified,
                    size: 16,
                    color: AppTheme.primaryGreen,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Ambas firmas completadas ✅',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}