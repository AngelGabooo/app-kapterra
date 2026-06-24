import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:kaabcafe/core/constants/app_constants.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/login_logo.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/login_form.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/social_login_button.dart';

// Definición local del modelo para evitar conflictos de importación
class LoginModel {
  final String email;
  final String password;
  final bool rememberMe;

  LoginModel({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'rememberMe': rememberMe,
    };
  }
}

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

    try {
      final url = Uri.parse('${AppConstants.apiBaseUrl}/api/auth/login');

      final loginData = LoginModel(email: email, password: password, rememberMe: true);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginData.toJson()),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final token = responseBody['access_token'];

        debugPrint('¡Login exitoso! Token recibido: $token');
        // TODO: Aquí puedes guardar el token localmente (ej: SharedPreferences)

        if (mounted) {
          context.go(RouteNames.dashboard);
        }
      } else {
        final errorBody = jsonDecode(response.body);
        _showErrorSnackBar(errorBody['detail'] ?? 'Credenciales incorrectas');
      }
    } catch (e) {
      debugPrint('Error de red en Login: $e');
      _showErrorSnackBar('No se pudo conectar al servidor. Inténtalo de nuevo.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
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
                const SizedBox(height: 140),
                const LoginLogo(),
                const SizedBox(height: 36),

                _isLoading
                    ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(child: CircularProgressIndicator()),
                )
                    : LoginForm(
                  onLogin: _handleLogin,
                  onForgotPassword: _handleForgotPassword,
                ),

                const SizedBox(height: 24),
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
                SocialLoginButton(
                  text: 'Continuar con Google',
                  imageAsset: 'assets/img/google_logo.png',
                  onPressed: () {
                    if (!_isLoading) _handleGoogleLogin();
                  },
                ),
                const SizedBox(height: 48),
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
                      onPressed: _isLoading ? () {} : _handleRegister,
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
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}