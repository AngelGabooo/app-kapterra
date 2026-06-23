import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/login_logo.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/login_form.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  void _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    debugPrint('Login intentado con: $email');
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      context.go(RouteNames.dashboard);
    }
  }

  void _handleGoogleLogin() async {
    setState(() {
      _isLoading = true;
    });

    debugPrint('Google login intentado');
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      context.go(RouteNames.dashboard);
    }
  }

  void _handleRegister() => context.go(RouteNames.register);
  void _handleForgotPassword() => context.go(RouteNames.forgotPassword);

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
          // Eliminamos el Stack para que no haya elementos flotantes rígidos
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── CONTROL DE CAÍDA INICIAL ───
                // Mantengo los 140 píxeles para que empiece bien abajo en la pantalla
                const SizedBox(height: 140),

                // Logo y títulos de Kaab Terra
                const LoginLogo(),

                const SizedBox(height: 36),

                // Formulario (Inputs de Email, Password y botón Iniciar Sesión)
                LoginForm(
                  onLogin: _handleLogin,
                  onForgotPassword: _handleForgotPassword,
                ),

                const SizedBox(height: 24),

                // Separador "o continuar con"
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: theme.colorScheme.onSurface.withOpacity(0.15), thickness: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'o continuar con',
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

                // Botón de Google (Ahora se moverá perfectamente con el scroll general)
                SocialLoginButton(
                  text: 'Continuar con Google',
                  imageAsset: 'assets/img/google_logo.png', // 🚀 Pásale la ruta de tu PNG oficial
                  onPressed: _handleGoogleLogin,
                ),

                const SizedBox(height: 48), // Separación elegante antes del cierre

                // ── ENLACE A REGISTRO INTEGRADO AL SCROLL ───
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿No tienes una cuenta? ',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextButton(
                      onPressed: _handleRegister,
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.tertiary,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Crear cuenta',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32), // Colchón de espacio final para que respire al scrollear
              ],
            ),
          ),
        ),
      ),
    );
  }
}