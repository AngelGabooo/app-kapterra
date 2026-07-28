// lib/core/services/auth_service.dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:kaabcafe/core/services/api_service.dart';
import 'package:kaabcafe/features/auth/data/models/api_user_model.dart';
import 'package:kaabcafe/features/auth/data/models/login_response_model.dart';
import 'package:kaabcafe/features/auth/data/models/register_request_model.dart';
import 'package:kaabcafe/features/auth/data/models/login_request_model.dart';
import 'package:kaabcafe/features/auth/data/models/update_profile_request_model.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<ApiUserModel> register(RegisterRequestModel request) async {
    try {
      debugPrint('📤 Registrando usuario en API: ${request.email}');
      final response = await _apiService.post(
        '/api/auth/register',
        body: request.toJson(),
      );

      debugPrint('📥 Código de respuesta: ${response.statusCode}');
      debugPrint('📥 Cuerpo de respuesta: ${response.body}');

      if (response.statusCode == 201) {
        try {
          final data = jsonDecode(response.body);
          return ApiUserModel.fromJson(data);
        } catch (e) {
          debugPrint('❌ Error al decodificar JSON: $e');
          debugPrint('📥 Respuesta cruda: ${response.body}');
          throw Exception('Error al procesar la respuesta del servidor');
        }
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Error en el registro');
      }
    } catch (e) {
      debugPrint('❌ Error en registro: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      debugPrint('📤 Iniciando sesión: ${request.email}');
      final response = await _apiService.post(
        '/api/auth/login',
        body: request.toJson(),
      );

      debugPrint('📥 Código de respuesta: ${response.statusCode}');
      debugPrint('📥 Cuerpo de respuesta: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          final loginResponse = LoginResponseModel.fromJson(data);
          await _apiService.setToken(loginResponse.accessToken);
          return loginResponse;
        } catch (e) {
          debugPrint('❌ Error al decodificar JSON: $e');
          throw Exception('Error al procesar la respuesta del servidor');
        }
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Credenciales incorrectas');
      }
    } catch (e) {
      debugPrint('❌ Error en login: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  Future<void> updateProfile(UpdateProfileRequestModel request) async {
    try {
      debugPrint('📤 Actualizando perfil: ${request.email}');
      debugPrint('📤 Datos: ${request.toJson()}');

      final response = await _apiService.put(
        '/api/auth/profile',
        body: request.toJson(),
      );

      debugPrint('📥 Código de respuesta: ${response.statusCode}');
      debugPrint('📥 Cuerpo de respuesta: ${response.body}');

      if (response.statusCode != 200) {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Error al actualizar el perfil');
      }
    } catch (e) {
      debugPrint('❌ Error al actualizar perfil: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    await _apiService.clearToken();
  }

  Future<bool> hasValidToken() async {
    await _apiService.loadToken();
    return _apiService.token != null;
  }
}