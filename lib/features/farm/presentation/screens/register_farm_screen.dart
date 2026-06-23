import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
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
  final int _currentStep = 2;
  final int _totalSteps = 2;
  bool _isLoading = false;
  FarmModel? _farm;
  final GlobalKey<FarmFormState> _formKey = GlobalKey<FarmFormState>();

  // 🚀 LÓGICA DE GUARDADO CORREGIDA
  void _handleSave(FarmModel farm) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    if (mounted) {
      // Usamos .go() para ir a la nueva pantalla y limpiar la pila de registro
      // Esto evita el error de "nothing to pop"
      context.go(RouteNames.dashboard);
    }
  }

  void _handleLater() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Crear más tarde', style: TextStyle(color: theme.colorScheme.onSurface)),
        content: Text(
          'Puedes registrar tu finca más tarde desde la sección de configuración.',
          style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Cambiamos context.pop(false) por context.go para ir a la home
              context.go(RouteNames.dashboard);
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  void _goBack() => context.pop(); // Mejor usar pop que go para navegación hacia atrás
  void _submitForm() => _formKey.currentState?.submitForm();

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
                      onPressed: _handleLater,
                      child: const Text('Crear más tarde', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Paso $_currentStep de $_totalSteps', style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withOpacity(0.6))),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(value: progress / 100, minHeight: 6),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Text('Registra tu primera finca', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 32),
                      FarmForm(key: _formKey, onSave: _handleSave),
                      const SizedBox(height: 28),
                      Text('Ubicación en el mapa', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      FarmMap(
                        onLocationSelected: (lat, lng) {
                          if (_farm != null) {
                            setState(() {
                              _farm!.latitude = lat;
                              _farm!.longitude = lng;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 28),
                      const FarmSummaryCard(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24.0),
                child: LoginButton(
                  text: 'Guardar finca y continuar',
                  onPressed: _submitForm,
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