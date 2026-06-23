import 'package:flutter/material.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';

class FarmMapPreview extends StatelessWidget {
  final List<FarmDetailsModel> farms;
  final Function(FarmDetailsModel) onFarmTap;

  const FarmMapPreview({super.key, required this.farms, required this.onFarmTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.06)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Contenedor del Mapa Simulado Adaptativo
            Container(
              width: double.infinity,
              height: 200,
              color: theme.colorScheme.primary.withOpacity(0.04),
              child: CustomPaint(
                painter: MapGridPainter(theme: theme),
                child: Stack(
                  children: farms.asMap().entries.map((entry) {
                    final index = entry.key;
                    final farm = entry.value;
                    final left = 24.0 + (index * 70) % (screenWidth - 120);
                    final top = 40.0 + (index * 35) % 110;

                    return Positioned(
                      left: left,
                      top: top,
                      child: GestureDetector(
                        onTap: () => onFarmTap(farm),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: farm.statusColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: theme.colorScheme.surface, width: 2.5),
                                boxShadow: [BoxShadow(color: farm.statusColor.withOpacity(0.3), blurRadius: 10)],
                              ),
                              child: const Icon(Icons.filter_hdr_rounded, size: 14, color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.04)),
                              ),
                              child: Text(
                                farm.name.length > 10 ? '${farm.name.substring(0, 10)}...' : farm.name,
                                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: theme.colorScheme.onSurface),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            // Controles Ópticos Flotantes
            Positioned(
              top: 12,
              right: 12,
              child: Column(
                children: [
                  _buildMapControl(Icons.add_rounded, theme),
                  const SizedBox(height: 6),
                  _buildMapControl(Icons.remove_rounded, theme),
                ],
              ),
            ),
            // Leyenda de Nodos
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildLegendItem(const Color(0xFF2E7D32), 'Estable'),
                    _buildLegendItem(const Color(0xFFF57C00), 'Mantenimiento'),
                    _buildLegendItem(const Color(0xFFD32F2F), 'Riesgo'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapControl(IconData icon, ThemeData theme) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.05)),
      ),
      child: Icon(icon, size: 18, color: theme.colorScheme.primary),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        CircleAvatar(radius: 3, backgroundColor: color),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }
}

class MapGridPainter extends CustomPainter {
  final ThemeData theme;
  MapGridPainter({required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = theme.colorScheme.onSurface.withOpacity(0.02)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (double x = 0; x < size.width; x += 35) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 35) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}