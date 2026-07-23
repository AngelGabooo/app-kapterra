// lib/features/farms/presentation/location/location_map.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class LocationMap extends StatefulWidget {
  final Function(double lat, double lng) onLocationSelected;
  final double initialLat;
  final double initialLng;

  const LocationMap({
    super.key,
    required this.onLocationSelected,
    required this.initialLat,
    required this.initialLng,
  });

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  late double _latitude;
  late double _longitude;
  bool _isSatelliteView = false;

  @override
  void initState() {
    super.initState();
    _latitude = widget.initialLat;
    _longitude = widget.initialLng;
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
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        // Fondo del mapa
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                AppTheme.coffeeDark.withOpacity(0.8),
                AppTheme.coffeeDeep.withOpacity(0.6),
              ]
                  : [
                AppTheme.primaryGreen.withOpacity(0.25),
                AppTheme.secondaryGreen.withOpacity(0.15),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Grid del mapa
              CustomPaint(
                painter: _MapGridPainter(
                  isDark: isDark,
                  theme: theme,
                ),
              ),

              // Marcador de ubicación
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_pin,
                      color: isDark ? AppTheme.coffeeGoldLight : AppTheme.goldCoffee,
                      size: 44,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppTheme.coffeeDeep.withOpacity(0.9)
                            : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.black.withOpacity(0.1),
                        ),
                      ),
                      child: Text(
                        '${_latitude.toStringAsFixed(4)}°, ${_longitude.toStringAsFixed(4)}°',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppTheme.darkCoffee,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Controles del mapa
              Positioned(
                top: 12,
                right: 12,
                child: Column(
                  children: [
                    _buildMapControl(
                      icon: Icons.add,
                      isDark: isDark,
                      onTap: () {
                        setState(() {
                          _latitude += 0.01;
                          _longitude += 0.01;
                        });
                        widget.onLocationSelected(_latitude, _longitude);
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildMapControl(
                      icon: Icons.remove,
                      isDark: isDark,
                      onTap: () {
                        setState(() {
                          _latitude -= 0.01;
                          _longitude -= 0.01;
                        });
                        widget.onLocationSelected(_latitude, _longitude);
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildMapControl(
                      icon: _isSatelliteView ? Icons.map : Icons.satellite_alt,
                      isDark: isDark,
                      onTap: () {
                        setState(() => _isSatelliteView = !_isSatelliteView);
                      },
                    ),
                  ],
                ),
              ),

              // Botón centrar
              Positioned(
                bottom: 12,
                right: 12,
                child: _buildMapControl(
                  icon: Icons.my_location,
                  isDark: isDark,
                  onTap: () {
                    // Centrar en Chiapas
                    _updateLocation(16.7525, -93.1167);
                  },
                ),
              ),
            ],
          ),
        ),

        // Instrucción inferior
        Positioned(
          bottom: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.touch_app, size: 12, color: Colors.white70),
                const SizedBox(width: 4),
                Text(
                  'Toca para ajustar ubicación',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapControl({
    required IconData icon,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isDark
              ? AppTheme.coffeeDeep.withOpacity(0.9)
              : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.1),
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen,
        ),
      ),
    );
  }
}

// Painter para el grid del mapa
class _MapGridPainter extends CustomPainter {
  final bool isDark;
  final ThemeData theme;

  _MapGridPainter({required this.isDark, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark
          ? Colors.white.withOpacity(0.06)
          : Colors.black.withOpacity(0.08)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Líneas verticales
    for (double x = 0; x < size.width; x += 30) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Líneas horizontales
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}