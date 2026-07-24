// lib/core/services/google_sign_in_service.dart

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  static Future<GoogleSignInAccount?> signIn() async {
    try {
      // ✅ Cerrar sesión previa para forzar selección de cuenta
      await _googleSignIn.signOut();

      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      return account;
    } catch (error) {
      debugPrint('❌ Error en Google Sign-In: $error');
      return null;
    }
  }

  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint('❌ Error al cerrar sesión de Google: $e');
    }
  }

  static Future<Map<String, dynamic>> getUserData(GoogleSignInAccount account) async {
    try {
      final GoogleSignInAuthentication auth = await account.authentication;

      final Map<String, dynamic> userData = {
        'id': account.id,
        'email': account.email,
        'displayName': account.displayName ?? account.email,
        'photoUrl': account.photoUrl,
        'accessToken': auth.accessToken,
        'idToken': auth.idToken,
      };

      return userData;
    } catch (e) {
      debugPrint('❌ Error al obtener datos de usuario: $e');
      rethrow;
    }
  }

  static Future<bool> isSignedIn() async {
    try {
      return await _googleSignIn.isSignedIn();
    } catch (e) {
      return false;
    }
  }

  static Future<GoogleSignInAccount?> getCurrentUser() async {
    try {
      return await _googleSignIn.currentUser;
    } catch (e) {
      return null;
    }
  }
}