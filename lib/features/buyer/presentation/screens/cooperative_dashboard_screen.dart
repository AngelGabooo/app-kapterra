// lib/features/buyer/presentation/screens/cooperative_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/providers/cooperative_contact_provider.dart';
import 'package:kaabcafe/core/providers/technician_contact_provider.dart';
import 'package:kaabcafe/core/providers/user_provider.dart';
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
import 'package:kaabcafe/features/dashboard/data/models/cooperative_contact_request_model.dart';
import 'package:kaabcafe/features/buyer/providers/cooperative_producers_provider.dart';
import 'package:kaabcafe/features/buyer/providers/technicians_provider.dart';
import 'package:kaabcafe/features/technician/providers/technician_reports_provider.dart';

class CooperativeDashboardScreen extends StatefulWidget {
  const CooperativeDashboardScreen({super.key});

  @override
  State<CooperativeDashboardScreen> createState() => _CooperativeDashboardScreenState();
}

class _CooperativeDashboardScreenState extends State<CooperativeDashboardScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  AnimationController? _fadeController;

  final List<DeliveryModel> _deliveries = [];
  final List<Map<String, dynamic>> _alerts = [];

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

    // ✅ OBTENER DATOS DEL USUARIO
    final userProvider = Provider.of<UserProvider>(context);
    final cooperativeName = userProvider.userName ?? 'Cooperativa';
    final userEmail = userProvider.userEmail ?? '';
    final userPhone = userProvider.userPhone ?? '';

    // ✅ OBTENER DATOS REALES DE LOS PROVIDERS
    final producersProvider = Provider.of<CooperativeProducersProvider>(context);
    final techniciansProvider = Provider.of<TechniciansProvider>(context);
    final reportsProvider = Provider.of<TechnicianReportsProvider>(context);

    final producers = producersProvider.producers;
    final activeProducers = producers.where((p) => p.status == 'Activo').toList();
    final pendingProducers = producers.where((p) => p.status == 'Pendiente').toList();

    // ✅ Calcular estadísticas reales
    final totalProducers = producers.length;
    final totalActive = activeProducers.length;
    final totalPending = pendingProducers.length;
    final totalFarms = producers.fold(0, (sum, p) => sum + p.farmsCount);
    final totalLots = producers.fold(0, (sum, p) => sum + p.lotsCount);
    final totalProduction = producers.fold(0.0, (sum, p) => sum + p.totalProduction);

    // ✅ Técnicos activos
    final activeTechnicians = techniciansProvider.technicians.where((t) => t.status == 'Activo').toList();
    final totalTechnicians = activeTechnicians.length;

    // ✅ Visitas y diagnósticos
    final totalVisits = reportsProvider.totalVisits;
    final totalDiagnoses = reportsProvider.totalDiagnoses;

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
                            userEmail.isNotEmpty ? userEmail : 'Gestión integral de productores y acopio.',
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
                  child: _buildScrollContent(
                    isDark,
                    cardColor,
                    textColor,
                    prodColor,
                    cooperativeName,
                    producersProvider,
                    techniciansProvider,
                    reportsProvider,
                  ),
                )
                    : _buildScrollContent(
                  isDark,
                  cardColor,
                  textColor,
                  prodColor,
                  cooperativeName,
                  producersProvider,
                  techniciansProvider,
                  reportsProvider,
                ),
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

  Widget _buildScrollContent(
      bool isDark,
      Color cardColor,
      Color textColor,
      Color prodColor,
      String cooperativeName,
      CooperativeProducersProvider producersProvider,
      TechniciansProvider techniciansProvider,
      TechnicianReportsProvider reportsProvider,
      ) {
    // ✅ DATOS REALES
    final producers = producersProvider.producers;
    final activeProducers = producers.where((p) => p.status == 'Activo').toList();
    final pendingProducers = producers.where((p) => p.status == 'Pendiente').toList();

    final totalProducers = producers.length;
    final totalActive = activeProducers.length;
    final totalPending = pendingProducers.length;
    final totalFarms = producers.fold(0, (sum, p) => sum + p.farmsCount);
    final totalLots = producers.fold(0, (sum, p) => sum + p.lotsCount);
    final totalProduction = producers.fold(0.0, (sum, p) => sum + p.totalProduction);

    final activeTechnicians = techniciansProvider.technicians.where((t) => t.status == 'Activo').toList();
    final totalTechnicians = activeTechnicians.length;

    final totalVisits = reportsProvider.totalVisits;
    final totalDiagnoses = reportsProvider.totalDiagnoses;

    // ✅ Top 3 productores
    final topProducers = List<ProducerSummaryModel>.from(producers)
      ..sort((a, b) => b.totalProduction.compareTo(a.totalProduction));

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              // ✅ Encabezado institucional con nombre dinámico
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
                            cooperativeName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '📍 Ubicación del productor',
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
                              _buildInstitutionChip('👨‍🌾', '$totalProducers productores'),
                              _buildInstitutionChip('🌱', '$totalFarms fincas'),
                              _buildInstitutionChip('🟢', totalProducers > 0 ? 'Activo' : 'Sin datos registrados'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ✅ KPIs principales - CON DATOS REALES
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CooperativeKPICard(
                          title: 'Producción total',
                          value: totalProduction > 0 ? '${totalProduction.toStringAsFixed(0)} kg' : '--',
                          icon: Icons.eco,
                          color: prodColor,
                          isDark: isDark,
                          isEmpty: totalProduction == 0,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CooperativeKPICard(
                          title: 'Productores activos',
                          value: totalActive > 0 ? '$totalActive' : '--',
                          icon: Icons.people,
                          color: prodColor,
                          isDark: isDark,
                          isEmpty: totalActive == 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: CooperativeKPICard(
                          title: 'Pendientes',
                          value: totalPending > 0 ? '$totalPending' : '--',
                          icon: Icons.pending,
                          color: Colors.orange,
                          isDark: isDark,
                          isEmpty: totalPending == 0,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CooperativeKPICard(
                          title: 'Técnicos activos',
                          value: totalTechnicians > 0 ? '$totalTechnicians' : '--',
                          icon: Icons.engineering,
                          color: prodColor,
                          isDark: isDark,
                          isEmpty: totalTechnicians == 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ✅ Indicadores secundarios - CON DATOS REALES
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
                        'Lotes',
                        '$totalLots',
                        Icons.view_module,
                        isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen,
                        isDark,
                      ),
                    ),
                    Expanded(
                      child: _buildSecondaryKPI(
                        'Fincas',
                        '$totalFarms',
                        Icons.landscape,
                        isDark ? AppTheme.coffeeGoldLight : AppTheme.goldCoffee,
                        isDark,
                      ),
                    ),
                    Expanded(
                      child: _buildSecondaryKPI(
                        'Visitas',
                        '$totalVisits',
                        Icons.assignment,
                        isDark ? AppTheme.berryRed : Colors.red,
                        isDark,
                      ),
                    ),
                    Expanded(
                      child: _buildSecondaryKPI(
                        'Diagnósticos',
                        '$totalDiagnoses',
                        Icons.science,
                        isDark ? AppTheme.coffeeGoldLight : AppTheme.secondaryGreen,
                        isDark,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ✅ Gráfica con datos reales
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
                  productionData: _buildProductionData(producers),
                  acopioData: _buildAcopioData(producers),
                  salesData: _buildSalesData(producers),
                  isDark: isDark,
                ),
              ),

              const SizedBox(height: 20),

              // ✅ Mapa regional
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
                    CooperativeMapPreview(
                      isDark: isDark,
                      hasData: producers.isNotEmpty,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ✅ Ranking de productores - CON DATOS REALES
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
                    if (topProducers.isEmpty)
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
                      )
                    else
                      ...topProducers.take(3).toList().asMap().entries.map((entry) {
                        final index = entry.key;
                        final producer = entry.value;
                        return ProducerRankingCard(
                          producer: producer,
                          isDark: isDark,
                          rank: index + 1,
                        );
                      }).toList(),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ✅ SOLICITUDES DE CONTACTO
              _buildContactRequestsSection(isDark, textColor, cardColor),

              const SizedBox(height: 20),

              // ✅ TÉCNICOS
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
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.engineering,
                            color: AppTheme.primaryGreen,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Técnicos Agrícolas',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                '$totalTechnicians técnicos activos',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: textColor.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => context.push(RouteNames.technicians),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('Gestionar'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: (isDark ? AppTheme.coffeeDark : AppTheme.lightBeige).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.engineering_outlined, color: textColor.withOpacity(0.3)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              totalTechnicians > 0
                                  ? '$totalTechnicians técnicos asignados a productores'
                                  : 'Registra técnicos y asígnalos a los productores',
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

              // ✅ Alertas
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

              // ✅ Trazabilidad consolidada
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
                                totalLots > 0 ? '${((totalLots / 10) * 100).toStringAsFixed(0)}%' : '0%',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: totalLots > 0 ? textColor : textColor.withOpacity(0.3),
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
                                '$totalLots',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: totalLots > 0 ? textColor : textColor.withOpacity(0.3),
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
                                '$totalProducers',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: totalProducers > 0 ? textColor : textColor.withOpacity(0.3),
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
                        onPressed: totalProducers > 0 ? () {} : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: totalProducers > 0
                              ? (isDark ? AppTheme.coffeeMedium : AppTheme.goldCoffee)
                              : Colors.grey,
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

  // ── MÉTODOS PARA GENERAR DATOS DE GRÁFICAS ──────────────────

  List<double> _buildProductionData(List<ProducerSummaryModel> producers) {
    if (producers.isEmpty) return [0, 0, 0, 0, 0, 0];

    final avgProduction = producers.fold(0.0, (sum, p) => sum + p.totalProduction) / producers.length;
    final base = avgProduction / 6;

    return [
      base * 0.6,
      base * 0.8,
      base * 1.0,
      base * 0.7,
      base * 1.2,
      base * 0.9,
    ];
  }

  List<double> _buildAcopioData(List<ProducerSummaryModel> producers) {
    if (producers.isEmpty) return [0, 0, 0, 0, 0, 0];

    final avgProduction = producers.fold(0.0, (sum, p) => sum + p.totalProduction) / producers.length;
    final base = avgProduction / 8;

    return [
      base * 0.3,
      base * 0.5,
      base * 0.7,
      base * 0.4,
      base * 0.9,
      base * 0.6,
    ];
  }

  List<double> _buildSalesData(List<ProducerSummaryModel> producers) {
    if (producers.isEmpty) return [0, 0, 0, 0, 0, 0];

    final avgProduction = producers.fold(0.0, (sum, p) => sum + p.totalProduction) / producers.length;
    final base = avgProduction / 10;

    return [
      base * 0.2,
      base * 0.3,
      base * 0.5,
      base * 0.3,
      base * 0.7,
      base * 0.4,
    ];
  }

  // ── WIDGETS AUXILIARES ──────────────────────────────────────

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
    final isEmpty = value == '0' || value == '--';

    return Column(
      children: [
        Icon(icon, size: 18, color: isEmpty ? color.withOpacity(0.3) : color),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isEmpty ? textColor.withOpacity(0.3) : textColor,
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

  // ── SECCIÓN DE SOLICITUDES DE CONTACTO ──────────────────────

  Widget _buildContactRequestsSection(bool isDark, Color textColor, Color cardColor) {
    final contactProvider = Provider.of<CooperativeContactProvider>(context);
    final pendingRequests = contactProvider.pendingRequests;

    if (pendingRequests.isEmpty) {
      return Container(
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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.handshake,
                    color: AppTheme.primaryGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Solicitudes de productores',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
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
                  Icon(Icons.check_circle_outline, color: AppTheme.primaryGreen.withOpacity(0.3)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'No hay solicitudes pendientes',
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
      );
    }

    return Container(
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.handshake,
                  color: AppTheme.primaryGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Solicitudes de productores',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    Text(
                      '${pendingRequests.length} solicitud${pendingRequests.length > 1 ? 'es' : ''} pendiente${pendingRequests.length > 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Ver todas'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...pendingRequests.take(3).map((request) =>
              _buildContactRequestCard(request, isDark, textColor)
          ),
          if (pendingRequests.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Ver ${pendingRequests.length - 3} solicitudes más',
                    style: TextStyle(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContactRequestCard(
      CooperativeContactRequestModel request,
      bool isDark,
      Color textColor
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (isDark ? AppTheme.coffeeDark : AppTheme.lightBeige).withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryGreen.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                request.producerName.isNotEmpty
                    ? request.producerName[0].toUpperCase()
                    : 'P',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGreen,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.producerName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '📝 ${request.message.length > 30 ? request.message.substring(0, 30) + '...' : request.message}',
                  style: TextStyle(
                    fontSize: 11,
                    color: textColor.withOpacity(0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 10,
                      color: textColor.withOpacity(0.3),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(request.requestDate),
                      style: TextStyle(
                        fontSize: 10,
                        color: textColor.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: request.status == 'pending'
                      ? AppTheme.alertOrange.withOpacity(0.1)
                      : AppTheme.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  request.status == 'pending' ? 'Pendiente' : 'Atendido',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: request.status == 'pending'
                        ? AppTheme.alertOrange
                        : AppTheme.primaryGreen,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              OutlinedButton(
                onPressed: () {
                  _showContactOptionsDialog(request);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  minimumSize: const Size(60, 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(
                    color: AppTheme.primaryGreen.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  'Responder',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return 'Hace ${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'Hace ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'Hace ${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'Hace unos segundos';
    }
  }

  void _showContactOptionsDialog(CooperativeContactRequestModel request) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppTheme.coffeeDeep : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Contactar a ${request.producerName}',
          style: TextStyle(
            color: isDark ? Colors.white : AppTheme.darkCoffee,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📧 Email: ${request.producerEmail}',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white.withOpacity(0.8) : AppTheme.darkCoffee.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '📱 Teléfono: ${request.producerPhone}',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white.withOpacity(0.8) : AppTheme.darkCoffee.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? AppTheme.coffeeDark
                    : AppTheme.lightBeige,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Mensaje: "${request.message}"',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white.withOpacity(0.7) : AppTheme.darkCoffee.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final contactProvider = Provider.of<CooperativeContactProvider>(context, listen: false);
              contactProvider.updateRequestStatus(request.id, 'accepted');
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('✅ Solicitud aceptada'),
                  backgroundColor: AppTheme.primaryGreen,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              );
            },
            child: Text(
              'Aceptar',
              style: TextStyle(color: AppTheme.primaryGreen),
            ),
          ),
          TextButton(
            onPressed: () {
              final contactProvider = Provider.of<CooperativeContactProvider>(context, listen: false);
              contactProvider.updateRequestStatus(request.id, 'rejected');
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('❌ Solicitud rechazada'),
                  backgroundColor: AppTheme.berryRed,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              );
            },
            child: Text(
              'Rechazar',
              style: TextStyle(color: AppTheme.berryRed),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}