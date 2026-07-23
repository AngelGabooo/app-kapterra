// lib/features/farms/presentation/location/location_picker.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'location_service.dart';
import 'location_permission.dart';
import 'location_map.dart';

class LocationPicker extends StatefulWidget {
  final Function(double lat, double lng, String address) onLocationSelected;
  final double? initialLat;
  final double? initialLng;
  final String? initialAddress;

  const LocationPicker({
    super.key,
    required this.onLocationSelected,
    this.initialLat,
    this.initialLng,
    this.initialAddress,
  });

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  bool _isLoading = false;
  bool _hasLocation = false;
  double? _latitude;
  double? _longitude;
  String? _address;

  @override
  void initState() {
    super.initState();
    _latitude = widget.initialLat;
    _longitude = widget.initialLng;
    _address = widget.initialAddress ?? 'Selecciona una ubicación';
    _hasLocation = _latitude != null && _longitude != null;
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    try {
      // Verificar permisos
      final hasPermission = await LocationService.requestPermissionWithDialog(context);
      if (!hasPermission) {
        await LocationService.showLocationSettingsDialog(context);
        setState(() => _isLoading = false);
        return;
      }

      // Verificar GPS activado
      final gpsEnabled = await LocationPermissionHandler.isLocationServiceEnabled();
      if (!gpsEnabled) {
        await LocationPermissionHandler.showEnableGpsDialog(context);
        setState(() => _isLoading = false);
        return;
      }

      // Obtener ubicación
      final position = await LocationService.getCurrentLocation();
      if (position != null) {
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
          _hasLocation = true;
          _isLoading = false;
        });

        // Obtener dirección
        final address = await LocationService.getAddressFromCoordinates(
          position.latitude,
          position.longitude,
        );

        setState(() {
          _address = address;
        });

        widget.onLocationSelected(
          position.latitude,
          position.longitude,
          address,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('📍 Ubicación obtenida: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo obtener la ubicación'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onMapLocationSelected(double lat, double lng) {
    setState(() {
      _latitude = lat;
      _longitude = lng;
      _hasLocation = true;
    });

    // Obtener dirección
    LocationService.getAddressFromCoordinates(lat, lng).then((address) {
      setState(() {
        _address = address;
      });
      widget.onLocationSelected(lat, lng, address);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mapa
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isDark
                ? AppTheme.coffeeDeep.withOpacity(0.7)
                : const Color(0xFFE8E0D5).withOpacity(0.9),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: LocationMap(
              onLocationSelected: _onMapLocationSelected,
              initialLat: _latitude ?? 16.7525,
              initialLng: _longitude ?? -93.1167,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Botones de acción
        Row(
          children: [
            // Botón "Usar ubicación actual"
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isLoading ? null : _getCurrentLocation,
                icon: _isLoading
                    ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.primaryGreen,
                  ),
                )
                    : Icon(Icons.my_location, color: AppTheme.primaryGreen),
                label: Text(
                  _isLoading ? 'Obteniendo...' : 'Usar ubicación actual',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Botón "Seleccionar en mapa"
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // El mapa ya está visible, solo mostrar un mensaje
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Toca el mapa para seleccionar una ubicación'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.edit_location),
                label: const Text('Seleccionar en mapa'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Mostrar ubicación seleccionada
        if (_hasLocation) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: AppTheme.primaryGreen, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _address ?? 'Ubicación seleccionada',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '${_latitude?.toStringAsFixed(4) ?? '--'}, ${_longitude?.toStringAsFixed(4) ?? '--'}',
                        style: TextStyle(
                          fontSize: 11,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _hasLocation = false;
                      _latitude = null;
                      _longitude = null;
                      _address = 'Selecciona una ubicación';
                    });
                    // Notificar que se limpió la ubicación
                    widget.onLocationSelected(0, 0, '');
                  },
                  icon: Icon(Icons.clear, size: 18, color: Colors.grey),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}