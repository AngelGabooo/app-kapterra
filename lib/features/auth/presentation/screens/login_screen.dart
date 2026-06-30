import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/providers/user_provider.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/login_logo.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/login_form.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/social_login_button.dart';

import '../../data/models/user_type_model.dart';

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

    // Simular proceso de login
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // ✅ Buscar el rol guardado para este email específico
      final userType = await userProvider.loadSavedUserTypeForEmail(email);

      // ✅ Si no tiene rol, usar el rol general
      final type = userType ?? userProvider.selectedUserType;

      // ✅ Si aún no hay rol, ir a seleccionar perfil
      if (type == null) {
        context.go(RouteNames.selectUserType);
        return;
      }

      // ✅ Guardar información del usuario
      userProvider.setUserInfo(
        type: type,
        email: email,
        name: 'Usuario', // Puedes obtener el nombre del backend
      );

      // ✅ Navegar según el rol
      String destinationRoute;
      switch (type) {
        case UserType.producer:
          destinationRoute = RouteNames.dashboard;
          break;
        case UserType.cooperative:
          destinationRoute = RouteNames.cooperativeDashboard;
          break;
        case UserType.buyer:
          destinationRoute = RouteNames.marketplace;
          break;
        default:
          destinationRoute = RouteNames.dashboard;
      }
      context.go(destinationRoute);
    }
  }

  void _handleGoogleLogin() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userType = userProvider.selectedUserType;

      if (userType == null) {
        context.go(RouteNames.selectUserType);
        return;
      }

      String destinationRoute;
      switch (userType) {
        case UserType.producer:
          destinationRoute = RouteNames.dashboard;
          break;
        case UserType.cooperative:
          destinationRoute = RouteNames.cooperativeDashboard;
          break;
        case UserType.buyer:
          destinationRoute = RouteNames.marketplace;
          break;
        default:
          destinationRoute = RouteNames.dashboard;
      }
      context.go(destinationRoute);
    }
  }

  void _handleRegister() {
    context.go(RouteNames.register);
  }

  void _handleForgotPassword() {
    context.go(RouteNames.forgotPassword);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.scaffoldBackgroundColor,
              theme.colorScheme.primary.withOpacity(0.03),
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
                const SizedBox(height: 40),
                const LoginLogo(),
                const SizedBox(height: 48),
                LoginForm(
                  onLogin: _handleLogin,
                  onForgotPassword: _handleForgotPassword,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: theme.colorScheme.onSurface.withOpacity(0.15)),
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
                      child: Divider(color: theme.colorScheme.onSurface.withOpacity(0.15)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SocialLoginButton(
                  text: 'Continuar con Google',
                  imageAsset: 'assets/img/google_logo.png',
                  onPressed: _handleGoogleLogin,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿No tienes una cuenta? ',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: _handleRegister,
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.tertiary,
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
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}