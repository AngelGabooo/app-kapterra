// lib/features/buyer/presentation/screens/cooperative_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/buyer/data/models/cooperative_model.dart';
import 'package:kaabcafe/features/buyer/data/models/producer_summary_model.dart';
import 'package:kaabcafe/features/buyer/data/models/delivery_model.dart';
import 'package:kaabcafe/features/buyer/presentation/widgets/cooperative_kpi_card.dart';
import 'package:kaabcafe/features/buyer/presentation/widgets/producer_ranking_card.dart';
import 'package:kaabcafe/features/buyer/presentation/widgets/cooperative_chart.dart';
import 'package:kaabcafe/features/buyer/presentation/widgets/cooperative_map_preview.dart';
import 'package:kaabcafe/features/buyer/presentation/widgets/cooperative_alert_card.dart';

class CooperativeDashboardScreen extends StatefulWidget {
  const CooperativeDashboardScreen({super.key});

  @override
  State<CooperativeDashboardScreen> createState() => _CooperativeDashboardScreenState();
}

class _CooperativeDashboardScreenState extends State<CooperativeDashboardScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  AnimationController? _fadeController;

  // ✅ TODOS LOS DATOS VACÍOS
  final CooperativeModel _cooperative = CooperativeModel(
    id: '1',
    name: 'Cooperativa Sierra Verde',
    location: 'Chiapas, México',
    producersCount: 0,
    farmsCount: 0,
    totalProduction: 0,
    monthlyAcopio: 0,
    estimatedSales: 0,
    traceableLots: 0,
    traceabilityAverage: 0,
    pendingAlerts: 0,
    avgProfitability: 0,
    status: 'Sin datos registrados',
  );

  final List<ProducerSummaryModel> _producers = [];
  final List<DeliveryModel> _deliveries = [];
  final List<Map<String, dynamic>> _alerts = [];
  final List<double> _productionData = [0, 0, 0, 0, 0, 0];
  final List<double> _acopioData = [0, 0, 0, 0, 0, 0];
  final List<double> _salesData = [0, 0, 0, 0, 0, 0];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _fadeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.coffeeDeep : Colors.white;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final prodColor = isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              isDark ? AppTheme.coffeeDark : AppTheme.lightBeige,
              isDark ? AppTheme.coffeeDeep.withOpacity(0.5) : AppTheme.primaryGreen.withOpacity(0.03),
              isDark ? AppTheme.coffeeDark : AppTheme.lightBeige,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Barra superior
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dashboard Cooperativa',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Gestión integral de productores y acopio.',
                            style: TextStyle(
                              fontSize: 13,
                              color: textColor.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.push(RouteNames.notifications),
                      icon: Icon(Icons.notifications_outlined, color: textColor),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.file_download_outlined, color: textColor),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.filter_list_outlined, color: textColor),
                    ),
                  ],
                ),
              ),

              // ✅ Contenido con CustomScrollView
              Expanded(
                child: _fadeController != null
                    ? FadeTransition(
                  opacity: _fadeController!,
                  child: _buildScrollContent(isDark, cardColor, textColor, prodColor),
                )
                    : _buildScrollContent(isDark, cardColor, textColor, prodColor),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.coffeeDeep : Colors.white,
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
              context.go(RouteNames.cooperativeDashboard);
            } else if (index == 1) {
              context.go(RouteNames.producers);
            } else if (index == 2) {
              context.go(RouteNames.acopio);
            } else if (index == 3) {
              context.go(RouteNames.reports);
            } else if (index == 4) {
              context.go(RouteNames.cooperativeProfile);
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? AppTheme.coffeeDeep : Colors.white,
          selectedItemColor: isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen,
          unselectedItemColor: textColor.withOpacity(0.35),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Inicio'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Productores'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Acopio'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Reportes'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollContent(bool isDark, Color cardColor, Color textColor, Color prodColor) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              // ✅ Encabezado institucional
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [AppTheme.coffeeMedium, AppTheme.coffeeWarm]
                        : [AppTheme.primaryGreen, AppTheme.secondaryGreen],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (isDark ? AppTheme.coffeeWarm : AppTheme.primaryGreen).withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.apartment,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _cooperative.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '📍 ${_cooperative.location}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              _buildInstitutionChip('👨‍🌾', '${_cooperative.producersCount} productores'),
                              _buildInstitutionChip('🌱', '${_cooperative.farmsCount} fincas'),
                              _buildInstitutionChip('🟢', _cooperative.status),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ✅ KPIs principales - TODOS VACÍOS
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CooperativeKPICard(
                          title: 'Producción total',
                          value: '--',
                          icon: Icons.eco,
                          color: prodColor,
                          isDark: isDark,
                          isEmpty: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CooperativeKPICard(
                          title: 'Productores activos',
                          value: '--',
                          icon: Icons.people,
                          color: prodColor,
                          isDark: isDark,
                          isEmpty: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: CooperativeKPICard(
                          title: 'Acopio mensual',
                          value: '--',
                          icon: Icons.inventory,
                          color: prodColor,
                          isDark: isDark,
                          isEmpty: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CooperativeKPICard(
                          title: 'Ventas estimadas',
                          value: '--',
                          icon: Icons.attach_money,
                          color: prodColor,
                          isDark: isDark,
                          isEmpty: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ✅ Indicadores secundarios - TODOS VACÍOS
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSecondaryKPI(
                        'Lotes trazables',
                        '0',
                        Icons.qr_code,
                        isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen,
                        isDark,
                      ),
                    ),
                    Expanded(
                      child: _buildSecondaryKPI(
                        'Trazabilidad',
                        '0%',
                        Icons.analytics,
                        isDark ? AppTheme.coffeeGoldLight : AppTheme.goldCoffee,
                        isDark,
                      ),
                    ),
                    Expanded(
                      child: _buildSecondaryKPI(
                        'Alertas',
                        '0',
                        Icons.warning,
                        isDark ? AppTheme.berryRed : Colors.red,
                        isDark,
                      ),
                    ),
                    Expanded(
                      child: _buildSecondaryKPI(
                        'Rentabilidad',
                        '0%',
                        Icons.trending_up,
                        isDark ? AppTheme.coffeeGoldLight : AppTheme.secondaryGreen,
                        isDark,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ✅ Gráfica vacía
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CooperativeChart(
                  productionData: _productionData,
                  acopioData: _acopioData,
                  salesData: _salesData,
                  isDark: isDark,
                ),
              ),

              const SizedBox(height: 20),

              // ✅ Mapa regional (vacío)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
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
                    Text(
                      'Mapa regional de productores',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CooperativeMapPreview(isDark: isDark, hasData: false),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ✅ Ranking de productores (vacío)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
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
                    Text(
                      'Ranking de productores',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: (isDark ? AppTheme.coffeeDark : AppTheme.lightBeige).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.people_outline, color: textColor.withOpacity(0.3)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Aún no hay productores registrados',
                              style: TextStyle(
                                fontSize: 13,
                                color: textColor.withOpacity(0.4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ✅ Alertas (vacío)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
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
                    Row(
                      children: [
                        Text(
                          'Alertas institucionales',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Ver todas'),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: (isDark ? AppTheme.coffeeDark : AppTheme.lightBeige).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: AppTheme.primaryGreen.withOpacity(0.3)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Sin alertas pendientes',
                              style: TextStyle(
                                fontSize: 13,
                                color: textColor.withOpacity(0.4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ✅ Acopio reciente (vacío)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
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
                    Text(
                      'Acopio reciente',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: (isDark ? AppTheme.coffeeDark : AppTheme.lightBeige).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.inventory_outlined, color: textColor.withOpacity(0.3)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Sin entregas registradas',
                              style: TextStyle(
                                fontSize: 13,
                                color: textColor.withOpacity(0.4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ✅ Trazabilidad consolidada (vacía)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [AppTheme.coffeeDeep.withOpacity(0.8), AppTheme.coffeeDark.withOpacity(0.5)]
                        : [AppTheme.goldCoffee.withOpacity(0.05), AppTheme.primaryGreen.withOpacity(0.02)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: (isDark ? AppTheme.coffeeGoldLight : AppTheme.goldCoffee).withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.qr_code, color: isDark ? AppTheme.coffeeGoldLight : AppTheme.goldCoffee),
                        const SizedBox(width: 8),
                        Text(
                          'Trazabilidad consolidada',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '0%',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: textColor.withOpacity(0.3),
                                ),
                              ),
                              Text(
                                'Nivel general',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: textColor.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '0',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: textColor.withOpacity(0.3),
                                ),
                              ),
                              Text(
                                'Lotes con QR activo',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: textColor.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '0',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: textColor.withOpacity(0.3),
                                ),
                              ),
                              Text(
                                'Pasaportes generados',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: textColor.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? AppTheme.coffeeMedium : AppTheme.goldCoffee,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Ver trazabilidad consolidada'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInstitutionChip(String emoji, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryKPI(String title, String value, IconData icon, Color color, bool isDark) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 9,
            color: textColor.withOpacity(0.5),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}