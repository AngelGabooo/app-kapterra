// lib/features/technician/presentation/widgets/certification/certification_documents.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';

class CertificationDocuments extends StatelessWidget {
  final bool isDark;
  final List<Map<String, dynamic>> documents;
  final Function(int) onUpload;
  final Function(int) onView;
  final Function(int) onDownload;

  const CertificationDocuments({
    super.key,
    required this.isDark,
    required this.documents,
    required this.onUpload,
    required this.onView,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return NeumorphicBox(
      isDark: isDark,
      borderRadius: 20,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Documentos requeridos',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          ...documents.asMap().entries.map((entry) {
            final index = entry.key;
            final doc = entry.value;
            final isUploaded = doc['status'] == 'Subido';

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : AppTheme.darkCoffee.withOpacity(0.04),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: textColor.withOpacity(0.06),
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    doc['icon'],
                    size: 20,
                    color: isUploaded ? AppTheme.primaryGreen : AppTheme.alertOrange,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      doc['label'],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isUploaded
                          ? AppTheme.primaryGreen.withOpacity(0.12)
                          : AppTheme.alertOrange.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      doc['status'],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isUploaded ? AppTheme.primaryGreen : AppTheme.alertOrange,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.upload_file, size: 16),
                  label: const Text('Subir documento'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(
                      color: AppTheme.primaryGreen.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.visibility, size: 16),
                  label: const Text('Ver'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: textColor,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(
                      color: textColor.withOpacity(0.15),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.download, size: 16),
                  label: const Text('Descargar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.goldCoffee,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(
                      color: AppTheme.goldCoffee.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}