// lib/core/providers/qr_update_provider.dart
import 'package:flutter/material.dart';

class QRUpdateProvider extends ChangeNotifier {
  Map<String, dynamic> _certificationData = {};
  bool _hasBeenUpdated = false;

  Map<String, dynamic> get certificationData => _certificationData;
  bool get hasBeenUpdated => _hasBeenUpdated;

  void updateQR(Map<String, dynamic> data) {
    _certificationData = data;
    _hasBeenUpdated = true;
    notifyListeners();
    debugPrint('✅ QRUpdateProvider: QR actualizado con datos: $data');
  }

  void clear() {
    _certificationData = {};
    _hasBeenUpdated = false;
    notifyListeners();
  }
}