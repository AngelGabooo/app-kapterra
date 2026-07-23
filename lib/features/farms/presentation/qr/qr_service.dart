// lib/features/farms/presentation/qr/qr_service.dart
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../../../../core/themes/app_theme.dart';

class QRService {
  /// Genera datos JSON para el código QR con toda la información del lote
  static String generateQRData({
    required String lotId,
    required String lotName,
    required String farmName,
    required String variety,
    required double area,
    required String status,
    required int treesCount,
    required double estimatedProduction,
    String? location,
  }) {
    final data = {
      'lotId': lotId,
      'lotName': lotName,
      'farmName': farmName,
      'variety': variety,
      'area': area,
      'status': status,
      'treesCount': treesCount,
      'estimatedProduction': estimatedProduction,
      'location': location ?? '',
      'timestamp': DateTime.now().toIso8601String(),
      'type': 'lot_qr',
      'version': '1.0',
    };
    return jsonEncode(data);
  }

  /// Genera la URL pública para el lote (para usar en el QR)
  static String generateLotURL({
    required String lotId,
    required String lotName,
    required String farmName,
    required String variety,
    required double area,
    required String status,
    required int treesCount,
    String? location,
  }) {
    // ⚠️ Para pruebas locales
    final baseUrl = 'https://qrr-psi.vercel.app/lot_public.html';

    // 🔄 Cuando subas a producción, cambia por tu URL pública:
    // final baseUrl = 'https://tu-dominio.com/lot_public.html';

    final params = {
      'id': lotId,
      'name': lotName,
      'farm': farmName,
      'variety': variety,
      'area': '${area.toStringAsFixed(1)} ha',
      'trees': treesCount.toString(),
      'location': location ?? 'No especificada',
      'status': status,
    };

    final queryString = params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return '$baseUrl?$queryString';
  }

  /// Parsea los datos del código QR
  static Map<String, dynamic> parseQRData(String qrData) {
    try {
      final data = jsonDecode(qrData) as Map<String, dynamic>;
      // Verificar que sea un QR de lote válido
      if (data['type'] != 'lot_qr') {
        return {};
      }
      return data;
    } catch (e) {
      return {};
    }
  }

  /// Comparte el código QR
  static Future<void> shareQR(String qrData, String lotName) async {
    try {
      final data = parseQRData(qrData);
      final message = data.isNotEmpty
          ? '🌱 Lote: ${data['lotName'] ?? lotName}\n'
          '🏠 Finca: ${data['farmName'] ?? 'No especificada'}\n'
          '🌿 Variedad: ${data['variety'] ?? 'No especificada'}\n'
          '📏 Área: ${data['area'] ?? 0} ha\n'
          '📊 Estado: ${data['status'] ?? 'Sin estado'}\n'
          '🔗 Escanea este código QR para ver más información'
          : '🌱 Lote: $lotName\n'
          '📋 Escanea este código QR para ver la información del lote';

      await Share.share(
        message,
        subject: 'Información del Lote $lotName',
      );
    } catch (e) {
      // Manejar error
    }
  }

  /// Guarda el código QR como imagen
  static Future<void> saveQRAsImage(
      BuildContext context,
      GlobalKey qrKey,
      String fileName,
      ) async {
    try {
      final boundary = qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes == null) return;

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName.png');
      await file.writeAsBytes(pngBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ QR guardado en la galería'),
          backgroundColor: AppTheme.primaryGreen,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}