// lib/features/auth/presentation/screens/register_screen.dart
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:kaabcafe/core/services/google_sign_in_service.dart';
import '../widgets/neumorphic_box.dart' hide NeumorphicBox;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ Variable para guardar el rol seleccionado
  UserType? _selectedRole;

// lib/features/auth/presentation/screens/register_screen.dart - _handleRegister

  void _handleRegister(RegisterData data) async {
    if (_selectedRole == null) {
      _showSnackBar('Por favor selecciona un rol para continuar', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // ✅ 1. REGISTRAR EN FIREBASE AUTHENTICATION
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: data.email.trim(),
        password: data.password,
      );

      await userCredential.user?.updateDisplayName(data.fullName);
      await userCredential.user?.reload();

      final String displayName = userCredential.user?.displayName ?? data.fullName;

      debugPrint('✅ Usuario registrado en Firebase: ${userCredential.user?.uid}');
      debugPrint('✅ Email: ${userCredential.user?.email}');
      debugPrint('✅ Nombre: $displayName');

      // ✅ 2. REGISTRAR EN LA API CON EL ROL SELECCIONADO
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final apiUser = await userProvider.registerWithApiAndRole(
        fullName: displayName,
        email: data.email.trim(),
        phoneNumber: data.phoneNumber,
        password: data.password,
        acceptTerms: true,
        userType: _selectedRole!,
      );

      debugPrint('✅ Usuario registrado en API: ${apiUser.id}');
      debugPrint('✅ Rol asignado: ${apiUser.rol}');

      // ✅ 3. REDIRIGIR SEGÚN EL ROL
      final String destinationRoute;
      switch (_selectedRole!) {
        case UserType.producer:
          destinationRoute = RouteNames.setupProfile;
          break;
        case UserType.cooperative:
          destinationRoute = RouteNames.cooperativeDashboard;
          break;
        case UserType.technician:
          destinationRoute = RouteNames.technicianDashboard;
          break;
        case UserType.buyer:
          destinationRoute = RouteNames.marketplace;
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Cuenta creada como ${_selectedRole!.title}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      if (mounted) {
        context.go(destinationRoute);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Error al registrar el usuario.';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Este correo electrónico ya está registrado.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'El correo electrónico no es válido.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'La contraseña es demasiado débil.';
      } else if (e.code == 'network-request-failed') {
        errorMessage = 'Error de conexión. Verifica tu internet.';
      }
      _showSnackBar(errorMessage, isError: true);
    } catch (e) {
      debugPrint('Error en Registro: $e');
      _showSnackBar('Error de conexión con el servidor: ${e.toString()}', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ✅ MÉTODO PARA REGISTRO CON GOOGLE
  Future<void> _handleGoogleRegister() async {
    setState(() {
      _isGoogleLoading = true;
    });

    try {
      // ✅ 1. Iniciar sesión con Google
      final account = await GoogleSignInService.signIn();

      if (account == null) {
        setState(() {
          _isGoogleLoading = false;
        });
        return; // Usuario canceló
      }

      // ✅ 2. Obtener datos del usuario
      final userData = await GoogleSignInService.getUserData(account);
      final email = userData['email'] ?? '';
      final displayName = userData['displayName'] ?? 'Usuario Google';
      final idToken = userData['idToken'] ?? '';

      debugPrint('✅ Google Sign-In exitoso: $email');
      debugPrint('✅ Nombre: $displayName');

      // ✅ 3. Autenticar con Firebase usando el token de Google
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      debugPrint('✅ Firebase Auth con Google exitoso: ${userCredential.user?.uid}');

      setState(() {
        _isGoogleLoading = false;
      });

      // ✅ 4. Preguntar el rol al usuario
      _showRoleSelectionDialog(email, displayName);

    } catch (e) {
      setState(() {
        _isGoogleLoading = false;
      });

      debugPrint('❌ Error en Google Register: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al registrarse con Google: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ✅ DIÁLOGO PARA SELECCIONAR ROL DESPUÉS DE GOOGLE
  void _showRoleSelectionDialog(String email, String displayName) {
    final theme = Theme.of(context);
    UserType? selectedRole;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Selecciona tu rol'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Hola $displayName, ¿qué tipo de usuario eres?',
              style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.8)),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: UserType.values.map((role) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    final isSelected = selectedRole == role;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRole = role;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary.withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              role.icon,
                              size: 18,
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              role.title,
                              style: TextStyle(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface.withOpacity(0.8),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.go(RouteNames.login);
            },
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: selectedRole == null ? null : () async {
              Navigator.pop(dialogContext);

              try {
                setState(() {
                  _isGoogleLoading = true;
                });

                final userProvider = Provider.of<UserProvider>(context, listen: false);

                // ✅ Registrar en la API con el rol seleccionado
                // Primero registramos en la API (contraseña temporal)
                final tempPassword = 'Google_${DateTime.now().millisecondsSinceEpoch}';
                final apiUser = await userProvider.registerWithApiAndRole(
                  fullName: displayName,
                  email: email,
                  phoneNumber: '', // Teléfono se pedirá después
                  password: tempPassword,
                  acceptTerms: true,
                  userType: selectedRole!,
                );

                debugPrint('✅ Usuario registrado en API con Google: ${apiUser.id}');
                debugPrint('✅ Rol asignado: ${apiUser.rol}');

                // ✅ Redirigir según el rol
                final String destinationRoute;
                switch (selectedRole!) {
                  case UserType.producer:
                    destinationRoute = RouteNames.setupProfile;
                    break;
                  case UserType.cooperative:
                    destinationRoute = RouteNames.cooperativeDashboard;
                    break;
                  case UserType.technician:
                    destinationRoute = RouteNames.technicianDashboard;
                    break;
                  case UserType.buyer:
                    destinationRoute = RouteNames.marketplace;
                    break;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✅ Cuenta creada como ${selectedRole!.title}'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );

                if (mounted) {
                  context.go(destinationRoute);
                }
              } catch (e) {
                debugPrint('Error en registro con Google: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al completar el registro: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              } finally {
                setState(() {
                  _isGoogleLoading = false;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  void _goToLogin() {
    context.go(RouteNames.login);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : Colors.green,
        duration: const Duration(seconds: 3),
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
                    'Selecciona tu rol y empieza a gestionar tu producción de café.',
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ✅ SELECTOR DE ROL
                  _RoleSelector(
                    selectedRole: _selectedRole,
                    onRoleSelected: (role) {
                      setState(() {
                        _selectedRole = role;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  (_isLoading || _isGoogleLoading)
                      ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                      : RegisterForm(
                    onRegister: _handleRegister,
                    showRoleSelector: false,
                  ),
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
                    text: _isGoogleLoading ? 'Cargando...' : 'Continuar con Google',
                    imageAsset: 'assets/img/google_logo.png',
                    onPressed: _isGoogleLoading ? null : _handleGoogleRegister,
                    isLoading: _isGoogleLoading,
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

// ✅ WIDGET SELECTOR DE ROL
class _RoleSelector extends StatelessWidget {
  final UserType? selectedRole;
  final Function(UserType) onRoleSelected;

  const _RoleSelector({
    required this.selectedRole,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final roles = UserType.values;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecciona tu rol',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: roles.map((role) {
            final isSelected = selectedRole == role;
            return _RoleChip(
              role: role,
              isSelected: isSelected,
              onTap: () => onRoleSelected(role),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _RoleChip extends StatelessWidget {
  final UserType role;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleChip({
    required this.role,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.15)
              : (isDark ? AppTheme.coffeeDeep : const Color(0xFFF0E8D8)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : (isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade300),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              role.icon,
              size: 18,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 8),
            Text(
              role.title,
              style: TextStyle(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.8),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
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