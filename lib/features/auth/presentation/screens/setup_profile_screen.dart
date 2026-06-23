import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/features/auth/data/models/setup_profile_model.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/setup_profile_form.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/login_button.dart';

class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({super.key});

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  // 🚨 CLAVE GLOBAL NUEVA: Permite controlar el formulario desde fuera
  final GlobalKey<SetupProfileFormState> _formKey = GlobalKey<SetupProfileFormState>();

  final int _currentStep = 1;
  final int _totalSteps = 2;
  bool _isLoading = false;

  void _handleComplete(SetupProfileModel profile) async {
    setState(() {
      _isLoading = true;
    });

    debugPrint('Perfil completado de forma segura');
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      context.go(RouteNames.registerFarm);
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
              context.go(RouteNames.registerFarm);
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
    final progress = (_currentStep / _totalSteps) * 100;

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
          child: Column(
            children: [
              // Barra superior
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _goBack,
                      icon: const Icon(Icons.arrow_back),
                      color: theme.colorScheme.onSurface,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _handleSkip,
                      style: TextButton.styleFrom(foregroundColor: theme.colorScheme.tertiary),
                      child: const Text('Omitir', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    ),
                  ],
                ),
              ),

              // Contenido con scroll
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
                            style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withOpacity(0.6), fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress / 100,
                              backgroundColor: theme.colorScheme.onSurface.withOpacity(0.12),
                              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.secondary),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Text('Completa tu perfil', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                      const SizedBox(height: 8),
                      Text('Queremos conocer un poco más sobre ti para personalizar tu experiencia.', style: TextStyle(fontSize: 15, color: theme.colorScheme.onSurface.withOpacity(0.7), height: 1.4)),
                      const SizedBox(height: 32),

                      // 🚨 ENLAZAMOS LA LLAVE AQUÍ:
                      SetupProfileForm(
                        key: _formKey,
                        onComplete: _handleComplete,
                      ),
                    ],
                  ),
                ),
              ),

              // Botón continuar funcional
              Container(
                padding: const EdgeInsets.all(24.0),
                color: Colors.transparent,
                child: LoginButton(
                  text: 'Continuar',
                  onPressed: () {
                    // 🚨 LLAMADA CLAVE: Acciona el guardado interno del formulario de forma externa
                    _formKey.currentState?.submitForm();
                  },
                  isLoading: _isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}