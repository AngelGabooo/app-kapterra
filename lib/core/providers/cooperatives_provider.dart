// lib/core/providers/cooperatives_provider.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/features/auth/data/models/user_type_model.dart';

class CooperativeModel {
  final String id;
  final String name;
  final String email;
  final String location;
  final String phone;

  CooperativeModel({
    required this.id,
    required this.name,
    required this.email,
    required this.location,
    required this.phone,
  });
}

class CooperativesProvider extends ChangeNotifier {
  final List<CooperativeModel> _cooperatives = [];
  bool _isInitialized = false;

  List<CooperativeModel> get cooperatives => List.unmodifiable(_cooperatives);
  bool get hasCooperatives => _cooperatives.isNotEmpty;
  int get count => _cooperatives.length;

  void addCooperative(CooperativeModel cooperative) {
    // ✅ Evitar duplicados por email
    final exists = _cooperatives.any((c) => c.email == cooperative.email);
    if (!exists) {
      _cooperatives.add(cooperative);
      _isInitialized = true;
      notifyListeners();
      debugPrint('✅ Cooperativa agregada: ${cooperative.name} (${cooperative.email})');
    } else {
      debugPrint('⚠️ Cooperativa ya existe: ${cooperative.name}');
    }
  }

  void removeCooperative(String id) {
    _cooperatives.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  // ✅ Cargar cooperativas desde usuarios registrados
  void loadCooperativeFromUser({
    required String id,
    required String name,
    required String email,
    required String location,
    required String phone,
  }) {
    // Verificar si ya existe
    final exists = _cooperatives.any((c) => c.email == email);
    if (!exists) {
      _cooperatives.add(CooperativeModel(
        id: id,
        name: name,
        email: email,
        location: location.isNotEmpty ? location : 'Ubicación no especificada',
        phone: phone.isNotEmpty ? phone : 'Sin teléfono',
      ));
      _isInitialized = true;
      notifyListeners();
      debugPrint('✅ Cooperativa cargada desde usuario: $name ($email)');
    } else {
      debugPrint('⚠️ Cooperativa ya cargada: $name ($email)');
    }
  }

  /// ✅ Método para cargar múltiples cooperativas desde una lista
  void loadCooperatives(List<CooperativeModel> cooperatives) {
    for (final coop in cooperatives) {
      final exists = _cooperatives.any((c) => c.email == coop.email);
      if (!exists) {
        _cooperatives.add(coop);
      }
    }
    _isInitialized = true;
    notifyListeners();
    debugPrint('✅ Cargadas ${cooperatives.length} cooperativas');
  }

  /// ✅ Método para forzar la recarga de cooperativas desde SharedPreferences
  Future<void> reloadFromStorage() async {
    debugPrint('🔄 Recargando cooperativas desde almacenamiento...');
    _isInitialized = true;
    notifyListeners();
  }

  void clearAll() {
    _cooperatives.clear();
    _isInitialized = false;
    notifyListeners();
  }

  /// ✅ Método para inicializar con múltiples cooperativas
  void initializeWith(List<CooperativeModel> cooperatives) {
    _cooperatives.clear();
    _cooperatives.addAll(cooperatives);
    _isInitialized = true;
    notifyListeners();
    debugPrint('✅ Inicializadas ${cooperatives.length} cooperativas');
  }

  /// ✅ Forzar notificación a los listeners
  void refresh() {
    notifyListeners();
    debugPrint('🔄 CooperativesProvider refrescado');
  }
}