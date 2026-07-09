import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/aurora_background.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/visit_registration_form.dart';

class TechnicianVisitRegistrationScreen extends StatefulWidget {
  const TechnicianVisitRegistrationScreen({
    super.key,
    this.producerName,
    this.farmName,
    this.lotName,
    this.location,
  });

  final String? producerName;
  final String? farmName;
  final String? lotName;
  final String? location;

  @override
  State<TechnicianVisitRegistrationScreen> createState() =>
      _TechnicianVisitRegistrationScreenState();
}

class _TechnicianVisitRegistrationScreenState
    extends State<TechnicianVisitRegistrationScreen> {
  int _currentIndex = 2;

  // ✅ NUEVO: Navegar al Diagnóstico del Cultivo
  void _navigateToCropDiagnosis() {
    context.push(
      RouteNames.technicianCropDiagnosis,
      extra: {
        'lotName': widget.lotName ?? 'Lote Norte',
        'farmName': widget.farmName ?? 'El Mirador',
        'producerName': widget.producerName ?? 'Juan Pérez',
        'location': widget.location ?? 'Motozintla, Chiapas',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: AuroraBackground(
        isDark: isDark,
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Header ──────────────────────────────────────────
              SliverToBoxAdapter(
                child: _buildHeader(isDark, textColor),
              ),

              // ── Formulario ──────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    VisitRegistrationForm(
                      isDark: isDark,
                      producerName: widget.producerName ?? 'Juan Pérez',
                      farmName: widget.farmName ?? 'El Mirador',
                      lotName: widget.lotName ?? 'Lote Norte',
                      location: widget.location ?? 'Motozintla, Chiapas',
                      onSave: (data) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Visita registrada correctamente ✅'),
                            backgroundColor: AppTheme.primaryGreen,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        );
                        context.go(RouteNames.technicianAgenda);
                      },
                      onSaveDraft: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Borrador guardado 💾'),
                            backgroundColor: AppTheme.goldCoffee,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(isDark),
    );
  }

  Widget _buildHeader(bool isDark, Color textColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Row(
        children: [
          // ✅ Botón regresar - más pequeño
          NeumorphicIconButton(
            icon: Icons.arrow_back,
            isDark: isDark,
            onPressed: () => context.pop(),
            size: 40,
            iconSize: 18,
            color: textColor,
          ),
          const SizedBox(width: 10),
          // ✅ Texto - con Expanded para evitar overflow
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Registro de Visita',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Documenta la inspección realizada.',
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // ✅ Botón guardar - más pequeño
          NeumorphicIconButton(
            icon: Icons.save_outlined,
            isDark: isDark,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Borrador guardado 💾'),
                  backgroundColor: AppTheme.goldCoffee,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              );
            },
            size: 40,
            iconSize: 18,
            color: AppTheme.goldCoffee,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(bool isDark) {
    return NeumorphicBottomNav(
      isDark: isDark,
      currentIndex: _currentIndex,
      items: const [
        Icons.home_outlined,
        Icons.people_outline,
        Icons.calendar_today_outlined,
        Icons.analytics_outlined,
        Icons.person_outline,
      ],
      onTap: (index) {
        setState(() => _currentIndex = index);
        switch (index) {
          case 0:
            context.go(RouteNames.technicianDashboard);
            break;
          case 1:
          // context.go(RouteNames.technicianProducers);
            break;
          case 2:
            context.go(RouteNames.technicianAgenda);
            break;
          case 3:
          // ✅ CONEXIÓN: Navegar al Diagnóstico del Cultivo
            _navigateToCropDiagnosis();
            break;
          case 4:
            context.go(RouteNames.profile);
            break;
        }
      },
    );
  }
}