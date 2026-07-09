import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/features/auth/data/models/user_type_model.dart';

class UserProvider extends ChangeNotifier {
  UserType? _selectedUserType;
  String? _userEmail;
  String? _userName;
  bool _isLoggedIn = false;

  UserType? get selectedUserType => _selectedUserType;
  String? get userEmail => _userEmail;
  String? get userName => _userName;
  bool get isLoggedIn => _isLoggedIn;

  // ============================================================
  // ✅ MÉTODOS DE GUARDADO
  // ============================================================

  /// Guardar solo el email (útil cuando el usuario aún no ha seleccionado rol)
  Future<void> setUserEmail(String email) async {
    _userEmail = email;
    await _saveUserEmail(email);
    notifyListeners();
  }

  /// Guardar el rol seleccionado durante el registro (con email)
  Future<void> setUserType(UserType type, {String? email}) async {
    _selectedUserType = type;
    if (email != null) {
      _userEmail = email;
    }
    await _saveUserType(type, email: email);
    notifyListeners();
  }

  /// Guardar información completa del usuario
  Future<void> setUserInfo({
    required UserType type,
    required String email,
    required String name,
  }) async {
    _selectedUserType = type;
    _userEmail = email;
    _userName = name;
    _isLoggedIn = true;
    await _saveUserType(type, email: email);
    await _saveUserEmail(email);
    await _saveUserName(name);
    notifyListeners();
  }

  // ============================================================
  // ✅ MÉTODOS DE CARGA
  // ============================================================

  /// Iniciar sesión (recuperar datos guardados del usuario)
  Future<void> login({required String email, required String name}) async {
    _userEmail = email;
    _userName = name;
    _isLoggedIn = true;
    // Cargar el tipo de usuario guardado para este email
    await loadSavedUserTypeForEmail(email);
    notifyListeners();
  }

  /// Cargar el tipo de usuario guardado para un email específico
  Future<UserType?> loadSavedUserTypeForEmail(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'user_type_${_sanitizeEmail(email)}';
      final index = prefs.getInt(key);
      if (index != null && index >= 0 && index < UserType.values.length) {
        _selectedUserType = UserType.values[index];
        _userEmail = email;
        notifyListeners();
        return _selectedUserType;
      }
    } catch (e) {
      debugPrint('Error cargando tipo de usuario para email: $e');
    }
    return null;
  }

  /// Cargar tipo de usuario guardado (para cuando la app se reinicia)
  Future<UserType?> loadSavedUserType() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Intentar cargar el email guardado primero
      final email = prefs.getString('user_email');
      if (email != null && email.isNotEmpty) {
        _userEmail = email;
        final key = 'user_type_${_sanitizeEmail(email)}';
        final index = prefs.getInt(key);
        if (index != null && index >= 0 && index < UserType.values.length) {
          _selectedUserType = UserType.values[index];
          _userName = prefs.getString('user_name');
          _isLoggedIn = true;
          notifyListeners();
          return _selectedUserType;
        }
      }

      // Fallback al rol general
      final index = prefs.getInt('user_type');
      if (index != null && index >= 0 && index < UserType.values.length) {
        _selectedUserType = UserType.values[index];
        notifyListeners();
        return _selectedUserType;
      }
    } catch (e) {
      debugPrint('Error cargando tipo de usuario: $e');
    }
    return null;
  }

  // ============================================================
  // ✅ MÉTODOS DE CIERRE DE SESIÓN
  // ============================================================

  /// Cerrar sesión
  Future<void> logout() async {
    _selectedUserType = null;
    _userEmail = null;
    _userName = null;
    _isLoggedIn = false;
    await _clearSavedUserType();
    notifyListeners();
  }

  // ============================================================
  // ✅ PERSISTENCIA LOCAL (SharedPreferences)
  // ============================================================

  Future<void> _saveUserType(UserType type, {String? email}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Guardar el rol general
      await prefs.setInt('user_type', type.index);

      // Guardar el rol específico para el email
      final emailToUse = email ?? _userEmail;
      if (emailToUse != null && emailToUse.isNotEmpty) {
        final key = 'user_type_${_sanitizeEmail(emailToUse)}';
        await prefs.setInt(key, type.index);
        debugPrint('✅ Rol guardado para email: $emailToUse -> ${type.title}');
      }
    } catch (e) {
      debugPrint('Error guardando tipo de usuario: $e');
    }
  }

  Future<void> _saveUserEmail(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', email);
      debugPrint('✅ Email guardado: $email');
    } catch (e) {
      debugPrint('Error guardando email: $e');
    }
  }

  Future<void> _saveUserName(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', name);
      debugPrint('✅ Nombre guardado: $name');
    } catch (e) {
      debugPrint('Error guardando nombre: $e');
    }
  }

  Future<void> _clearSavedUserType() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_type');
      if (_userEmail != null && _userEmail!.isNotEmpty) {
        final key = 'user_type_${_sanitizeEmail(_userEmail!)}';
        await prefs.remove(key);
      }
      await prefs.remove('user_email');
      await prefs.remove('user_name');
      debugPrint('✅ Datos de usuario eliminados');
    } catch (e) {
      debugPrint('Error limpiando tipo de usuario: $e');
    }
  }

  // ============================================================
  // ✅ MÉTODOS DE UTILIDAD
  // ============================================================

  /// Sanitizar email para usar como clave en SharedPreferences
  String _sanitizeEmail(String email) {
    return email.replaceAll('@', '_').replaceAll('.', '_');
  }

  /// Obtener la ruta destino según el rol
  String getDestinationRoute() {
    switch (_selectedUserType) {
      case UserType.producer:
        return RouteNames.dashboard;
      case UserType.cooperative:
        return RouteNames.cooperativeDashboard;
      case UserType.buyer:
        return RouteNames.marketplace;
      case UserType.technician:
        return RouteNames.technicianDashboard;
      default:
        return RouteNames.dashboard;
    }
  }

  /// Limpiar el rol guardado para un email específico (útil para pruebas)
  Future<void> clearUserTypeForEmail(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'user_type_${_sanitizeEmail(email)}';
      await prefs.remove(key);
      debugPrint('✅ Rol eliminado para email: $email');
    } catch (e) {
      debugPrint('Error limpiando tipo de usuario: $e');
    }
  }

  /// Verificar si hay un usuario logueado
  Future<bool> checkLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email');
      if (email != null && email.isNotEmpty) {
        final key = 'user_type_${_sanitizeEmail(email)}';
        final index = prefs.getInt(key);
        if (index != null && index >= 0 && index < UserType.values.length) {
          _userEmail = email;
          _selectedUserType = UserType.values[index];
          _userName = prefs.getString('user_name');
          _isLoggedIn = true;
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error verificando login: $e');
      return false;
    }
  }

  /// Obtener todos los roles guardados (para depuración)
  Future<Map<String, UserType>> getAllSavedUserTypes() async {
    final Map<String, UserType> result = {};
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      for (final key in keys) {
        if (key.startsWith('user_type_') && key != 'user_type') {
          final index = prefs.getInt(key);
          if (index != null && index >= 0 && index < UserType.values.length) {
            final email = key.replaceFirst('user_type_', '').replaceAll('_', '@').replaceAll('_', '.');
            result[email] = UserType.values[index];
          }
        }
      }
    } catch (e) {
      debugPrint('Error obteniendo roles guardados: $e');
    }
    return result;
  }
}