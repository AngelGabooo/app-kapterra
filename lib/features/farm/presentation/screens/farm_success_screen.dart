import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/features/farm/presentation/widgets/success_animation.dart';
import 'package:kaabcafe/features/auth/presentation/widgets/login_button.dart';

class FarmSuccessScreen extends StatefulWidget {
  final String farmName;

  const FarmSuccessScreen({
    super.key,
    required this.farmName,
  });

  @override
  State<FarmSuccessScreen> createState() => _FarmSuccessScreenState();
}

class _FarmSuccessScreenState extends State<FarmSuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  // Builds a staggered fade + gentle slide-up for a section of the screen,
  // so content cascades in after the hero badge lands instead of just
  // appearing all at once.
  Widget _reveal(Widget child, double start, double end) {
    final animation = CurvedAnimation(
      parent: _entranceController,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(animation),
        child: child,
      ),
    );
  }

  void _goToDashboard() {
    context.go(RouteNames.dashboard);
  }

  void _registerAnotherFarm() {
    context.go(RouteNames.registerFarm);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

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
              theme.colorScheme.primary.withOpacity(0.05),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 32),

                // Single hero: badge + orbiting feature icons + ripple.
                const SuccessAnimation(),

                const SizedBox(height: 8),

                _reveal(
                  Column(
                    children: [
                      Text(
                        'REGISTRO COMPLETADO',
                        style: textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Text(
                          '${widget.farmName} ya está en línea',
                          textAlign: TextAlign.center,
                          style: textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  0.0,
                  0.6,
                ),

                const SizedBox(height: 14),

                _reveal(
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Ahora puedes registrar lotes, actividades y costos, además de generar trazabilidad para tu producción cafetalera.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        height: 1.45,
                      ),
                    ),
                  ),
                  0.15,
                  0.75,
                ),

                const SizedBox(height: 28),

                _reveal(
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.08)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(theme.brightness == Brightness.dark ? 0.2 : 0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildFeatureItem(Icons.eco, 'Producción', theme),
                            _buildFeatureItem(Icons.analytics, 'Indicadores', theme),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildFeatureItem(Icons.trending_up, 'Rentabilidad', theme),
                            _buildFeatureItem(Icons.qr_code, 'Trazabilidad', theme),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.05)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                size: 20,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Kaab Terra ya está listo para ayudarte a gestionar tu finca con datos en tiempo real.',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  0.3,
                  0.85,
                ),

                const SizedBox(height: 32),

                _reveal(
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LoginButton(
                          text: 'Ir al Dashboard',
                          onPressed: _goToDashboard,
                          isLoading: false,
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: _registerAnotherFarm,
                          icon: Icon(Icons.add, color: theme.colorScheme.secondary),
                          label: const Text(
                            'Registrar otra finca',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.colorScheme.secondary,
                            side: BorderSide(color: theme.colorScheme.secondary.withOpacity(0.5)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  0.45,
                  1.0,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String label, ThemeData theme) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            size: 28,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}