// lib/core/services/call_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CallService {
  static const String _baseUrl = 'https://biobot-six.vercel.app';

  /// Inicia una llamada desde el bot al cliente y luego al productor
  static Future<bool> makeCall({
    required String clientPhoneNumber,  // Número del cliente (usuario de la app)
    required String producerPhone,      // Número del productor
    String? producerName,
  }) async {
    try {
      print('📞 ===== INICIANDO LLAMADA =====');
      print('📞 Cliente: $clientPhoneNumber');
      print('📞 Productor: $producerPhone');
      print('📞 Productor Nombre: $producerName');

      final url = Uri.parse('$_baseUrl/make-call');

      // Enviar ambos números como parámetros
      final fullUrl = url.replace(queryParameters: {
        'clientPhone': clientPhoneNumber,
        'producerPhone': producerPhone,
        'producerName': producerName ?? 'Productor',
      });

      print('📞 URL completa: $fullUrl');

      final response = await http.get(fullUrl);

      print('📞 Status code: ${response.statusCode}');
      print('📞 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          print('✅ Llamada iniciada exitosamente');
          return true;
        }
        print('❌ Error en la respuesta: ${data['message']}');
        return false;
      } else {
        print('❌ Error HTTP: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Error al hacer la llamada: $e');
      return false;
    }
  }

  /// Verifica si el bot está disponible
  static Future<bool> isBotAvailable() async {
    try {
      final url = Uri.parse('$_baseUrl/');
      final response = await http.get(url);
      print('📞 Bot disponible: ${response.statusCode == 200}');
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Error verificando bot: $e');
      return false;
    }
  }
}