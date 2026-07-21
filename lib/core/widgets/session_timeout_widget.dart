// lib/core/widgets/session_timeout_widget.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/services/session_timeout_service.dart';

/// Widget que envuelve toda la app para detectar inactividad
class SessionTimeoutWidget extends StatefulWidget {
  final Widget child;
  final Duration? timeoutDuration; // Permitir personalizar el tiempo

  const SessionTimeoutWidget({
    super.key,
    required this.child,
    this.timeoutDuration,
  });

  @override
  State<SessionTimeoutWidget> createState() => _SessionTimeoutWidgetState();
}

class _SessionTimeoutWidgetState extends State<SessionTimeoutWidget> {
  SessionTimeoutService? _timeoutService;

  @override
  void initState() {
    super.initState();
    // Inicializar después del primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _timeoutService = SessionTimeoutService(
          context,
          onTimeout: _onGlobalTimeout,
        );
        _timeoutService!.start();
      }
    });
  }

  void _onGlobalTimeout() {
    // El servicio ya maneja el logout, pero podemos agregar lógica extra
    debugPrint('⏰ Sesión expirada globalmente');
  }

  @override
  void dispose() {
    _timeoutService?.dispose();
    super.dispose();
  }

  /// Detectar cualquier interacción del usuario
  void _handleUserInteraction() {
    _timeoutService?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleUserInteraction,
      onPanDown: (_) => _handleUserInteraction(),
      onScaleStart: (_) => _handleUserInteraction(),
      child: Listener(
        onPointerDown: (_) => _handleUserInteraction(),
        onPointerMove: (_) => _handleUserInteraction(),
        child: widget.child,
      ),
    );
  }
}