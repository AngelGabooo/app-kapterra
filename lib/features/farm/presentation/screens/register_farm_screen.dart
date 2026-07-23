// lib/features/farm/presentation/screens/register_farm_screen.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/providers/farm_provider.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/farm/data/models/farm_model.dart';
import 'package:kaabcafe/features/farm/presentation/widgets/farm_form.dart';
import 'package:kaabcafe/features/farm/presentation/widgets/farm_map.dart';
import 'package:kaabcafe/features/farm/presentation/widgets/farm_summary_card.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/login_button.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';
import '../../../../core/widgets/neumorphic_widgets.dart';

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

  // ✅ Inicializar _farm en initState
  @override
  void initState() {
    super.initState();
    _farm = FarmModel();
  }

  void _handleSave(FarmModel farm) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
    if (mounted) {
      final farmProvider = Provider.of<FarmProvider>(context, listen: false);
      final newFarm = FarmDetailsModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: farm.name,
        location: farm.location.isNotEmpty ? farm.location : 'Ubicación registrada',
        hectares: farm.surface,
        lots: 0,
        productivity: 0,
        status: FarmHealthStatus.healthy,
        imageUrl: 'assets/img/default_farm.png',
        latitude: farm.latitude ?? 16.7525,
        longitude: farm.longitude ?? -93.1167,
      );
      farmProvider.addFarm(newFarm);

      // ✅ Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Finca registrada correctamente'),
          backgroundColor: AppTheme.primaryGreen,
        ),
      );

      context.go(RouteNames.farmSuccess, extra: farm.name);
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
            style: TextButton.styleFrom(foregroundColor: theme.colorScheme.onSurface.withOpacity(0.6)),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(RouteNames.dashboard);
            },
            style: TextButton.styleFrom(foregroundColor: theme.colorScheme.tertiary),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  void _goBack() => context.pop();
  void _submitForm() => _formKey.currentState?.submitForm();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final progress = (_currentStep / _totalSteps);

    final creamColor = isDark
        ? AppTheme.coffeeDeep
        : const Color(0xFFF0E8D8);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: creamColor),
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
                        onPressed: _handleLater,
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.goldCoffee,
                        ),
                        child: const Text(
                          'Crear más tarde',
                          style: TextStyle(fontWeight: FontWeight.w600),
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            'Registra tu primera finca',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // ✅ Pasar el farm al formulario
                        FarmForm(
                          key: _formKey,
                          onSave: _handleSave,
                          initialFarm: _farm,
                        ),
                        const SizedBox(height: 28),
                        Text(
                          'Ubicación en el mapa',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : AppTheme.darkCoffee,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.coffeeDeep.withOpacity(0.7)
                                : const Color(0xFFE8E0D5).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withOpacity(0.06)
                                  : AppTheme.darkCoffee.withOpacity(0.06),
                              width: 0.5,
                            ),
                            boxShadow: const [],
                          ),
                          padding: const EdgeInsets.all(6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: FarmMap(
                              onLocationSelected: (lat, lng) {
                                setState(() {
                                  if (_farm != null) {
                                    _farm!.latitude = lat;
                                    _farm!.longitude = lng;
                                    _farm!.location = 'Ubicación seleccionada (${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)})';
                                  }
                                });
                              },
                              initialLat: _farm?.latitude,
                              initialLng: _farm?.longitude,
                            ),
                          ),
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

/// Barra de progreso - SIN BRILLO
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

/// Fondo aurora/espacial
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
            right: -90,
            child: _blob(AppTheme.primaryGreen, 260, isDark ? 0.20 : 0.26),
          ),
          Positioned(
            top: 120,
            left: -110,
            child: _blob(AppTheme.goldCoffee, 220, isDark ? 0.15 : 0.20),
          ),
          Positioned(
            bottom: -150,
            right: -60,
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