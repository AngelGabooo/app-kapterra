// lib/features/auth/presentation/screens/pin_security_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/services/login_attempt_service.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:go_router/go_router.dart';

class PinSecurityScreen extends StatefulWidget {
  const PinSecurityScreen({super.key});

  @override
  State<PinSecurityScreen> createState() => _PinSecurityScreenState();
}

class _PinSecurityScreenState extends State<PinSecurityScreen> {
  final List<int> _pin = [];
  String _errorMessage = '';
  bool _isLoading = false;
  int _attempts = 0;
  static const int _maxPinAttempts = 3;

  bool _hasFingerprint = false;
  bool _hasFace = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final service = Provider.of<LoginAttemptService>(context, listen: false);
      if (!service.isPermanentlyBlocked) {
        context.go(RouteNames.login);
      }
      _checkAuthMethods(service);
    });
  }

  void _checkAuthMethods(LoginAttemptService service) async {
    final methods = await service.getAvailableAuthMethods();
    if (mounted) {
      setState(() {
        _hasFingerprint = methods['hasFingerprint'] ?? false;
        _hasFace = methods['hasFace'] ?? false;
      });
    }
  }

  String _getAuthMessage() {
    if (_hasFingerprint && _hasFace) {
      return 'Usa tu huella, Face ID o PIN del dispositivo (1-6)';
    } else if (_hasFingerprint) {
      return 'Usa tu huella o PIN del dispositivo (1-6)';
    } else if (_hasFace) {
      return 'Usa tu Face ID o PIN del dispositivo (1-6)';
    } else {
      return 'Ingresa tu PIN de seguridad (1-6)';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final service = Provider.of<LoginAttemptService>(context);

    return Scaffold(
      backgroundColor: isDark ? Colors.grey.shade900 : const Color(0xFFF5F0E8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.shade400,
                      Colors.orange.shade700,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.shade300.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  _hasFingerprint ? Icons.fingerprint :
                  _hasFace ? Icons.face :
                  Icons.lock_outline,
                  size: 36,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),

              // Título
              Text(
                'Verificación de Seguridad',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.brown.shade900,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _getAuthMessage(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),

              // Intentos restantes
              if (_attempts > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Text(
                      'Intentos restantes: ${_maxPinAttempts - _attempts}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 28),

              // Círculos del PIN
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  final bool isFilled = index < _pin.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 44,
                    height: 52,
                    decoration: BoxDecoration(
                      color: isDark
                          ? (isFilled ? Colors.grey.shade700 : Colors.grey.shade800)
                          : (isFilled ? Colors.orange.shade100 : Colors.white),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isFilled
                            ? Colors.orange.shade400
                            : isDark ? Colors.grey.shade600 : Colors.grey.shade300,
                        width: isFilled ? 2 : 1.5,
                      ),
                    ),
                    child: Center(
                      child: isFilled
                          ? Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange.shade500,
                              Colors.orange.shade700,
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                      )
                          : null,
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),

              // Mensaje de error
              if (_errorMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.shade200, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700, size: 16),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          _errorMessage,
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              // ✅ Botón para abrir el sistema de autenticación del dispositivo
              ElevatedButton.icon(
                onPressed: _isLoading ? null : () => _verifyWithDevicePin(service),
                icon: Icon(
                  Icons.security,
                  size: 20,
                  color: Colors.white,
                ),
                label: const Text(
                  'Verificar con PIN del dispositivo',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),

              const SizedBox(height: 16),

              // Botón de cerrar sesión
              TextButton.icon(
                onPressed: () {
                  context.go(RouteNames.login);
                },
                icon: Icon(
                  Icons.logout_outlined,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  size: 16,
                ),
                label: Text(
                  'Cerrar sesión',
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Verificar con el PIN del dispositivo usando el sistema nativo
  Future<void> _verifyWithDevicePin(LoginAttemptService service) async {
    if (_isLoading) return;

    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });

    // ✅ Usar el método que fuerza el PIN del dispositivo
    final success = await service.authenticateWithDevicePin();

    setState(() {
      _isLoading = false;
    });

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Cuenta desbloqueada exitosamente'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        context.go(RouteNames.login);
      }
    } else {
      _attempts++;
      if (_attempts >= _maxPinAttempts) {
        setState(() {
          _errorMessage = '❌ Demasiados intentos. Redirigiendo...';
          _pin.clear();
        });
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            context.go(RouteNames.login);
          }
        });
      } else {
        setState(() {
          _errorMessage = '❌ Autenticación fallida. Intenta de nuevo.';
          _pin.clear();
        });
      }
    }
  }
}