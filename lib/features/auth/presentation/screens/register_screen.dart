// lib/features/auth/presentation/screens/register_screen.dart
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/constants/app_constants.dart';
import 'package:kaabcafe/core/providers/user_provider.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';
import 'package:kaabcafe/features/auth/data/models/user_type_model.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/register_form.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/social_login_button.dart';
import '../widgets/neumorphic_box.dart' hide NeumorphicBox;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isLoading = false;

  void _handleRegister(RegisterData data) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final url = Uri.parse('${AppConstants.apiBaseUrl}/api/auth/register');
      final bodyMap = {
        'fullName': data.fullName,
        'email': data.email,
        'phoneNumber': data.phoneNumber,
        'password': data.password,
        'acceptTerms': data.acceptTerms,
      };
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyMap),
      );
      if (response.statusCode == 201) {
        debugPrint('Usuario registrado con éxito en la nube.');

        // ✅ GUARDAR EN USERPROVIDER CON EL TELÉFONO
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.setUserInfo(
          type: UserType.producer, // ⚠️ Temporal, luego se seleccionará
          email: data.email,
          name: data.fullName,
          phone: data.phoneNumber, // ✅ PASAR EL TELÉFONO
        );

        debugPrint('✅ Teléfono guardado en UserProvider: ${data.phoneNumber}');

        if (mounted) {
          context.go(RouteNames.selectUserType);
        }
      } else {
        final errorBody = jsonDecode(response.body);
        _showSnackBar(errorBody['detail'] ?? 'Error al registrar el usuario', isError: true);
      }
    } catch (e) {
      debugPrint('Error de red en Registro: $e');
      _showSnackBar('Error de conexión con el servidor', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleGoogleRegister() async {
    if (mounted) {
      final theme = Theme.of(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: theme.colorScheme.surface,
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

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : Colors.green,
      ),
    );
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
            child: Container(color: creamColor),
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: _isLoading ? null : _goToLogin,
                        child: NeumorphicBox(
                          borderRadius: 16,
                          intensity: 4,
                          padding: const EdgeInsets.all(10),
                          isDark: isDark,
                          child: Icon(
                            Icons.arrow_back,
                            color: theme.colorScheme.onSurface,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
                    ).createShader(bounds),
                    child: Text(
                      'Crea tu cuenta',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Empieza a gestionar y dar trazabilidad a tu producción de café.',
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 36),
                  _isLoading
                      ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                      : RegisterForm(onRegister: _handleRegister),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: textColor.withOpacity(0.15), thickness: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'o registrarse con',
                          style: TextStyle(
                            color: textColor.withOpacity(0.5),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: textColor.withOpacity(0.15), thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SocialLoginButton(
                    text: 'Continuar con Google',
                    imageAsset: 'assets/img/google_logo.png',
                    onPressed: () {
                      if (!_isLoading) _handleGoogleRegister();
                    },
                  ),
                  const SizedBox(height: 36),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿Ya tienes una cuenta? ',
                        style: TextStyle(
                          color: textColor.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed: _isLoading ? null : _goToLogin,
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
            top: -100,
            right: -90,
            child: _blob(theme.colorScheme.primary, 260, isDark ? 0.22 : 0.30),
          ),
          Positioned(
            top: 140,
            left: -110,
            child: _blob(theme.colorScheme.tertiary, 230, isDark ? 0.16 : 0.24),
          ),
          Positioned(
            bottom: -140,
            right: -70,
            child: _blob(theme.colorScheme.secondary, 280, isDark ? 0.14 : 0.20),
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