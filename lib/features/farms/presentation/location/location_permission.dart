// lib/features/farms/presentation/location/location_permission.dart
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class LocationPermissionHandler {
  /// Verifica si el permiso de ubicación está concedido
  static Future<bool> isPermissionGranted() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  /// Solicita permiso de ubicación
  static Future<PermissionStatus> requestPermission() async {
    return await Permission.location.request();
  }

  /// Verifica si los servicios de ubicación están activados
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Muestra un diálogo para activar el GPS
  static Future<void> showEnableGpsDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Activar GPS'),
        content: const Text(
          'Para obtener tu ubicación actual, necesitamos que actives el GPS '
              'en tu dispositivo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Abrir ajustes de ubicación
              Geolocator.openLocationSettings();
            },
            child: const Text('Activar GPS'),
          ),
        ],
      ),
    );
  }
}