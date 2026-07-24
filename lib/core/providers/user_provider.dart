// lib/core/providers/user_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/features/auth/data/models/user_type_model.dart';

class UserProvider extends ChangeNotifier {
  UserType? _selectedUserType;
  String? _userEmail;
  String? _userName;
  String? _userPhone;
  bool _isLoggedIn = false;

  UserType? get selectedUserType => _selectedUserType;
  String? get userEmail => _userEmail;
  String? get userName => _userName;
  String? get userPhone => _userPhone;
  bool get isLoggedIn => _isLoggedIn;

  // ============================================================
  // ✅ MÉTODOS DE GUARDADO
  // ============================================================

  Future<void> setUserEmail(String email) async {
    _userEmail = email;
    await _saveUserEmail(email);
    notifyListeners();
  }

  Future<void> setUserType(UserType type, {String? email}) async {
    _selectedUserType = type;
    if (email != null) {
      _userEmail = email;
    }
    await _saveUserType(type, email: email);
    notifyListeners();
  }

  Future<void> setUserInfo({
    required UserType type,
    required String email,
    required String name,
    String? phone,
  }) async {
    _selectedUserType = type;
    _userEmail = email;
    _userName = name;
    _userPhone = phone;
    _isLoggedIn = true;
    await _saveUserType(type, email: email);
    await _saveUserEmail(email);
    await _saveUserName(name);
    if (phone != null && phone.isNotEmpty) {
      await _saveUserPhone(phone);
    }
    notifyListeners();
  }

  // ============================================================
  // ✅ MÉTODOS DE CARGA
  // ============================================================

  Future<void> login({required String email, required String name, String? phone}) async {
    _userEmail = email;
    _userName = name;
    _userPhone = phone;
    _isLoggedIn = true;
    await loadSavedUserTypeForEmail(email);
    notifyListeners();
  }

  /// Cargar el teléfono guardado para un email específico
  Future<String?> loadUserPhone(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'user_phone_${_sanitizeEmail(email)}';
      final phone = prefs.getString(key);
      if (phone != null && phone.isNotEmpty) {
        _userPhone = phone;
        notifyListeners();
        debugPrint('✅ Teléfono cargado para $email: $phone');
        return phone;
      }
    } catch (e) {
      debugPrint('Error cargando teléfono: $e');
    }
    return null;
  }

  Future<UserType?> loadSavedUserTypeForEmail(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'user_type_${_sanitizeEmail(email)}';
      final index = prefs.getInt(key);
      if (index != null && index >= 0 && index < UserType.values.length) {
        _selectedUserType = UserType.values[index];
        _userEmail = email;

        // ✅ Cargar teléfono específico para este email
        final phoneKey = 'user_phone_${_sanitizeEmail(email)}';
        _userPhone = prefs.getString(phoneKey);
        if (_userPhone == null || _userPhone!.isEmpty) {
          _userPhone = prefs.getString('user_phone');
        }

        notifyListeners();
        return _selectedUserType;
      }
    } catch (e) {
      debugPrint('Error cargando tipo de usuario para email: $e');
    }
    return null;
  }

  Future<UserType?> loadSavedUserType() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final email = prefs.getString('user_email');
      if (email != null && email.isNotEmpty) {
        _userEmail = email;
        final key = 'user_type_${_sanitizeEmail(email)}';
        final index = prefs.getInt(key);
        if (index != null && index >= 0 && index < UserType.values.length) {
          _selectedUserType = UserType.values[index];
          _userName = prefs.getString('user_name');

          // ✅ Cargar teléfono específico para este email
          final phoneKey = 'user_phone_${_sanitizeEmail(email)}';
          _userPhone = prefs.getString(phoneKey);
          if (_userPhone == null || _userPhone!.isEmpty) {
            _userPhone = prefs.getString('user_phone');
          }

          _isLoggedIn = true;
          notifyListeners();
          return _selectedUserType;
        }
      }

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

  Future<void> logout() async {
    _selectedUserType = null;
    _userEmail = null;
    _userName = null;
    _userPhone = null;
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
      await prefs.setInt('user_type', type.index);

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

  Future<void> _saveUserPhone(String phone) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_userEmail != null && _userEmail!.isNotEmpty) {
        final key = 'user_phone_${_sanitizeEmail(_userEmail!)}';
        await prefs.setString(key, phone);
        debugPrint('✅ Teléfono guardado para email ${_userEmail}: $phone');
      } else {
        await prefs.setString('user_phone', phone);
        debugPrint('✅ Teléfono guardado globalmente: $phone');
      }
    } catch (e) {
      debugPrint('Error guardando teléfono: $e');
    }
  }

  /// Guardar teléfono para el email actual del usuario
  Future<void> saveUserPhoneForCurrentEmail(String phone) async {
    _userPhone = phone;
    await _saveUserPhone(phone);
    notifyListeners();
  }

  Future<void> _clearSavedUserType() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_type');
      if (_userEmail != null && _userEmail!.isNotEmpty) {
        final key = 'user_type_${_sanitizeEmail(_userEmail!)}';
        await prefs.remove(key);
        final phoneKey = 'user_phone_${_sanitizeEmail(_userEmail!)}';
        await prefs.remove(phoneKey);
      }
      await prefs.remove('user_email');
      await prefs.remove('user_name');
      await prefs.remove('user_phone');
      debugPrint('✅ Datos de usuario eliminados');
    } catch (e) {
      debugPrint('Error limpiando tipo de usuario: $e');
    }
  }

  // ============================================================
  // ✅ MÉTODOS DE UTILIDAD
  // ============================================================

  String _sanitizeEmail(String email) {
    return email.replaceAll('@', '_').replaceAll('.', '_');
  }

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

  /// ✅ CORREGIDO: Carga el teléfono correctamente
  Future<bool> checkLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email');
      if (email != null && email.isNotEmpty) {
        _userEmail = email;
        final key = 'user_type_${_sanitizeEmail(email)}';
        final index = prefs.getInt(key);
        if (index != null && index >= 0 && index < UserType.values.length) {
          _selectedUserType = UserType.values[index];
          _userName = prefs.getString('user_name');

          // ✅ Cargar teléfono específico para este email
          final phoneKey = 'user_phone_${_sanitizeEmail(email)}';
          _userPhone = prefs.getString(phoneKey);
          if (_userPhone == null || _userPhone!.isEmpty) {
            // Fallback al teléfono global
            _userPhone = prefs.getString('user_phone');
          }

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

  /// ✅ Método para verificar si el usuario tiene perfil completo
  bool hasCompleteProfile() {
    return _userPhone != null && _userPhone!.isNotEmpty;
  }
}