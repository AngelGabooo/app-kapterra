import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/providers/user_provider.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/auth/data/models/setup_profile_model.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/setup_profile_form.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/login_button.dart';
import '../../../../core/widgets/neumorphic_widgets.dart';

class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({super.key});

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  final GlobalKey<SetupProfileFormState> _formKey = GlobalKey<SetupProfileFormState>();

  final int _currentStep = 1;
  final int _totalSteps = 2;
  bool _isLoading = false;

  void _handleComplete(SetupProfileModel profile) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // ✅ Guardar el teléfono en UserProvider asociado al email
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.saveUserPhoneForCurrentEmail(profile.phoneNumber);

      debugPrint('📞 Teléfono guardado: ${profile.phoneNumber}');
      debugPrint('✅ Perfil completado de forma segura');

      if (mounted) {
        context.go(RouteNames.dashboard);
      }
    } catch (e) {
      debugPrint('Error guardando perfil: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar el perfil: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleSkip() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Omitir configuración', style: TextStyle(color: theme.colorScheme.onSurface)),
        content: Text(
          'Puedes completar tu perfil más tarde desde la sección de ajustes.\n\n¿Deseas continuar?',
          style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: theme.colorScheme.onSurface.withOpacity(0.6)),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(RouteNames.dashboard);
            },
            style: TextButton.styleFrom(foregroundColor: theme.colorScheme.tertiary),
            child: const Text('Omitir'),
          ),
        ],
      ),
    );
  }

  void _goBack() => context.go(RouteNames.selectUserType);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final progress = (_currentStep / _totalSteps);

    final creamColor = isDark
        ? AppTheme.coffeeDeep
        : const Color(0xFFF0E8D8);

    // ✅ OBTENER DATOS DEL USUARIO DESDE USERPROVIDER
    final userProvider = Provider.of<UserProvider>(context);
    final userName = userProvider.userName ?? '';
    final userPhone = userProvider.userPhone ?? '';
    final userEmail = userProvider.userEmail ?? '';

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: creamColor,
            ),
          ),
          Positioned.fill(
            child: _AuroraBackground(theme: theme),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _goBack,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.coffeeDeep.withOpacity(0.7)
                                : const Color(0xFFE8E0D5).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withOpacity(0.06)
                                  : AppTheme.darkCoffee.withOpacity(0.06),
                              width: 0.5,
                            ),
                            boxShadow: const [],
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: isDark ? Colors.white : AppTheme.darkCoffee,
                            size: 20,
                          ),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _handleSkip,
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.goldCoffee,
                        ),
                        child: const Text(
                          'Omitir',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Paso $_currentStep de $_totalSteps',
                              style: TextStyle(
                                fontSize: 14,
                                color: (isDark ? Colors.white : AppTheme.darkCoffee).withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _ProgressGroove(
                              progress: progress,
                              theme: theme,
                              isDark: isDark,
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [AppTheme.primaryGreen, AppTheme.goldCoffee],
                          ).createShader(bounds),
                          child: const Text(
                            'Completa tu perfil',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Queremos conocer un poco más sobre ti para personalizar tu experiencia.',
                          style: TextStyle(
                            fontSize: 15,
                            color: (isDark ? Colors.white : AppTheme.darkCoffee).withOpacity(0.7),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // ✅ PASAR LOS DATOS DEL USUARIO AL FORMULARIO
                        SetupProfileForm(
                          key: _formKey,
                          onComplete: _handleComplete,
                          initialFullName: userName,
                          initialPhone: userPhone,
                          initialEmail: userEmail,
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(24.0),
                  color: Colors.transparent,
                  child: LoginButton(
                    text: 'Continuar',
                    onPressed: () {
                      _formKey.currentState?.submitForm();
                    },
                    isLoading: _isLoading,
                    isEnabled: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressGroove extends StatelessWidget {
  final double progress;
  final ThemeData theme;
  final bool isDark;

  const _ProgressGroove({
    required this.progress,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.coffeeDeep.withOpacity(0.7)
            : const Color(0xFFE8E0D5).withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : AppTheme.darkCoffee.withOpacity(0.06),
          width: 0.5,
        ),
        boxShadow: const [],
      ),
      child: SizedBox(
        height: 10,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: LinearGradient(
                      colors: [AppTheme.primaryGreen, AppTheme.goldCoffee],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AuroraBackground extends StatelessWidget {
  final ThemeData theme;
  const _AuroraBackground({required this.theme});

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;

    return ClipRect(
      child: Stack(
        children: [
          Positioned(
            top: -120,
            left: -100,
            child: _blob(AppTheme.primaryGreen, 260, isDark ? 0.20 : 0.26),
          ),
          Positioned(
            top: 100,
            right: -110,
            child: _blob(AppTheme.goldCoffee, 220, isDark ? 0.15 : 0.20),
          ),
          Positioned(
            bottom: -150,
            left: -60,
            child: _blob(AppTheme.secondaryGreen, 280, isDark ? 0.12 : 0.16),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 85, sigmaY: 85),
              child: Container(color: Colors.transparent),
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