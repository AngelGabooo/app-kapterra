// lib/core/mixins/session_timeout_mixin.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/services/session_timeout_service.dart';

/// Mixin para agregar funcionalidad de timeout de sesión a cualquier StatefulWidget
///
/// Uso:
/// ```dart
/// class MyScreenState extends State<MyScreen> with SessionTimeoutMixin {
///   @override
///   void initState() {
///     super.initState();
///     initSessionTimeout(
///       onTimeout: () {
///         // Acción adicional cuando el timeout ocurre
///         print('Sesión expirada');
///       }
///     );
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: GestureDetector(
///         onTap: resetTimeout, // Reinicia el timer al tocar
///         child: ...,
///       ),
///     );
///   }
/// }
/// ```
mixin SessionTimeoutMixin<T extends StatefulWidget> on State<T> {
  SessionTimeoutService? _timeoutService;
  bool _timeoutInitialized = false;

  /// Inicializa el servicio de timeout
  ///
  /// [onTimeout] - Callback opcional que se ejecuta cuando ocurre el timeout
  /// [autoStart] - Si debe iniciar automáticamente (por defecto true)
  void initSessionTimeout({
    VoidCallback? onTimeout,
    bool autoStart = true,
  }) {
    if (_timeoutInitialized) return;

    _timeoutService = SessionTimeoutService(context, onTimeout: onTimeout);
    if (autoStart) {
      _timeoutService!.start();
    }
    _timeoutInitialized = true;
    debugPrint('✅ SessionTimeoutMixin inicializado');
  }

  /// Iniciar el temporizador
  void startTimeout() {
    _timeoutService?.start();
    debugPrint('▶️ Timer iniciado manualmente');
  }

  /// Reiniciar el temporizador (se llama en interacciones del usuario)
  void resetTimeout() {
    _timeoutService?.reset();
  }

  /// Pausar el temporizador (ej: al mostrar un diálogo)
  void pauseTimeout() {
    _timeoutService?.pause();
  }

  /// Reanudar el temporizador (ej: al cerrar un diálogo)
  void resumeTimeout() {
    _timeoutService?.resume();
  }

  /// Detener y limpiar el temporizador
  void disposeTimeout() {
    _timeoutService?.dispose();
    _timeoutService = null;
    _timeoutInitialized = false;
  }

  /// Verificar si el timeout está activo
  bool get isTimeoutActive => _timeoutService?.isActive ?? false;

  /// Verificar si el timeout está pausado
  bool get isTimeoutPaused => _timeoutService?.isPaused ?? false;

  @override
  void dispose() {
    disposeTimeout();
    super.dispose();
  }
}