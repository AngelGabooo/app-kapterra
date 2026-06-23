import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/providers/farm_provider.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';
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

  final List<AlertModel> _alerts = [];
  final List<ActivityModel> _activities = [];
  final List<double> _productionData = [10.0, 15.0, 8.0, 20.0, 15.0];

  // Función necesaria para convertir el estado del Provider al modelo de resumen
  FarmStatus _mapStatusToSummary(FarmHealthStatus status) {
    switch (status) {
      case FarmHealthStatus.attention: return FarmStatus.attention;
      case FarmHealthStatus.risk: return FarmStatus.risk;
      default: return FarmStatus.healthy;
    }
  }

  void _onNavigationTap(int index) {
    setState(() => _currentIndex = index);
    switch (index) {
      case 0: context.go(RouteNames.dashboard); break;
      case 1: context.go(RouteNames.myFarms); break;
      case 2: context.push(RouteNames.costs); break;
      case 3: ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Próximamente: Indicadores'), backgroundColor: Theme.of(context).colorScheme.primary)); break;
      case 4: ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Próximamente: Marketplace'), backgroundColor: Theme.of(context).colorScheme.primary)); break;
      case 5: context.push(RouteNames.profile); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Conexión con el Provider
    final farmProvider = Provider.of<FarmProvider>(context);
    final farms = farmProvider.farms;

    // KPIs Dinámicos
    final totalLots = farms.fold(0, (sum, f) => sum + f.lots);
    final totalProd = farms.fold(0.0, (sum, f) => sum + (f.productivity * f.hectares));

    final List<KPIModel> kpis = [
      KPIModel(title: 'Producción Total', value: '${totalProd.toStringAsFixed(0)} kg', icon: Icons.grain_rounded, color: Colors.green, change: 0),
      KPIModel(title: 'Costos Acumulados', value: '\$0.00', icon: Icons.wallet_rounded, color: Colors.orange, change: 0),
      KPIModel(title: 'Rentabilidad', value: '0%', icon: Icons.bolt_rounded, color: Colors.teal, change: 0),
      KPIModel(title: 'Lotes Activos', value: '$totalLots Lotes', icon: Icons.grid_goldenratio_rounded, color: Colors.brown, change: 0),
    ];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [theme.scaffoldBackgroundColor, theme.colorScheme.primary.withOpacity(isDark ? 0.01 : 0.02), theme.scaffoldBackgroundColor])),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFFF6B00).withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Text('ECOSISTEMA / EN ESPERA', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFFFF6B00), letterSpacing: 1.5))),
                          const SizedBox(height: 8),
                          Text('Ángel Gabriel', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface, letterSpacing: -1.2, height: 1.0)),
                          const SizedBox(height: 4),
                          Text('Registra tu primera actividad para comenzar', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: theme.colorScheme.onSurface.withOpacity(0.5))),
                        ],
                      ),
                    ),
                    GestureDetector(onTap: () => context.push(RouteNames.notifications), child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.08))), child: Icon(Icons.analytics_outlined, color: theme.colorScheme.primary, size: 24))),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 11, child: KPICard(kpi: kpis[0], height: 156, useNeonAccent: true)), const SizedBox(width: 12), Expanded(flex: 9, child: Column(mainAxisSize: MainAxisSize.min, children: [KPICard(kpi: kpis[1], height: 72), const SizedBox(height: 12), KPICard(kpi: kpis[2], height: 72)]))]),
                      const SizedBox(height: 12),
                      Row(children: [Expanded(child: KPICard(kpi: kpis[3], height: 72))]),
                      const SizedBox(height: 24),
                      Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(30), border: Border.all(color: theme.colorScheme.onSurface.withOpacity(isDark ? 0.05 : 0.08))), child: ProductionChart(data: _productionData)),
                      const SizedBox(height: 28),
                      Text('COMANDOS RÁPIDOS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface.withOpacity(0.35), letterSpacing: 1.0)),
                      const SizedBox(height: 12),
                      SizedBox(height: 54, child: ListView(scrollDirection: Axis.horizontal, physics: const BouncingScrollPhysics(), children: [QuickActionButton(title: 'Registrar Actividad', icon: Icons.add_task, onPressed: () => context.push(RouteNames.activities)), const SizedBox(width: 10), QuickActionButton(title: 'Registrar Costo', icon: Icons.attach_money, onPressed: () => context.push(RouteNames.costs)), const SizedBox(width: 10), QuickActionButton(title: 'Crear Lote', icon: Icons.view_module, onPressed: () => context.go(RouteNames.myFarms)), const SizedBox(width: 10), QuickActionButton(title: 'Ver Trazabilidad', icon: Icons.qr_code, onPressed: () => context.push(RouteNames.activities))])),
                      const SizedBox(height: 28),
                      Text('Alertas Inteligentes', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface, letterSpacing: -0.4)),
                      const SizedBox(height: 10),
                      _alerts.isEmpty ? Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: theme.colorScheme.surface.withOpacity(0.5), borderRadius: BorderRadius.circular(20), border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.04))), child: Row(children: [Icon(Icons.shield_outlined, color: theme.colorScheme.primary.withOpacity(0.5), size: 20), const SizedBox(width: 12), Expanded(child: Text('Sin riesgos fitosanitarios ni alertas pendientes.', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withOpacity(0.4))))])) : Column(children: _alerts.map((alert) => AlertCard(alert: alert)).toList()),
                      const SizedBox(height: 24),
                      Row(children: [Text('Mis Fincas', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface, letterSpacing: -0.4)), const Spacer(), TextButton(onPressed: () => context.go(RouteNames.myFarms), style: TextButton.styleFrom(foregroundColor: theme.colorScheme.tertiary), child: const Text('Ver todas', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)))]),
                      const SizedBox(height: 8),

                      // Renderizado dinámico con mapeo de modelos
                      farms.isEmpty
                          ? Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(24), border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.06))), child: const Column(children: [Text('Aún no tienes fincas registradas', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)), Text('Agrega tu espacio de cultivo.', style: TextStyle(fontSize: 11))]))
                          : Column(children: farms.map((f) => FarmCard(
                          farm: FarmSummaryModel(name: f.name, hectares: f.hectares, production: f.productivity, status: _mapStatusToSummary(f.status))
                      )).toList()),

                      const SizedBox(height: 110),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(decoration: BoxDecoration(color: theme.colorScheme.surface, border: Border(top: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.06), width: 1))), child: BottomNavigationBar(currentIndex: _currentIndex, onTap: _onNavigationTap, type: BottomNavigationBarType.fixed, backgroundColor: theme.colorScheme.surface, selectedItemColor: const Color(0xFFFF6B00), unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.35), selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900), unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700), elevation: 0, items: const [BottomNavigationBarItem(icon: Icon(Icons.widgets_outlined), label: 'Inicio'), BottomNavigationBarItem(icon: Icon(Icons.landscape_rounded), label: 'Fincas'), BottomNavigationBarItem(icon: Icon(Icons.attach_money_rounded), label: 'Costos'), BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: 'Indicadores'), BottomNavigationBarItem(icon: Icon(Icons.storefront_rounded), label: 'Marketplace'), BottomNavigationBarItem(icon: Icon(Icons.face_rounded), label: 'Perfil')])),
    );
  }
}