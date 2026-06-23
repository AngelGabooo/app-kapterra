import 'package:flutter/material.dart';

class FarmMap extends StatefulWidget {
  final Function(double lat, double lng) onLocationSelected;
  final double? initialLat;
  final double? initialLng;

  const FarmMap({
    super.key,
    required this.onLocationSelected,
    this.initialLat,
    this.initialLng,
  });

  @override
  State<FarmMap> createState() => _FarmMapState();
}

class _FarmMapState extends State<FarmMap> {
  late double _latitude;
  late double _longitude;
  bool _isSatelliteView = false;

  @override
  void initState() {
    super.initState();
    _latitude = widget.initialLat ?? 16.7525; // Base Chiapas por defecto
    _longitude = widget.initialLng ?? -93.1167;
  }

  void _updateLocation(double lat, double lng) {
    setState(() {
      _latitude = lat;
      _longitude = lng;
    });
    widget.onLocationSelected(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(theme.brightness == Brightness.dark ? 0.3 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 280,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.25),
                    theme.colorScheme.secondary.withOpacity(0.15),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size.infinite,
                    painter: MapGridPainter(theme: theme),
                  ),

                  // Marcador de Ubicación
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: theme.colorScheme.tertiary,
                          size: 48,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
                          ),
                          child: Text(
                            '${_latitude.toStringAsFixed(4)}°, ${_longitude.toStringAsFixed(4)}°',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Controles de Mapa
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Column(
                      children: [
                        _buildMapControl(icon: Icons.add, theme: theme, onTap: () => setState(() { _latitude += 0.01; _longitude += 0.01; })),
                        const SizedBox(height: 8),
                        _buildMapControl(icon: Icons.remove, theme: theme, onTap: () => setState(() { _latitude -= 0.01; _longitude -= 0.01; })),
                        const SizedBox(height: 8),
                        _buildMapControl(icon: _isSatelliteView ? Icons.map : Icons.satellite_alt, theme: theme, onTap: () => setState(() => _isSatelliteView = !_isSatelliteView)),
                      ],
                    ),
                  ),

                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: _buildMapControl(icon: Icons.my_location, theme: theme, onTap: () => _updateLocation(16.7525, -93.1167)),
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.65), borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.touch_app, size: 14, color: Colors.white.withOpacity(0.9)),
                    const SizedBox(width: 4),
                    Text('Arrastra para ajustar ubicación', style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.9))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapControl({required IconData icon, required ThemeData theme, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
        ),
        child: Icon(icon, size: 20, color: theme.colorScheme.secondary),
      ),
    );
  }
}

class MapGridPainter extends CustomPainter {
  final ThemeData theme;
  MapGridPainter({required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = theme.colorScheme.onSurface.withOpacity(0.12)
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