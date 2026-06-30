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

  // ✅ Guardar el rol seleccionado durante el registro
  void setUserType(UserType type) {
    _selectedUserType = type;
    _saveUserType(type);
    notifyListeners();
  }

  // ✅ Guardar información completa del usuario
  void setUserInfo({
    required UserType type,
    required String email,
    required String name,
  }) {
    _selectedUserType = type;
    _userEmail = email;
    _userName = name;
    _isLoggedIn = true;
    _saveUserType(type);
    _saveUserEmail(email);
    _saveUserName(name);
    notifyListeners();
  }

  // ✅ Iniciar sesión (recuperar datos guardados del usuario)
  Future<void> login({required String email, required String name}) async {
    _userEmail = email;
    _userName = name;
    _isLoggedIn = true;
    // ✅ Cargar el tipo de usuario guardado para este email
    await loadSavedUserTypeForEmail(email);
    notifyListeners();
  }

  // ✅ Cargar el tipo de usuario guardado para un email específico
  Future<UserType?> loadSavedUserTypeForEmail(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'user_type_${email.replaceAll('@', '_').replaceAll('.', '_')}';
      final index = prefs.getInt(key);
      if (index != null && index >= 0 && index < UserType.values.length) {
        _selectedUserType = UserType.values[index];
        notifyListeners();
        return _selectedUserType;
      }
    } catch (e) {
      debugPrint('Error cargando tipo de usuario para email: $e');
    }
    return null;
  }

  // ✅ Cerrar sesión
  Future<void> logout() async {
    _selectedUserType = null;
    _userEmail = null;
    _userName = null;
    _isLoggedIn = false;
    await _clearSavedUserType();
    notifyListeners();
  }

  // ✅ Persistencia local (SharedPreferences)
  Future<void> _saveUserType(UserType type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Guardar el rol general
      await prefs.setInt('user_type', type.index);

      // Si tenemos email, guardar el rol específico para ese usuario
      if (_userEmail != null) {
        final key = 'user_type_${_userEmail!.replaceAll('@', '_').replaceAll('.', '_')}';
        await prefs.setInt(key, type.index);
      }
    } catch (e) {
      debugPrint('Error guardando tipo de usuario: $e');
    }
  }

  Future<void> _saveUserEmail(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', email);
    } catch (e) {
      debugPrint('Error guardando email: $e');
    }
  }

  Future<void> _saveUserName(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', name);
    } catch (e) {
      debugPrint('Error guardando nombre: $e');
    }
  }

  Future<void> _clearSavedUserType() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_type');
      if (_userEmail != null) {
        final key = 'user_type_${_userEmail!.replaceAll('@', '_').replaceAll('.', '_')}';
        await prefs.remove(key);
      }
      await prefs.remove('user_email');
      await prefs.remove('user_name');
    } catch (e) {
      debugPrint('Error limpiando tipo de usuario: $e');
    }
  }

  // ✅ Cargar tipo de usuario guardado (para cuando la app se reinicia)
  Future<UserType?> loadSavedUserType() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Intentar cargar el email guardado primero
      final email = prefs.getString('user_email');
      if (email != null) {
        _userEmail = email;
        final key = 'user_type_${email.replaceAll('@', '_').replaceAll('.', '_')}';
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

  // ✅ Obtener la ruta destino según el rol
  String getDestinationRoute() {
    switch (_selectedUserType) {
      case UserType.producer:
        return RouteNames.dashboard;
      case UserType.cooperative:
        return RouteNames.cooperativeDashboard;
      case UserType.buyer:
        return RouteNames.marketplace;
      case UserType.technician:
        return RouteNames.dashboard;
      default:
        return RouteNames.dashboard;
    }
  }
}