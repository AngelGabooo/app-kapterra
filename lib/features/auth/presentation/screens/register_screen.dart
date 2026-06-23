import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/register_form.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/social_login_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  void _handleRegister(RegisterData data) async {
    // La lógica de negocio la maneja tu vista de forma asíncrona
    if (mounted) {
      context.go(RouteNames.selectUserType);
    }
  }

  void _handleGoogleRegister() async {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Registro con Google'),
          content: const Text('Funcionalidad en desarrollo. Próximamente disponible.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  }

  void _goToLogin() {
    context.go(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.scaffoldBackgroundColor,
              theme.colorScheme.primary.withOpacity(0.04),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: IconButton(
                      onPressed: _goToLogin,
                      icon: const Icon(Icons.arrow_back),
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),

                // 🚨 CAÍDA CONTROLADA DE ALTURA
                // Alineado perfectamente con la distribución baja de tu LoginScreen
                const SizedBox(height: 24),

                Text(
                  'Crea tu cuenta',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Empieza a gestionar y dar trazabilidad a tu producción de café.',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),

                const SizedBox(height: 36),

                // Formulario desacoplado de colores fijos
                RegisterForm(onRegister: _handleRegister),

                // Separador dinámico
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: theme.colorScheme.onSurface.withOpacity(0.15), thickness: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'o registrarse con',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: theme.colorScheme.onSurface.withOpacity(0.15), thickness: 1),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Botón Google Oficial (Usa la firma optimizada de 'imageAsset')
                SocialLoginButton(
                  text: 'Continuar con Google',
                  imageAsset: 'assets/img/google_logo.png',
                  onPressed: _handleGoogleRegister,
                ),

                const SizedBox(height: 36),

                // Footer de navegación enlazado al árbol del scroll
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿Ya tienes una cuenta? ',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextButton(
                      onPressed: _goToLogin,
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.tertiary,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}