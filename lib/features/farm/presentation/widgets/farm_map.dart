import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

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
    _latitude = widget.initialLat ?? 19.4326; // Centro de México por defecto
    _longitude = widget.initialLng ?? -99.1332;
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
    return Container(
      height: 280,
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
            // Mapa simulado (en producción usar google_maps_flutter o mapbox)
            Container(
              width: double.infinity,
              height: 280,
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
              child: Stack(
                children: [
                  // Cuadrícula simulando mapa
                  CustomPaint(
                    size: Size.infinite,
                    painter: MapGridPainter(),
                  ),

                  // Marcador central
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: AppTheme.goldCoffee,
                          size: 48,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Text(
                            '${_latitude.toStringAsFixed(4)}°, ${_longitude.toStringAsFixed(4)}°',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Controles de mapa
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Column(
                      children: [
                        _buildMapControl(
                          icon: Icons.add,
                          onTap: () {
                            // Zoom in
                            setState(() {
                              _latitude += 0.01;
                              _longitude += 0.01;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        _buildMapControl(
                          icon: Icons.remove,
                          onTap: () {
                            // Zoom out
                            setState(() {
                              _latitude -= 0.01;
                              _longitude -= 0.01;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        _buildMapControl(
                          icon: _isSatelliteView
                              ? Icons.map
                              : Icons.satellite_alt,
                          onTap: () {
                            setState(() {
                              _isSatelliteView = !_isSatelliteView;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  // Botón mi ubicación
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: _buildMapControl(
                      icon: Icons.my_location,
                      onTap: () {
                        // Simular obtener ubicación actual
                        _updateLocation(19.4326, -99.1332);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Overlay de texto informativo
            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.touch_app,
                      size: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Arrastra para ajustar ubicación',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapControl({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: AppTheme.primaryGreen,
        ),
      ),
    );
  }
}

// CustomPainter para dibujar cuadrícula del mapa
class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Líneas verticales
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Líneas horizontales
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}