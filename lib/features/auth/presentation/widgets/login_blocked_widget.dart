// lib/features/auth/presentation/widgets/login_blocked_widget.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/services/login_attempt_service.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';

class LoginBlockedWidget extends StatelessWidget {
  final LoginAttemptService service;
  final VoidCallback onUnblocked;

  const LoginBlockedWidget({
    super.key,
    required this.service,
    required this.onUnblocked,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.brown.shade900;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.red.shade900.withOpacity(0.2) : Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.red.shade400.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            service.isPermanentlyBlocked ? Icons.lock_outline : Icons.timer_outlined,
            color: Colors.red.shade400,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            service.isPermanentlyBlocked
                ? '🔒 Cuenta Bloqueada'
                : '⏳ Demasiados intentos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            service.isPermanentlyBlocked
                ? 'Has excedido el número máximo de intentos.\nVerifica tu identidad con el PIN del dispositivo.'
                : 'Has excedido el número de intentos.\nEspera ${service.remainingSeconds} segundos para intentar de nuevo.\nIntentos acumulados: ${service.attempts}/6',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: textColor.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          if (service.isPermanentlyBlocked)
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    // ✅ Usar el método que fuerza el PIN
                    final success = await service.authenticateWithDevicePin();
                    if (success) {
                      onUnblocked();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('❌ Autenticación fallida. Intenta de nuevo.'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.security),
                  label: const Text('Verificar con PIN del dispositivo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    context.go(RouteNames.login);
                  },
                  child: Text(
                    'Cerrar sesión',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer,
                    color: Colors.red.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${service.remainingSeconds}s',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          if (!service.isPermanentlyBlocked)
            TextButton(
              onPressed: () {},
              child: Text(
                '¿Olvidaste tu contraseña?',
                style: TextStyle(
                  color: theme.colorScheme.tertiary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}