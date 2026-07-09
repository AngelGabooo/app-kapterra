import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/aurora_background.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/lot_inspection/lot_inspection_form.dart';

class TechnicianLotInspectionScreen extends StatefulWidget {
  const TechnicianLotInspectionScreen({
    super.key,
    this.lotName,
    this.farmName,
    this.producerName,
    this.location,
  });

  final String? lotName;
  final String? farmName;
  final String? producerName;
  final String? location;

  @override
  State<TechnicianLotInspectionScreen> createState() =>
      _TechnicianLotInspectionScreenState();
}

class _TechnicianLotInspectionScreenState
    extends State<TechnicianLotInspectionScreen> {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: AuroraBackground(
        isDark: isDark,
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _buildHeader(isDark),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    LotInspectionForm(
                      isDark: isDark,
                      lotName: widget.lotName ?? 'Lote Norte',
                      farmName: widget.farmName ?? 'El Mirador',
                      producerName: widget.producerName ?? 'Juan Pérez',
                      location: widget.location ?? 'Motozintla, Chiapas',
                      onSave: (data) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Inspección completada ✅'),
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

  Widget _buildHeader(bool isDark) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Row(
        children: [
          NeumorphicIconButton(
            icon: Icons.arrow_back,
            isDark: isDark,
            onPressed: () => context.pop(),
            size: 40,
            iconSize: 18,
            color: textColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Inspección del Lote',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Evaluación técnica del cultivo.',
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