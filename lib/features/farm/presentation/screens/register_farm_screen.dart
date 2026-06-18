import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/farm/data/models/farm_model.dart';
import 'package:kaabcafe/features/farm/presentation/widgets/farm_form.dart';
import 'package:kaabcafe/features/farm/presentation/widgets/farm_map.dart';
import 'package:kaabcafe/features/farm/presentation/widgets/farm_summary_card.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/login_button.dart';

class RegisterFarmScreen extends StatefulWidget {
  const RegisterFarmScreen({super.key});

  @override
  State<RegisterFarmScreen> createState() => _RegisterFarmScreenState();
}

class _RegisterFarmScreenState extends State<RegisterFarmScreen> {
  final int _currentStep = 3;
  final int _totalSteps = 3;
  bool _isLoading = false;
  FarmModel? _farm;
  final GlobalKey<FarmFormState> _formKey = GlobalKey<FarmFormState>();

  void _handleSave(FarmModel farm) async {
    _farm = farm;
    setState(() {
      _isLoading = true;
    });

    debugPrint('Finca registrada:');
    debugPrint('Nombre: ${farm.name}');
    debugPrint('Ubicación: ${farm.location}');
    debugPrint('Latitud: ${farm.latitude}');
    debugPrint('Longitud: ${farm.longitude}');
    debugPrint('Altitud: ${farm.altitude} msnm');
    debugPrint('Superficie: ${farm.surface} ha');
    debugPrint('Lotes: ${farm.numberOfLots}');
    debugPrint('Variedad: ${farm.mainVariety}');
    debugPrint('Año: ${farm.establishmentYear}');

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      // ✅ Navegar a la pantalla de éxito
      context.go(RouteNames.farmSuccess, extra: farm.name);
    }
  }

  void _handleLater() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Crear más tarde'),
        content: const Text(
          'Puedes registrar tu finca más tarde desde la sección de configuración.\n\n¿Deseas continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // ✅ Navegar a la pantalla de éxito sin finca
              context.go(RouteNames.farmSuccess, extra: 'tu finca');
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.goldCoffee,
            ),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  void _goBack() {
    context.go(RouteNames.setupProfile);
  }

  void _submitForm() {
    // ✅ Llamar al método submit del formulario
    _formKey.currentState?.submitForm();
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
                      onPressed: _handleLater,
                      child: Text(
                        'Crear más tarde',
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
                      'Registra tu primera finca',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Esta información nos ayudará a organizar tu producción y generar indicadores precisos.',
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

              // Formulario, mapa y resumen
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      FarmForm(
                        key: _formKey,
                        onSave: _handleSave,
                      ),
                      const SizedBox(height: 20),

                      // Mapa interactivo
                      const Text(
                        'Ubicación en el mapa',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkCoffee,
                        ),
                      ),
                      const SizedBox(height: 8),
                      FarmMap(
                        onLocationSelected: (lat, lng) {
                          if (_farm != null) {
                            setState(() {
                              _farm!.latitude = lat;
                              _farm!.longitude = lng;
                            });
                          }
                          debugPrint('Ubicación seleccionada: $lat, $lng');
                        },
                      ),

                      const SizedBox(height: 20),
                      const FarmSummaryCard(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              // Botón guardar
              Container(
                padding: const EdgeInsets.all(24.0),
                child: LoginButton(
                  text: 'Guardar finca y continuar',
                  onPressed: _submitForm, // ✅ Ahora llama al submit del formulario
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