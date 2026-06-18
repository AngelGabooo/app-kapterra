import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/auth/data/models/setup_profile_model.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/setup_profile_form.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/login_button.dart';

class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({super.key});

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  final int _currentStep = 1;
  final int _totalSteps = 3;
  bool _isLoading = false;

  void _handleComplete(SetupProfileModel profile) async {
    setState(() {
      _isLoading = true;
    });

    debugPrint('Perfil completado:');
    debugPrint('Nombre: ${profile.fullName}');
    debugPrint('Email: ${profile.email}');
    debugPrint('Teléfono: ${profile.phoneNumber}');
    debugPrint('Municipio: ${profile.municipality}');
    debugPrint('Región: ${profile.region}');
    debugPrint('Experiencia: ${profile.yearsExperience}');
    debugPrint('Hectáreas: ${profile.hectares}');
    debugPrint('Variedad: ${profile.coffeeVariety}');
    debugPrint('Cooperativa: ${profile.belongsToCooperative}');

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      // ✅ Navegar al registro de finca
      context.go(RouteNames.registerFarm);
    }
  }

  void _handleSkip() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Omitir configuración'),
        content: const Text(
          'Puedes completar tu perfil más tarde desde la sección de ajustes.\n\n¿Deseas continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // ✅ Navegar al registro de finca también
              context.go(RouteNames.registerFarm);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.goldCoffee,
            ),
            child: const Text('Omitir'),
          ),
        ],
      ),
    );
  }

  void _goBack() {
    context.go(RouteNames.selectUserType);
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentStep / _totalSteps) * 100;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightBeige,
              AppTheme.primaryGreen.withOpacity(0.03),
              AppTheme.lightBeige,
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
                      color: AppTheme.darkCoffee,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _handleSkip,
                      child: Text(
                        'Omitir',
                        style: TextStyle(
                          color: AppTheme.goldCoffee,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Indicador de progreso
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Paso $_currentStep de $_totalSteps',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.darkCoffee.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress / 100,
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Título y subtítulo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Completa tu perfil',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Queremos conocer un poco más sobre ti para personalizar tu experiencia.',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppTheme.darkCoffee.withOpacity(0.7),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Formulario
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  physics: const BouncingScrollPhysics(),
                  child: SetupProfileForm(onComplete: _handleComplete),
                ),
              ),

              // Botón continuar
              Container(
                padding: const EdgeInsets.all(24.0),
                child: LoginButton(
                  text: 'Continuar',
                  onPressed: () {
                    // El formulario maneja su propio envío
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