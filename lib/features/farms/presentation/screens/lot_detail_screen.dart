import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/farms/data/models/lot_model.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';
import 'package:kaabcafe/features/farms/data/models/farm_activity_model.dart';
import 'package:kaabcafe/features/farms/data/models/lot_cost_model.dart';
import 'package:kaabcafe/features/farms/data/models/lot_production_record.dart';
import 'package:kaabcafe/features/farms/presentation/widgets/farm_kpi_card.dart';
import 'package:kaabcafe/features/farms/presentation/widgets/production_chart.dart';
import 'package:kaabcafe/features/farms/presentation/widgets/activity_timeline_item.dart';
import 'package:kaabcafe/features/farms/presentation/widgets/quick_action_grid.dart';
import 'package:kaabcafe/features/farms/presentation/widgets/cost_summary_card.dart';
import 'package:kaabcafe/features/farms/presentation/widgets/digital_passport_card.dart';
import 'package:kaabcafe/features/farms/presentation/widgets/qr_code_card.dart';

class LotDetailScreen extends StatefulWidget {
  final LotModel lot;
  final FarmDetailsModel farm;

  const LotDetailScreen({
    super.key,
    required this.lot,
    required this.farm,
  });

  @override
  State<LotDetailScreen> createState() => _LotDetailScreenState();
}

class _LotDetailScreenState extends State<LotDetailScreen> {
  int _currentIndex = 1;

  final List<LotCostModel> _costs = [
    LotCostModel(category: 'Mano de obra', amount: 5800, icon: Icons.people),
    LotCostModel(category: 'Insumos', amount: 4200, icon: Icons.agriculture), // ✅ Cambiado
    LotCostModel(category: 'Transporte', amount: 2500, icon: Icons.local_shipping),
  ];

  final List<LotProductionRecord> _productionHistory = [
    LotProductionRecord(month: 'Ene', production: 320, year: 2024),
    LotProductionRecord(month: 'Feb', production: 380, year: 2024),
    LotProductionRecord(month: 'Mar', production: 450, year: 2024),
    LotProductionRecord(month: 'Abr', production: 420, year: 2024),
    LotProductionRecord(month: 'May', production: 480, year: 2024),
    LotProductionRecord(month: 'Jun', production: 450, year: 2024),
  ];

  final List<FarmActivityModel> _activities = [
    FarmActivityModel(
      id: '1',
      title: 'Fertilización',
      description: 'Aplicación de fertilizante orgánico - Responsable: Juan Pérez',
      date: DateTime.now().subtract(const Duration(days: 2)),
      icon: Icons.agriculture, // ✅ Cambiado
    ),
    FarmActivityModel(
      id: '2',
      title: 'Poda',
      description: 'Poda de mantenimiento - Responsable: Pedro López',
      date: DateTime.now().subtract(const Duration(days: 7)),
      icon: Icons.content_cut,
    ),
    FarmActivityModel(
      id: '3',
      title: 'Aplicación fitosanitaria',
      description: 'Control preventivo de plagas - Responsable: María Gómez',
      date: DateTime.now().subtract(const Duration(days: 12)),
      icon: Icons.bug_report,
    ),
    FarmActivityModel(
      id: '4',
      title: 'Cosecha',
      description: 'Primera cosecha del año - 250 kg - Responsable: Equipo de cosecha',
      date: DateTime.now().subtract(const Duration(days: 20)),
      icon: Icons.agriculture,
    ),
  ];

  final List<Map<String, dynamic>> _quickActions = [
    {'title': 'Registrar actividad', 'icon': Icons.add_task},
    {'title': 'Registrar costo', 'icon': Icons.attach_money},
    {'title': 'Subir evidencia', 'icon': Icons.camera_alt},
    {'title': 'Consultar IA', 'icon': Icons.psychology},
    {'title': 'Ver indicadores', 'icon': Icons.analytics},
    {'title': 'Ver trazabilidad', 'icon': Icons.qr_code},
  ];

  void _onQuickActionTap(String action) {
    debugPrint('Acción seleccionada: $action');
    if (action == 'Registrar actividad') {
      context.push(
        RouteNames.registerActivity,
        extra: {
          'lot': widget.lot,
          'farm': widget.farm,
        },
      );
    }
  }

  void _onViewCostDetails() {
    debugPrint('Ver detalles de costos');
  }

  void _onViewPassport() {
    debugPrint('Ver pasaporte digital');
  }

  void _onShareQR() {
    debugPrint('Compartir QR');
  }

  void _onDownloadQR() {
    debugPrint('Descargar QR');
  }

  void _onViewPublicQR() {
    debugPrint('Ver vista pública');
  }

  void _goToEditLot() {
    context.push(
      RouteNames.editLot,
      extra: {
        'lot': widget.lot,
        'farm': widget.farm,
      },
    );
  }

