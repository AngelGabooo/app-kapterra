// lib/core/services/api_service.dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:kaabcafe/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;
  String? get token => _token;

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    debugPrint('✅ Token guardado');
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    if (_token != null) {
      debugPrint('✅ Token cargado');
    }
  }

  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    debugPrint('✅ Token eliminado');
  }

  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('${AppConstants.apiBaseUrl}$endpoint');
    debugPrint('🌐 GET: $url');
    return await http.get(url, headers: _headers);
  }

  Future<http.Response> post(String endpoint, {Map<String, dynamic>? body}) async {
    final url = Uri.parse('${AppConstants.apiBaseUrl}$endpoint');
    final bodyJson = body != null ? jsonEncode(body) : null;
    debugPrint('🌐 POST: $url');
    debugPrint('📤 Body: $bodyJson');
    return await http.post(
      url,
      headers: _headers,
      body: bodyJson,
    );
  }

  Future<http.Response> put(String endpoint, {Map<String, dynamic>? body}) async {
    final url = Uri.parse('${AppConstants.apiBaseUrl}$endpoint');
    final bodyJson = body != null ? jsonEncode(body) : null;
    debugPrint('🌐 PUT: $url');
    debugPrint('📤 Body: $bodyJson');
    return await http.put(
      url,
      headers: _headers,
      body: bodyJson,
    );
  }

  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('${AppConstants.apiBaseUrl}$endpoint');
    debugPrint('🌐 DELETE: $url');
    return await http.delete(url, headers: _headers);
  }
}