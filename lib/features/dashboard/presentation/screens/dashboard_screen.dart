// lib/features/dashboard/presentation/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/providers/farm_provider.dart';
import 'package:kaabcafe/core/providers/user_provider.dart';
import 'package:kaabcafe/core/providers/appointment_provider.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/aurora_background.dart';
import 'package:kaabcafe/core/widgets/glass_widgets.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';
import 'package:kaabcafe/core/mixins/session_timeout_mixin.dart';
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
import '../../../auth/data/models/user_type_model.dart';
import '../widgets/contact_producer/contact_producer_card.dart';
import '../../../../core/routes/route_names.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SessionTimeoutMixin {
  int _currentIndex = 0;

  final List<AlertModel> _alerts = [];
  final List<ActivityModel> _activities = [];
  final List<double> _productionData = [10.0, 15.0, 8.0, 20.0, 15.0];

  @override
  void initState() {
    super.initState();

    // ✅ Verificar que el teléfono está guardado al iniciar el Dashboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      debugPrint('📞 Teléfono del usuario en Dashboard: ${userProvider.userPhone}');
      debugPrint('👤 Nombre: ${userProvider.userName}');
      debugPrint('📧 Email: ${userProvider.userEmail}');
      debugPrint('🎯 Rol: ${userProvider.selectedUserType?.title ?? 'No seleccionado'}');
    });

    initSessionTimeout(
      onTimeout: () {
        debugPrint('⏰ Timeout ejecutado desde Dashboard');
      },
    );
  }

  FarmStatus _mapStatusToSummary(FarmHealthStatus status) {
    switch (status) {
      case FarmHealthStatus.attention:
        return FarmStatus.attention;
      case FarmHealthStatus.risk:
        return FarmStatus.risk;
      default:
        return FarmStatus.healthy;
    }
  }

  void _onNavigationTap(int index) {
    setState(() => _currentIndex = index);
    resetTimeout();

    switch (index) {
      case 0:
        context.go(RouteNames.dashboard);
        break;
      case 1:
        context.go(RouteNames.myFarms);
        break;
      case 2:
        context.push(RouteNames.costs);
        break;
      case 3:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Próximamente: Indicadores'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        break;
      case 4:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Próximamente: Marketplace'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        break;
      case 5:
        context.push(RouteNames.profileDashboard);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final accentColor = isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen;

    // ✅ Obtener el nombre del usuario desde UserProvider
    final userProvider = Provider.of<UserProvider>(context);
    final userName = userProvider.userName ?? 'Usuario';
    final userEmail = userProvider.userEmail;

    // ✅ Obtener citas pendientes
    final appointmentProvider = Provider.of<AppointmentProvider>(context);
    final pendingCount = appointmentProvider.pendingAppointments.length;

    final farmProvider = Provider.of<FarmProvider>(context);
    final farms = farmProvider.farms;

    final totalLots = farms.fold(0, (sum, f) => sum + f.lots);
    final totalProd = farms.fold(0.0, (sum, f) => sum + (f.productivity * f.hectares));

    // ✅ Determinar el saludo según la hora del día
    final hour = DateTime.now().hour;
    String greeting = 'Buenos días';
    if (hour >= 12 && hour < 18) {
      greeting = 'Buenas tardes';
    } else if (hour >= 18) {
      greeting = 'Buenas noches';
    }

    final List<KPIModel> kpis = [
      KPIModel(
        title: 'Producción Total',
        value: '${totalProd.toStringAsFixed(0)} kg',
        icon: Icons.grain_rounded,
        color: Colors.green,
        change: 0,
      ),
      KPIModel(
        title: 'Costos Acumulados',
        value: '\$0.00',
        icon: Icons.wallet_rounded,
        color: Colors.orange,
        change: 0,
      ),
      KPIModel(
        title: 'Rentabilidad',
        value: '0%',
        icon: Icons.bolt_rounded,
        color: Colors.teal,
        change: 0,
      ),
      KPIModel(
        title: 'Lotes Activos',
        value: '$totalLots Lotes',
        icon: Icons.grid_goldenratio_rounded,
        color: Colors.brown,
        change: 0,
      ),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: resetTimeout,
        onPanDown: (_) => resetTimeout(),
        child: AuroraBackground(
          isDark: isDark,
          child: SafeArea(
            child: Column(
              children: [
                // ── Header ──────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6B00).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'ECOSISTEMA / EN ESPERA',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFFF6B00),
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // ✅ Mostrar el nombre del usuario con saludo
                            Text(
                              '$greeting, $userName',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: textColor,
                                letterSpacing: -1.2,
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userEmail != null && userEmail.isNotEmpty
                                  ? userEmail
                                  : 'Registra tu primera actividad para comenzar',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: textColor.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ✅ Botón de Notificaciones con Badge
                      _buildNotificationButton(isDark, accentColor, pendingCount),
                      const SizedBox(width: 8),
                      // ✅ Botón de Perfil
                      NeumorphicIconButton(
                        icon: Icons.person_outline,
                        isDark: isDark,
                        onPressed: () {
                          resetTimeout();
                          context.push(RouteNames.profileDashboard);
                        },
                        size: 44,
                        iconSize: 20,
                        color: accentColor,
                      ),
                    ],
                  ),
                ),
                // ── Contenido ────────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        // ── KPIs ──────────────────────────────────
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 11,
                              child: KPICard(
                                kpi: kpis[0],
                                height: 156,
                                useNeonAccent: true,
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 9,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  KPICard(
                                    kpi: kpis[1],
                                    height: 72,
                                    isDark: isDark,
                                  ),
                                  const SizedBox(height: 12),
                                  KPICard(
                                    kpi: kpis[2],
                                    height: 72,
                                    isDark: isDark,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: KPICard(
                                kpi: kpis[3],
                                height: 72,
                                isDark: isDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // ── Gráfico ──────────────────────────────────
                        LiquidGlassCard(
                          isDark: isDark,
                          radius: 30,
                          padding: const EdgeInsets.all(24),
                          child: ProductionChart(data: _productionData),
                        ),
                        const SizedBox(height: 28),
                        // ── Comandos Rápidos ──────────────────────────
                        Text(
                          'COMANDOS RÁPIDOS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: textColor.withOpacity(0.35),
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 58,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              NeumorphicActionButton(
                                label: 'Registrar Actividad',
                                icon: Icons.add_task,
                                isDark: isDark,
                                onPressed: () {
                                  resetTimeout();
                                  context.push(RouteNames.activities);
                                },
                              ),
                              const SizedBox(width: 10),
                              NeumorphicActionButton(
                                label: 'Registrar Costo',
                                icon: Icons.attach_money,
                                isDark: isDark,
                                onPressed: () {
                                  resetTimeout();
                                  context.push(RouteNames.costs);
                                },
                              ),
                              const SizedBox(width: 10),
                              NeumorphicActionButton(
                                label: 'Crear Lote',
                                icon: Icons.view_module,
                                isDark: isDark,
                                onPressed: () {
                                  resetTimeout();
                                  context.go(RouteNames.myFarms);
                                },
                              ),
                              const SizedBox(width: 10),
                              NeumorphicActionButton(
                                label: 'Ver Trazabilidad',
                                icon: Icons.qr_code,
                                isDark: isDark,
                                onPressed: () {
                                  resetTimeout();
                                  context.push(RouteNames.activities);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        // ── Alertas ──────────────────────────────────
                        Text(
                          'Alertas Inteligentes',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: textColor,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _alerts.isEmpty
                            ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.coffeeDeep.withOpacity(0.7)
                                : Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: textColor.withOpacity(0.04),
                            ),
                            boxShadow: const [],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.shield_outlined,
                                color: accentColor.withOpacity(0.5),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Sin riesgos fitosanitarios ni alertas pendientes.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: textColor.withOpacity(0.4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                            : Column(
                          children: _alerts
                              .map((alert) => AlertCard(alert: alert))
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                        // ── Mis Fincas ──────────────────────────────
                        Row(
                          children: [
                            Text(
                              'Mis Fincas',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: textColor,
                                letterSpacing: -0.4,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                resetTimeout();
                                context.go(RouteNames.myFarms);
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: accentColor,
                              ),
                              child: const Text(
                                'Ver todas',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // ── Lista de Fincas ──────────────────────────
                        farms.isEmpty
                            ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.coffeeDeep.withOpacity(0.7)
                                : Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: textColor.withOpacity(0.06),
                            ),
                            boxShadow: const [],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Aún no tienes fincas registradas',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                'Agrega tu espacio de cultivo.',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: textColor.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        )
                            : Column(
                          children: farms.map((f) => FarmCard(
                            farm: FarmSummaryModel(
                              name: f.name,
                              hectares: f.hectares,
                              production: f.productivity,
                              status: _mapStatusToSummary(f.status),
                            ),
                            isDark: isDark,
                          )).toList(),
                        ),
                        const SizedBox(height: 16),

                        // ── Contactar a un productor ────────────────
                        ContactProducerCard(isDark: isDark),

                        const SizedBox(height: 110),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NeumorphicBottomNav(
        isDark: isDark,
        currentIndex: _currentIndex,
        items: const [
          Icons.widgets_outlined,
          Icons.landscape_rounded,
          Icons.attach_money_rounded,
          Icons.analytics_outlined,
          Icons.storefront_rounded,
          Icons.face_rounded,
        ],
        onTap: _onNavigationTap,
      ),
    );
  }

  /// ✅ Widget para el botón de notificaciones con badge
  Widget _buildNotificationButton(bool isDark, Color accentColor, int pendingCount) {
    if (pendingCount > 0) {
      return Stack(
        children: [
          NeumorphicIconButton(
            icon: Icons.notifications_outlined,
            isDark: isDark,
            onPressed: () {
              resetTimeout();
              context.push(RouteNames.notifications);
            },
            size: 44,
            iconSize: 20,
            color: accentColor,
          ),
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                pendingCount > 9 ? '9+' : '$pendingCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }

    return NeumorphicIconButton(
      icon: Icons.notifications_outlined,
      isDark: isDark,
      onPressed: () {
        resetTimeout();
        context.push(RouteNames.notifications);
      },
      size: 44,
      iconSize: 20,
      color: accentColor,
    );
  }
}