  void _goToLotHistory() {
    context.push(
      RouteNames.lotHistory,
      extra: {
        'lot': widget.lot,
        'farm': widget.farm,
      },
    );
  }

  int get _healthScore => 94;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppTheme.primaryGreen,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            actions: [
              IconButton(
                onPressed: _goToLotHistory,
                icon: const Icon(Icons.history, color: Colors.white),
                tooltip: 'Historial',
              ),
              IconButton(
                onPressed: _goToEditLot,
                icon: const Icon(Icons.edit, color: Colors.white),
                tooltip: 'Editar',
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert, color: Colors.white),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.lot.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.farm.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              titlePadding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.primaryGreen,
                          AppTheme.secondaryGreen,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.agriculture,
                        size: 80,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    left: 20,
                    right: 20,
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        _buildInfoChip(Icons.emoji_nature, widget.lot.variety),
                        _buildInfoChip(Icons.landscape, '${widget.lot.area} ha'),
                        _buildInfoChip(Icons.date_range, 'Plantado 2021'),
                        _buildInfoChip(Icons.height, '1350 msnm'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Contenido
          SliverToBoxAdapter(
            child: Container(
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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Estado del lote
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.lot.statusColor.withOpacity(0.1),
                            widget.lot.statusColor.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: widget.lot.statusColor.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: widget.lot.statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.lot.statusText,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: widget.lot.statusColor,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '$_healthScore/100',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.darkCoffee,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.lot.status == LotStatus.healthy
                                ? 'El lote presenta condiciones óptimas de producción y desarrollo.'
                                : 'Se recomienda atención en este lote.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.darkCoffee.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: _healthScore / 100,
                              backgroundColor: Colors.grey.withOpacity(0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(widget.lot.statusColor),
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // KPIs
                    Row(
                      children: [
                        Expanded(
                          child: FarmKPICard(
                            title: 'Producción estimada',
                            value: '${widget.lot.estimatedProduction} kg',
                            icon: Icons.eco,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FarmKPICard(
                            title: 'Costos acumulados',
                            value: '\$12,500 MXN',
                            icon: Icons.attach_money,
                            color: AppTheme.goldCoffee,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: FarmKPICard(
                            title: 'Rentabilidad',
                            value: '28%',
                            icon: Icons.trending_up,
                            color: AppTheme.secondaryGreen,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FarmKPICard(
                            title: 'Rendimiento',
                            value: '850 kg/ha',
                            icon: Icons.agriculture,
                            color: AppTheme.darkCoffee,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Gráfica de producción
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Evolución de Producción',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.darkCoffee,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: ProductionChart(
                              data: _productionHistory.map((e) => e.production).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Historial de actividades
                    const Text(
                      'Historial de Actividades',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkCoffee,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _activities.length,
                        separatorBuilder: (context, index) => const Divider(height: 16),
                        itemBuilder: (context, index) {
                          return ActivityTimelineItem(
                            activity: _activities[index],
                            isLast: index == _activities.length - 1,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Registro de costos
                    CostSummaryCard(
                      costs: _costs,
                      onViewDetails: _onViewCostDetails,
                    ),

                    const SizedBox(height: 20),

                    // Alertas inteligentes
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFF57C00).withOpacity(0.1),
                            const Color(0xFFD32F2F).withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFF57C00).withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.warning, color: const Color(0xFFF57C00)),
                              const SizedBox(width: 8),
                              const Text(
                                'Alertas Inteligentes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.darkCoffee,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '⚠ Riesgo leve de roya detectado',
                            style: TextStyle(fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '⚠ Exceso de sombra en sector norte',
                            style: TextStyle(fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '💡 Se recomienda fertilización en 15 días',
                            style: TextStyle(fontSize: 13),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFF57C00),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text('Ver recomendaciones'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Pasaporte Digital
                    DigitalPassportCard(onViewPassport: _onViewPassport),

                    const SizedBox(height: 20),

                    // Código QR
                    QrCodeCard(
                      onShare: _onShareQR,
                      onDownload: _onDownloadQR,
                      onViewPublic: _onViewPublicQR,
                    ),

                    const SizedBox(height: 20),

                    // Acciones rápidas
                    const Text(
                      'Acciones rápidas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkCoffee,
                      ),
                    ),
                    const SizedBox(height: 16),
                    QuickActionGrid(
                      actions: _quickActions,
                      onActionTap: _onQuickActionTap,
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            if (index == 0) {
              context.go(RouteNames.dashboard);
            } else if (index == 1) {
              context.go(RouteNames.myFarms);
            } else if (index == 4) {
              context.go(RouteNames.profile);
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.primaryGreen,
          unselectedItemColor: AppTheme.darkCoffee.withOpacity(0.5),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
            BottomNavigationBarItem(icon: Icon(Icons.landscape), label: 'Fincas'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Indicadores'),
            BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Marketplace'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white70),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}