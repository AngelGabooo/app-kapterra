// lib/features/farms/presentation/qr/qr_card.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'qr_generator.dart';
import 'qr_service.dart';

class QRCard extends StatefulWidget {
  final String lotId;
  final String lotName;
  final String farmName;
  final String variety;
  final double area;
  final String status;
  final int treesCount;
  final double estimatedProduction;
  final String? location;
  final String? healthScore;
  final String? diagnosisDate;
  final String? technicianName;
  final String? certificationType;
  final String? certificationDate;
  final String? certificationExpiry;
  final String? diagnosisSummary;
  final String? recommendations;
  final String? riskLevel;
  final String? certCode;

  const QRCard({
    super.key,
    required this.lotId,
    required this.lotName,
    required this.farmName,
    required this.variety,
    required this.area,
    required this.status,
    required this.treesCount,
    required this.estimatedProduction,
    this.location,
    this.healthScore,
    this.diagnosisDate,
    this.technicianName,
    this.certificationType,
    this.certificationDate,
    this.certificationExpiry,
    this.diagnosisSummary,
    this.recommendations,
    this.riskLevel,
    this.certCode,
  });

  @override
  State<QRCard> createState() => QRCardState(); // ✅ Ahora es público
}

// ✅ CLASE PÚBLICA (sin _)
class QRCardState extends State<QRCard> {
  final GlobalKey _qrKey = GlobalKey();
  String? _qrData;

  // ✅ Método público para actualizar el QR desde fuera
  void updateQR({
    String? healthScore,
    String? diagnosisDate,
    String? technicianName,
    String? certificationType,
    String? certificationDate,
    String? certificationExpiry,
    String? diagnosisSummary,
    String? recommendations,
    String? riskLevel,
    String? certCode,
  }) {
    setState(() {
      _generateQR();
    });
  }

  // ✅ Método público para recargar el QR
  void refreshQR() {
    setState(() {
      _generateQR();
    });
  }

  @override
  void initState() {
    super.initState();
    _generateQR();
  }

  void _generateQR() {
    _qrData = QRService.generateLotURL(
      lotId: widget.lotId,
      lotName: widget.lotName,
      farmName: widget.farmName,
      variety: widget.variety,
      area: widget.area,
      status: widget.status,
      treesCount: widget.treesCount,
      location: widget.location,
      healthScore: widget.healthScore,
      diagnosisDate: widget.diagnosisDate,
      technicianName: widget.technicianName,
      certificationType: widget.certificationType,
      certificationDate: widget.certificationDate,
      certificationExpiry: widget.certificationExpiry,
      diagnosisSummary: widget.diagnosisSummary,
      recommendations: widget.recommendations,
      riskLevel: widget.riskLevel,
      certCode: widget.certCode,
    );
  }

  void _shareQR() {
    if (_qrData != null) {
      QRService.shareQR(_qrData!, widget.lotName);
    }
  }

  void _downloadQR() {
    if (_qrData != null) {
      QRService.saveQRAsImage(
        context,
        _qrKey,
        'qr_lote_${widget.lotId}',
      );
    }
  }

  void _viewDetails() {
    if (_qrData != null) {
      final data = QRService.parseQRData(_qrData!);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text('Información del Lote'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('🌱 Lote', data['lotName'] ?? widget.lotName),
                _buildDetailRow('🏠 Finca', data['farmName'] ?? widget.farmName),
                _buildDetailRow('🌿 Variedad', data['variety'] ?? widget.variety),
                _buildDetailRow('📏 Área', '${data['area'] ?? widget.area} ha'),
                _buildDetailRow('🌳 Árboles', '${data['treesCount'] ?? widget.treesCount}'),
                _buildDetailRow('📊 Estado', data['status'] ?? widget.status),
                if (data['location'] != null && data['location'].toString().isNotEmpty)
                  _buildDetailRow('📍 Ubicación', data['location']),
                if (data['certCode'] != null && data['certCode'].toString().isNotEmpty)
                  _buildDetailRow('🔑 Código', data['certCode']),

                if (data['healthScore'] != null && data['healthScore'] != 'No evaluado')
                  _buildDetailRow('🏥 Salud', data['healthScore']),
                if (data['technicianName'] != null && data['technicianName'] != 'No asignado')
                  _buildDetailRow('👨‍🔬 Técnico', data['technicianName']),
                if (data['diagnosisSummary'] != null && data['diagnosisSummary'] != 'Sin diagnóstico')
                  _buildDetailRow('📋 Diagnóstico', data['diagnosisSummary']),
                if (data['riskLevel'] != null && data['riskLevel'] != 'Bajo')
                  _buildDetailRow('⚠️ Riesgo', data['riskLevel']),

                if (data['certificationType'] != null && data['certificationType'] != 'No certificado')
                  _buildDetailRow('🏅 Certificación', data['certificationType']),
                if (data['certificationDate'] != null && data['certificationDate']!.isNotEmpty)
                  _buildDetailRow('📅 Fecha', data['certificationDate']),
                if (data['certificationExpiry'] != null && data['certificationExpiry']!.isNotEmpty)
                  _buildDetailRow('⏳ Vigencia', data['certificationExpiry']),

                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.verified, color: AppTheme.primaryGreen, size: 16),
                      const SizedBox(width: 8),
                      const Text(
                        'Certificado digital',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.darkCoffee,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.darkCoffee,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.coffeeDeep : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.qr_code, color: AppTheme.primaryGreen),
              const SizedBox(width: 8),
              Text(
                'Código QR del Lote',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Escanea para ver la información del lote',
            style: TextStyle(
              fontSize: 12,
              color: textColor.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 12),

          RepaintBoundary(
            key: _qrKey,
            child: _qrData != null
                ? QRGenerator(
              data: _qrData!,
              size: 180,
            )
                : Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _viewDetails,
                  icon: const Icon(Icons.info_outline, size: 16),
                  label: const Text('Ver información'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _shareQR,
                  icon: const Icon(Icons.share_outlined, size: 16),
                  label: const Text('Compartir'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _downloadQR,
                  icon: const Icon(Icons.download_outlined, size: 16),
                  label: const Text('Descargar'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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