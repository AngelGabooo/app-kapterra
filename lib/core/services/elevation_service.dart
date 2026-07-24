// lib/core/services/elevation_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart'; // ✅ AGREGAR PARA debugPrint
import 'package:http/http.dart' as http;

class ElevationService {
  static const String _baseUrl = 'https://api.open-elevation.com/api/v1/lookup';

  /// Obtiene la altitud para unas coordenadas dadas
  static Future<double?> getElevation(double lat, double lng) async {
    try {
      final url = Uri.parse('$_baseUrl?locations=$lat,$lng');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final elevation = data['results'][0]['elevation'];
          return elevation?.toDouble();
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error obteniendo altitud: $e');
      return null;
    }
  }
}