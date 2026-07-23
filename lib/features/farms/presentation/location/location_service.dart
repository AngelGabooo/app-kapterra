// lib/features/farms/presentation/location/location_service.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  /// Obtiene la ubicación actual del dispositivo
  static Future<Position?> getCurrentLocation() async {
    try {
      // Verificar si el GPS está activado
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      // Verificar permisos
      final permission = await _checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      // Obtener ubicación
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      return null;
    }
  }

  /// Verifica y solicita permisos de ubicación
  static Future<LocationPermission> _checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission;
  }

  /// Solicita permisos de ubicación (con diálogo explicativo)
  static Future<bool> requestPermissionWithDialog(BuildContext context) async {
    final status = await Permission.location.request();

    if (status.isDenied) {
      return false;
    }

    if (status.isPermanentlyDenied) {
      return false;
    }

    return status.isGranted;
  }

  /// Muestra un diálogo para abrir ajustes de ubicación
  static Future<void> showLocationSettingsDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permiso de ubicación'),
        content: const Text(
          'La aplicación necesita acceso a tu ubicación para registrar la finca. '
              'Por favor, habilita el permiso desde los ajustes del dispositivo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Abrir ajustes'),
          ),
        ],
      ),
    );
  }

  /// Obtiene una dirección a partir de coordenadas (versión simple)
  static Future<String> getAddressFromCoordinates(
      double latitude,
      double longitude,
      ) async {
    // ✅ Versión simple - formatea las coordenadas
    // Si quieres una dirección real, puedes usar una API externa
    final latStr = latitude.toStringAsFixed(4);
    final lngStr = longitude.toStringAsFixed(4);
    return 'Ubicación ($latStr°, $lngStr°)';
  }
}