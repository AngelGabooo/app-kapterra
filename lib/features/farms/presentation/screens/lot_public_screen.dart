// lib/features/farms/presentation/screens/lot_public_screen.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:qr_flutter/qr_flutter.dart';

class LotPublicScreen extends StatelessWidget {
  final String lotId;
  final String lotName;
  final String farmName;
  final String variety;
  final double area;
  final String status;
  final int treesCount;
  final double estimatedProduction;
  final String? location;

  const LotPublicScreen({
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
  });

  factory LotPublicScreen.fromQRData(Map<String, dynamic> data) {
    return LotPublicScreen(
      lotId: data['lotId'] ?? '',
      lotName: data['lotName'] ?? 'Lote sin nombre',
      farmName: data['farmName'] ?? 'Finca sin nombre',
      variety: data['variety'] ?? 'No especificada',
      area: (data['area'] ?? 0).toDouble(),
      status: data['status'] ?? 'Sin estado',
      treesCount: data['treesCount'] ?? 0,
      estimatedProduction: data['estimatedProduction'] ?? 0,
      location: data['location'],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.help_outline;
    switch (status.toLowerCase()) {
      case 'saludable':
      case 'excelente':
      case 'healthy':
        statusColor = const Color(0xFF2E7D32);
        statusIcon = Icons.check_circle;
        break;
      case 'atención':
      case 'attention':
        statusColor = const Color(0xFFF57C00);
        statusIcon = Icons.warning;
        break;
      case 'riesgo':
      case 'risk':
        statusColor = const Color(0xFFD32F2F);
        statusIcon = Icons.error;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightBeige,
              AppTheme.primaryGreen.withOpacity(0.03),
              AppTheme.lightBeige,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.coffeeDeep : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.qr_code,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Información del Lote',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkCoffee,
                          ),
                        ),
                        Text(
                          'Verificado por trazabilidad digital',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.darkCoffee,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified,
                            color: AppTheme.primaryGreen,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Certificado',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.primaryGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Contenido
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // QR Code Mini
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: QrImageView(
                                data: 'Lote: $lotId',
                                version: QrVersions.auto,
                                size: 60,
                                gapless: false,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ID del Lote',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: textColor.withOpacity(0.5),
                                    ),
                                  ),
                                  Text(
                                    '#${lotId.substring(0, 8)}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.qr_code_scanner,
                                        size: 12,
                                        color: AppTheme.primaryGreen,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Escaneado exitosamente',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppTheme.primaryGreen,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Información del Lote
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.agriculture,
                                  color: AppTheme.primaryGreen,
                                  size: 22,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Detalles del Lote',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildInfoTile(
                              icon: Icons.label,
                              label: 'Nombre del Lote',
                              value: lotName,
                              textColor: textColor,
                            ),
                            _buildInfoTile(
                              icon: Icons.landscape,
                              label: 'Finca',
                              value: farmName,
                              textColor: textColor,
                            ),
                            _buildInfoTile(
                              icon: Icons.emoji_nature,
                              label: 'Variedad',
                              value: variety,
                              textColor: textColor,
                            ),
                            _buildInfoTile(
                              icon: Icons.landscape,
                              label: 'Área cultivada',
                              value: '${area.toStringAsFixed(1)} hectáreas',
                              textColor: textColor,
                            ),
                            if (treesCount > 0)
                              _buildInfoTile(
                                icon: Icons.nature,
                                label: 'Árboles',
                                value: treesCount.toString(),
                                textColor: textColor,
                              ),
                            if (estimatedProduction > 0)
                              _buildInfoTile(
                                icon: Icons.eco,
                                label: 'Producción estimada',
                                value: '${estimatedProduction.toStringAsFixed(1)} kg',
                                textColor: textColor,
                              ),
                            if (location != null && location!.isNotEmpty)
                              _buildInfoTile(
                                icon: Icons.location_on,
                                label: 'Ubicación',
                                value: location!,
                                textColor: textColor,
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Estado del Lote
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: statusColor.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                statusIcon,
                                color: statusColor,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Estado del Lote',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: textColor.withOpacity(0.5),
                                    ),
                                  ),
                                  Text(
                                    status,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: statusColor,
                                    ),
                                  ),
                                  Text(
                                    'Información verificada digitalmente',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: textColor.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Footer
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              '🔒 Verificado por Kaab Terra',
                              style: TextStyle(
                                fontSize: 11,
                                color: textColor.withOpacity(0.3),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Información escaneada de código QR',
                              style: TextStyle(
                                fontSize: 10,
                                color: textColor.withOpacity(0.2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppTheme.primaryGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: textColor.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}