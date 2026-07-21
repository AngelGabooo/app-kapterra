// lib/core/services/session_timeout_service.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart'; // ✅ IMPORTANTE: Agregar este import
import 'package:kaabcafe/core/providers/user_provider.dart';
import 'package:kaabcafe/core/routes/route_names.dart';

class SessionTimeoutService {
  static const Duration timeoutDuration = Duration(seconds: 15);

  Timer? _timer;
  final BuildContext context;
  final VoidCallback? onTimeout;

  // Para rastrear si el usuario está en una pantalla que debe ignorar el timeout
  bool _isPaused = false;

  // Controlar si ya se ejecutó el timeout para evitar múltiples ejecuciones
  bool _timeoutExecuted = false;

  SessionTimeoutService(this.context, {this.onTimeout});

  /// Iniciar el temporizador
  void start() {
    _timeoutExecuted = false;
    _resetTimer();
  }

  /// Reiniciar el temporizador (se llama en cada interacción del usuario)
  void reset() {
    if (!_isPaused && !_timeoutExecuted) {
      _resetTimer();
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer(timeoutDuration, _handleTimeout);
  }

  /// Manejar el timeout - cerrar sesión
  void _handleTimeout() {
    if (_isPaused || _timeoutExecuted) return;

    _timeoutExecuted = true;

    try {
      // ✅ CORREGIDO: Usar Provider.of (con P mayúscula)
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.logout();

      // Navegar al login
      context.go(RouteNames.login);

      // Mostrar mensaje de sesión expirada
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⏰ Tu sesión ha expirado por inactividad'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );

      onTimeout?.call();
    } catch (e) {
      debugPrint('Error en timeout: $e');
    }
  }

  /// Pausar el temporizador (ej: cuando se muestra un modal o en login)
  void pause() {
    _isPaused = true;
    _timer?.cancel();
  }

  /// Reanudar el temporizador
  void resume() {
    _isPaused = false;
    _timeoutExecuted = false;
    _resetTimer();
  }

  /// Detener y limpiar el temporizador
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }

  /// Verificar si el temporizador está activo
  bool get isActive => _timer?.isActive ?? false;

  bool get isPaused => _isPaused;
}