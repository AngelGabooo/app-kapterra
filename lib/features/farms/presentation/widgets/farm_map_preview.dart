import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';

class FarmMapPreview extends StatelessWidget {
  final List<FarmDetailsModel> farms;
  final Function(FarmDetailsModel) onFarmTap;

  const FarmMapPreview({
    super.key,
    required this.farms,
    required this.onFarmTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Mapa simulado
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryGreen.withOpacity(0.3),
                    AppTheme.secondaryGreen.withOpacity(0.2),
                  ],
                ),
              ),
              child: CustomPaint(
                painter: MapGridPainter(),
                child: Stack(
                  children: [
                    // Marcadores de fincas
                    ...farms.asMap().entries.map((entry) {
                      final index = entry.key;
                      final farm = entry.value;
                      final left = 20.0 + (index * 60) % (screenWidth - 100);
                      final top = 30.0 + (index * 40) % 140;
                      return Positioned(
                        left: left,
                        top: top,
                        child: GestureDetector(
                          onTap: () => onFarmTap(farm),
                          child: Column(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: farm.statusColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: farm.statusColor.withOpacity(0.5),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.agriculture,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  farm.name.length > 10 ? '${farm.name.substring(0, 10)}...' : farm.name,
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            // Controles del mapa
            Positioned(
              top: 8,
              right: 8,
              child: Column(
                children: [
                  _buildMapControl(Icons.add),
                  const SizedBox(height: 8),
                  _buildMapControl(Icons.remove),
                  const SizedBox(height: 8),
                  _buildMapControl(Icons.layers),
                ],
              ),
            ),
            // Leyenda
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildLegendItem(FarmHealthStatus.healthy, 'Saludable'),
                    _buildLegendItem(FarmHealthStatus.attention, 'Atención'),
                    _buildLegendItem(FarmHealthStatus.risk, 'Riesgo'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapControl(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Icon(icon, size: 20, color: AppTheme.primaryGreen),
    );
  }

  Widget _buildLegendItem(FarmHealthStatus status, String label) {
    Color color;
    switch (status) {
      case FarmHealthStatus.healthy:
        color = const Color(0xFF2E7D32);
        break;
      case FarmHealthStatus.attention:
        color = const Color(0xFFF57C00);
        break;
      case FarmHealthStatus.risk:
        color = const Color(0xFFD32F2F);
        break;
    }
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.white),
        ),
      ],
    );
  }
}

class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}