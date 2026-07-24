// lib/core/services/session_timeout_service.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/providers/user_provider.dart';
import 'package:kaabcafe/core/routes/route_names.dart';

class SessionTimeoutService extends WidgetsBindingObserver {
  static const Duration timeoutDuration = Duration(minutes: 5);

  Timer? _timer;
  final BuildContext context;
  final VoidCallback? onTimeout;

  // Estado del servicio
  bool _isAppInBackground = false;
  bool _timeoutExecuted = false;
  DateTime? _lastInteractionTime;
  bool _isActive = false;

  // Controlar si el timer está en pausa manual
  bool _isPaused = false;

  SessionTimeoutService(this.context, {this.onTimeout}) {
    // ✅ Registrar como observer del ciclo de vida de la app
    WidgetsBinding.instance.addObserver(this);
  }

  /// Iniciar el temporizador
  void start() {
    if (_isActive) return;

    _isActive = true;
    _timeoutExecuted = false;
    _isPaused = false;
    _lastInteractionTime = DateTime.now();
    _resetTimer();
    debugPrint('⏱️ Timer de sesión iniciado');
  }

  /// Reiniciar el temporizador (se llama en cada interacción del usuario)
  void reset() {
    if (!_isActive || _timeoutExecuted || _isPaused || _isAppInBackground) return;

    _lastInteractionTime = DateTime.now();
    _resetTimer();
  }

  void _resetTimer() {
    if (!_isActive || _isPaused || _isAppInBackground) return;

    _timer?.cancel();
    _timer = Timer(timeoutDuration, _handleTimeout);
  }

  /// Manejar el timeout - cerrar sesión
  void _handleTimeout() {
    if (_isPaused || _isAppInBackground || _timeoutExecuted || !_isActive) return;

    // ✅ Verificar si realmente hubo inactividad
    if (_lastInteractionTime != null) {
      final inactiveTime = DateTime.now().difference(_lastInteractionTime!);
      if (inactiveTime < timeoutDuration) {
        // Si el usuario interactuó recientemente, reiniciar
        _resetTimer();
        return;
      }
    }

    _timeoutExecuted = true;
    _isActive = false;

    debugPrint('⏰ Timeout de sesión ejecutado');

    try {
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
      debugPrint('❌ Error en timeout: $e');
    }
  }

  /// ✅ Detectar cuando la app va a segundo plano
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // App en segundo plano - pausar timer
      _isAppInBackground = true;
      _timer?.cancel();
      debugPrint('⏸️ App en segundo plano - Timer pausado');
    } else if (state == AppLifecycleState.resumed) {
      // App vuelve a primer plano - reanudar timer
      _isAppInBackground = false;
      if (!_isPaused && _isActive && !_timeoutExecuted) {
        _lastInteractionTime = DateTime.now();
        _resetTimer();
        debugPrint('▶️ App en primer plano - Timer reanudado');
      }
    }
  }

  /// Pausar el temporizador manualmente (ej: al mostrar un diálogo)
  void pause() {
    if (!_isActive) return;
    _isPaused = true;
    _timer?.cancel();
    debugPrint('⏸️ Timer pausado manualmente');
  }

  /// Reanudar el temporizador manualmente (ej: al cerrar un diálogo)
  void resume() {
    if (!_isActive || _timeoutExecuted) return;
    _isPaused = false;
    if (!_isAppInBackground) {
      _lastInteractionTime = DateTime.now();
      _resetTimer();
      debugPrint('▶️ Timer reanudado manualmente');
    }
  }

  /// Detener y limpiar el temporizador
  void dispose() {
    _isActive = false;
    _timer?.cancel();
    _timer = null;
    WidgetsBinding.instance.removeObserver(this);
    debugPrint('🗑️ Timer de sesión eliminado');
  }

  /// Verificar si el temporizador está activo
  bool get isActive => _timer?.isActive ?? false;

  bool get isPaused => _isPaused || _isAppInBackground;
}