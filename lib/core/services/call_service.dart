// lib/core/services/call_service.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CallService {
  /// Inicia una llamada telefónica directamente al número proporcionado
  static Future<bool> makeDirectCall(String phoneNumber) async {
    try {
      final phone = phoneNumber.trim();
      if (phone.isEmpty) {
        debugPrint('❌ Número de teléfono vacío');
        return false;
      }

      // Limpiar el número: eliminar espacios, guiones, etc.
      final cleanPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');

      if (cleanPhone.isEmpty) {
        debugPrint('❌ Número de teléfono inválido después de limpiar');
        return false;
      }

      final Uri phoneUri = Uri(
        scheme: 'tel',
        path: cleanPhone,
      );

      debugPrint('📞 Llamando a: $cleanPhone');

      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
        return true;
      } else {
        debugPrint('❌ No se puede iniciar la llamada a: $cleanPhone');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error al realizar la llamada: $e');
      return false;
    }
  }

  /// Verifica si el dispositivo puede realizar llamadas
  static Future<bool> canMakeCall(String phoneNumber) async {
    try {
      final phone = phoneNumber.trim().replaceAll(RegExp(r'[^0-9+]'), '');
      if (phone.isEmpty) return false;

      final Uri phoneUri = Uri(
        scheme: 'tel',
        path: phone,
      );
      return await canLaunchUrl(phoneUri);
    } catch (e) {
      return false;
    }
  }
}