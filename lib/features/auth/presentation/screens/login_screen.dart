// lib/features/auth/presentation/screens/login_screen.dart

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/constants/app_constants.dart';
import 'package:kaabcafe/core/providers/user_provider.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/mixins/session_timeout_mixin.dart';
import 'package:kaabcafe/core/services/login_attempt_service.dart';
import 'package:kaabcafe/core/services/google_sign_in_service.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/login_logo.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/login_form.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/social_login_button.dart';

import '../../../../core/themes/app_theme.dart';
import '../../data/models/user_type_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SessionTimeoutMixin {
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final service = Provider.of<LoginAttemptService>(context, listen: false);
      if (service.isPermanentlyBlocked) {
        context.go(RouteNames.pinSecurity);
      }
    });
  }

  Future<void> _handleLogin(String email, String password) async {
    final service = Provider.of<LoginAttemptService>(context, listen: false);

    if (service.isPermanentlyBlocked) {
      context.go(RouteNames.pinSecurity);
      return;
    }

    if (service.isBlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⛔ Cuenta bloqueada temporalmente. Espera unos segundos.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    debugPrint('Login intentado con: $email');

    try {
      final url = Uri.parse('${AppConstants.apiBaseUrl}/api/auth/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final userData = responseData['user'] ?? {};
        final userName = userData['fullName'] ?? userData['name'] ?? 'Usuario';

        await service.resetBlock();

        if (mounted) {
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          final userType = await userProvider.loadSavedUserTypeForEmail(email);

          if (userType == null) {
            userProvider.setUserEmail(email);
            context.go(RouteNames.selectUserType);
            return;
          }

          await userProvider.loadUserPhone(email);
          final currentPhone = userProvider.userPhone;

          userProvider.setUserInfo(
            type: userType,
            email: email,
            name: userName,
            phone: currentPhone,
          );

          String destinationRoute;

          if (userType == UserType.producer &&
              (currentPhone == null || currentPhone.isEmpty)) {
            destinationRoute = RouteNames.setupProfile;
          } else {
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
              case UserType.technician:
                destinationRoute = RouteNames.technicianDashboard;
                break;
              default:
                destinationRoute = RouteNames.selectUserType;
            }
          }

          debugPrint('✅ Navegando a: $destinationRoute');
          debugPrint('📞 Teléfono del usuario: ${userProvider.userPhone}');
          context.go(destinationRoute);
        }
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage = errorBody['message'] ?? errorBody['detail'] ?? 'Credenciales incorrectas';

        final (isBlocked, isPermanentlyBlocked, remaining) = await service.registerFailedAttempt();

        if (mounted) {
          if (isPermanentlyBlocked) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('🔒 Cuenta bloqueada. Verifica tu identidad con el PIN.'),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 2),
              ),
            );
            context.go(RouteNames.pinSecurity);
            return;
          }

          if (isBlocked) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('⏳ Demasiados intentos. Espera ${remaining ?? 30}s. Intentos: ${service.attempts}/6'),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 3),
              ),
            );
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '❌ $errorMessage. Intentos restantes: ${6 - service.attempts}',
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('⚠️ Error de conexión: ${e.toString()}'),
            backgroundColor: Colors.red.shade700,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // ✅ MÉTODO PARA LOGIN CON GOOGLE - MEJORADO
  Future<void> _handleGoogleLogin() async {
    final service = Provider.of<LoginAttemptService>(context, listen: false);

    if (service.isPermanentlyBlocked) {
      context.go(RouteNames.pinSecurity);
      return;
    }

    if (service.isBlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⛔ Cuenta bloqueada temporalmente.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isGoogleLoading = true;
    });

    try {
      // ✅ 1. Verificar si Google Play Services está disponible
      try {
        await GoogleSignInService.isSignedIn();
      } catch (e) {
        setState(() {
          _isGoogleLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google Play Services no está disponible.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // ✅ 2. Iniciar sesión con Google
      final account = await GoogleSignInService.signIn();

      if (account == null) {
        setState(() {
          _isGoogleLoading = false;
        });
        return; // Usuario canceló
      }

      // ✅ 3. Obtener datos del usuario
      final userData = await GoogleSignInService.getUserData(account);
      final email = userData['email'] ?? '';
      final displayName = userData['displayName'] ?? 'Usuario Google';
      final idToken = userData['idToken'] ?? '';

      debugPrint('✅ Google Sign-In exitoso: $email');
      debugPrint('✅ Nombre: $displayName');

      // ✅ 4. Intentar autenticar con el backend
      try {
        final url = Uri.parse('${AppConstants.apiBaseUrl}/api/auth/google');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'idToken': idToken,
            'email': email,
            'name': displayName,
          }),
        ).timeout(const Duration(seconds: 10));

        setState(() {
          _isGoogleLoading = false;
        });

        if (response.statusCode == 200 || response.statusCode == 201) {
          // ✅ Login exitoso con Google
          await _handleGoogleLoginSuccess(email, displayName);
        } else {
          // ❌ Error en el backend
          String errorMessage = 'Error al autenticar con Google.';
          try {
            final errorBody = jsonDecode(response.body);
            errorMessage = errorBody['message'] ?? errorMessage;
          } catch (_) {}

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ $errorMessage'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isGoogleLoading = false;
        });

        // ✅ Si el backend no está disponible, hacer login local con los datos de Google
        debugPrint('⚠️ Backend no disponible, usando login local con Google');
        await _handleGoogleLoginSuccess(email, displayName);
      }
    } catch (e) {
      setState(() {
        _isGoogleLoading = false;
      });

      debugPrint('❌ Error en Google Login: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al iniciar sesión con Google: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ✅ Método auxiliar para manejar el login exitoso con Google
  Future<void> _handleGoogleLoginSuccess(String email, String displayName) async {
    if (!mounted) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userType = await userProvider.loadSavedUserTypeForEmail(email);

    // ✅ Guardar usuario en el provider
    await userProvider.loadUserPhone(email);
    final currentPhone = userProvider.userPhone;

    userProvider.setUserInfo(
      type: userType ?? UserType.producer,
      email: email,
      name: displayName,
      phone: currentPhone,
    );

    String destinationRoute;

    // ✅ Verificar si el usuario ya tiene teléfono
    if (userType == UserType.producer &&
        (currentPhone == null || currentPhone.isEmpty)) {
      destinationRoute = RouteNames.setupProfile;
    } else {
      switch (userType ?? UserType.producer) {
        case UserType.producer:
          destinationRoute = RouteNames.dashboard;
          break;
        case UserType.cooperative:
          destinationRoute = RouteNames.cooperativeDashboard;
          break;
        case UserType.buyer:
          destinationRoute = RouteNames.marketplace;
          break;
        case UserType.technician:
          destinationRoute = RouteNames.technicianDashboard;
          break;
        default:
          destinationRoute = RouteNames.selectUserType;
      }
    }

    debugPrint('✅ Google Login - Navegando a: $destinationRoute');

    // ✅ Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Inicio de sesión con Google exitoso'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    context.go(destinationRoute);
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
    final isDark = theme.brightness == Brightness.dark;

    final creamColor = isDark
        ? AppTheme.coffeeDeep
        : const Color(0xFFF0E8D8);
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: creamColor,
            ),
          ),
          Positioned.fill(
            child: _AuroraBackground(
              theme: theme,
              creamColor: creamColor,
            ),
          ),
          SafeArea(
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
                        child: Divider(color: textColor.withOpacity(0.15)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'o continuar con',
                          style: TextStyle(
                            color: textColor.withOpacity(0.5),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: textColor.withOpacity(0.15)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SocialLoginButton(
                    text: _isGoogleLoading ? 'Cargando...' : 'Continuar con Google',
                    imageAsset: 'assets/img/google_logo.png',
                    onPressed: _isGoogleLoading ? null : _handleGoogleLogin,
                    isLoading: _isGoogleLoading,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿No tienes una cuenta? ',
                        style: TextStyle(
                          color: textColor.withOpacity(0.7),
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
        ],
      ),
    );
  }
}

class _AuroraBackground extends StatelessWidget {
  final ThemeData theme;
  final Color creamColor;

  const _AuroraBackground({
    required this.theme,
    required this.creamColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;

    return ClipRect(
      child: Stack(
        children: [
          Positioned(
            top: -110,
            left: -90,
            child: _blob(theme.colorScheme.primary, 280, isDark ? 0.22 : 0.30),
          ),
          Positioned(
            top: 60,
            right: -110,
            child: _blob(theme.colorScheme.tertiary, 240, isDark ? 0.16 : 0.24),
          ),
          Positioned(
            bottom: -150,
            left: -70,
            child: _blob(theme.colorScheme.secondary, 300, isDark ? 0.14 : 0.20),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(
                color: creamColor.withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _blob(Color color, double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(opacity), color.withOpacity(0)],
        ),
      ),
    );
  }
}