import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/dashboard/data/models/kpi_model.dart';
import 'package:kaabcafe/features/dashboard/data/models/alert_model.dart';
import 'package:kaabcafe/features/dashboard/data/models/farm_summary_model.dart';
import 'package:kaabcafe/features/dashboard/data/models/activity_model.dart';
import 'package:kaabcafe/features/dashboard/presentation/widgets/kpi_card.dart';
import 'package:kaabcafe/features/dashboard/presentation/widgets/production_chart.dart';
import 'package:kaabcafe/features/dashboard/presentation/widgets/alert_card.dart';
import 'package:kaabcafe/features/dashboard/presentation/widgets/quick_action_button.dart';
import 'package:kaabcafe/features/dashboard/presentation/widgets/farm_card.dart';
import 'package:kaabcafe/features/dashboard/presentation/widgets/activity_timeline.dart';

import '../../../../core/routes/route_names.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<KPIModel> _kpis = [
    KPIModel(title: 'Producción Total', value: '1,250 kg', icon: Icons.eco, color: AppTheme.primaryGreen, change: 12.5),
    KPIModel(title: 'Costos Acumulados', value: '\$45,800 MXN', icon: Icons.attach_money, color: AppTheme.goldCoffee, change: -5.2),
    KPIModel(title: 'Rentabilidad', value: '22%', icon: Icons.trending_up, color: AppTheme.secondaryGreen, change: 8.3),
    KPIModel(title: 'Lotes Activos', value: '8', icon: Icons.view_module, color: AppTheme.darkCoffee, change: 0),
  ];

  final List<AlertModel> _alerts = [
    AlertModel(
      title: 'Riesgo de roya detectado',
      description: 'Se han identificado síntomas en el Lote 3. Revisa inmediatamente.',
      priority: AlertPriority.high,
      date: DateTime.now(),
      icon: Icons.warning,
    ),
    AlertModel(
      title: 'Se recomienda poda',
      description: 'El Lote 3 requiere mantenimiento. Programa una revisión.',
      priority: AlertPriority.medium,
      date: DateTime.now(),
      icon: Icons.content_cut,
    ),
    AlertModel(
      title: 'Incremento positivo',
      description: 'La producción ha aumentado 15% este mes.',
      priority: AlertPriority.low,
      date: DateTime.now(),
      icon: Icons.trending_up,
    ),
  ];

  final List<FarmSummaryModel> _farms = [
    FarmSummaryModel(name: 'Finca El Mirador', hectares: 12.5, production: 850, status: FarmStatus.healthy),
    FarmSummaryModel(name: 'Finca La Esperanza', hectares: 8.0, production: 400, status: FarmStatus.attention),
  ];

  final List<ActivityModel> _activities = [
    ActivityModel(title: 'Fertilización', description: 'Lote 3 - Fertilización completada', date: DateTime.now(), icon: Icons.agriculture),
    ActivityModel(title: 'Nuevo costo', description: 'Insumos agrícolas registrados', date: DateTime.now(), icon: Icons.receipt),
    ActivityModel(title: 'Cosecha', description: 'Lote 1 - 250 kg registrados', date: DateTime.now(), icon: Icons.agriculture),
    ActivityModel(title: 'Recomendación', description: 'Sistema generó alerta temprana', date: DateTime.now(), icon: Icons.notifications_active),
  ];

  final List<double> _productionData = [850, 920, 1100, 980, 1250, 1420];

  void _onNavigationTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    // ✅ CORREGIDO: Manejar todos los índices correctamente
    switch (index) {
      case 0:
        context.go(RouteNames.dashboard);
        break;
      case 1:
        context.go(RouteNames.myFarms);
        break;
      case 2:
        context.push(RouteNames.costs); // Costos
        break;
      case 3:
      // Indicadores - por implementar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Próximamente: Indicadores'), backgroundColor: AppTheme.primaryGreen),
        );
        break;
      case 4:
      // Marketplace - por implementar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Próximamente: Marketplace'), backgroundColor: AppTheme.primaryGreen),
        );
        break;
      case 5:
        context.push(RouteNames.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Buenos días, Ángel',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkCoffee,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tu producción está creciendo correctamente',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.darkCoffee.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () => context.push(RouteNames.notifications),
                          icon: Icon(Icons.notifications_outlined, color: AppTheme.darkCoffee),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => context.push(RouteNames.profile),
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Center(
                          child: Icon(Icons.person, color: AppTheme.primaryGreen, size: 24),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // KPIs
                      Row(
                        children: [
                          for (int i = 0; i < _kpis.length; i++)
                            if (i < 2) ...[
                              KPICard(
                                title: _kpis[i].title,
                                value: _kpis[i].value,
                                icon: _kpis[i].icon,
                                color: _kpis[i].color,
                                change: _kpis[i].change,
                              ),
                              if (i == 0) const SizedBox(width: 12),
                            ],
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          for (int i = 2; i < _kpis.length; i++)
                            if (i < 4) ...[
                              KPICard(
                                title: _kpis[i].title,
                                value: _kpis[i].value,
                                icon: _kpis[i].icon,
                                color: _kpis[i].color,
                                change: _kpis[i].change,
                              ),
                              if (i == 2) const SizedBox(width: 12),
                            ],
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Gráfica
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
                        child: ProductionChart(data: _productionData),
                      ),

                      const SizedBox(height: 24),

                      // Alertas
                      Row(
                        children: [
                          const Text(
                            'Alertas Inteligentes',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkCoffee,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Ver todas'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ..._alerts.map((alert) => AlertCard(alert: alert)),

                      const SizedBox(height: 24),

                      // Acciones rápidas
                      const Text(
                        'Acciones Rápidas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkCoffee,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 16,
                        alignment: WrapAlignment.start,
                        children: [
                          QuickActionButton(
                            title: 'Registrar Actividad',
                            icon: Icons.add_task,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Próximamente: Registrar Actividad'), backgroundColor: AppTheme.primaryGreen),
                              );
                            },
                          ),
                          QuickActionButton(
                            title: 'Registrar Costo',
                            icon: Icons.attach_money,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Próximamente: Registrar Costo'), backgroundColor: AppTheme.primaryGreen),
                              );
                            },
                          ),
                          QuickActionButton(
                            title: 'Crear Lote',
                            icon: Icons.view_module,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Próximamente: Crear Lote'), backgroundColor: AppTheme.primaryGreen),
                              );
                            },
                          ),
                          QuickActionButton(
                            title: 'Ver Trazabilidad',
                            icon: Icons.qr_code,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Próximamente: Ver Trazabilidad'), backgroundColor: AppTheme.primaryGreen),
                              );
                            },
                          ),
                          QuickActionButton(
                            title: 'Ver Costos',
                            icon: Icons.analytics,
                            onPressed: () {
                              context.push(RouteNames.costs);
                            },
                          ),
                          QuickActionButton(
                            title: 'Escanear QR',
                            icon: Icons.qr_code_scanner,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Próximamente: Escanear QR'), backgroundColor: AppTheme.primaryGreen),
                              );
                            },
                          ),
                          QuickActionButton(
                            title: 'Ver Indicadores',
                            icon: Icons.analytics,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Próximamente: Ver Indicadores'), backgroundColor: AppTheme.primaryGreen),
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Mis Fincas
                      Row(
                        children: [
                          const Text(
                            'Mis Fincas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkCoffee,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => context.go(RouteNames.myFarms),
                            child: const Text('Ver todas'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ..._farms.map((farm) => FarmCard(farm: farm)),

                      const SizedBox(height: 24),

                      // Actividad reciente
                      const Text(
                        'Actividad Reciente',
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
                        child: ActivityTimeline(activities: _activities),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
          onTap: _onNavigationTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.primaryGreen,
          unselectedItemColor: AppTheme.darkCoffee.withOpacity(0.5),
          selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
            BottomNavigationBarItem(icon: Icon(Icons.landscape), label: 'Fincas'),
            BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Costos'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Indicadores'),
            BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Marketplace'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}