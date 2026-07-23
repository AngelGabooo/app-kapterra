// lib/features/technician/presentation/screens/technician_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/providers/appointment_provider.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/glass_widgets.dart';
import 'package:kaabcafe/core/widgets/aurora_background.dart';
import 'package:kaabcafe/features/technician/data/models/technician_model.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/technician_kpi_card.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/next_visit_card.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/alert_card.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/producer_card.dart';

class TechnicianDashboardScreen extends StatefulWidget {
  const TechnicianDashboardScreen({super.key});
  @override
  State<TechnicianDashboardScreen> createState() => _TechnicianDashboardScreenState();
}

class _TechnicianDashboardScreenState extends State<TechnicianDashboardScreen> {
  int _currentIndex = 0;

  // ✅ TODOS LOS DATOS VACÍOS
  final List<TechnicianProducerModel> _producers = [];

  final List<TechnicianVisitModel> _visits = [];

  final List<TechnicianAlertModel> _alerts = [];

  final List<String> _pendingTasks = [];

  void _navigateToVisitRegistration() {
    context.push(
      RouteNames.technicianVisitRegistration,
      extra: {
        'producerName': 'Productor',
        'farmName': 'Finca',
        'lotName': 'Lote',
        'location': 'Ubicación',
      },
    );
  }

  void _navigateToCropDiagnosis() {
    context.push(
      RouteNames.technicianCropDiagnosis,
      extra: {
        'lotName': 'Lote',
        'farmName': 'Finca',
        'producerName': 'Productor',
        'location': 'Ubicación',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final accent = isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen;

    // ✅ Obtener citas pendientes
    final appointmentProvider = Provider.of<AppointmentProvider>(context);
    final pendingCount = appointmentProvider.pendingAppointments.length;

    return Scaffold(
      extendBody: true,
      backgroundColor: AppTheme.neuBase(isDark),
      body: AuroraBackground(
        isDark: isDark,
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: LiquidGlassCard(
                  isDark: isDark,
                  radius: 26,
                  padding: const EdgeInsets.fromLTRB(20, 16, 14, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Buenos días, Técnico',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: textColor,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'No tienes actividades programadas para hoy.',
                              style: TextStyle(fontSize: 12.5, color: textColor.withOpacity(0.6)),
                            ),
                          ],
                        ),
                      ),
                      // ✅ Botón de Notificaciones con Badge
                      _buildNotificationButton(isDark, accent, pendingCount),
                      const SizedBox(width: 8),
                      GlowIconButton(
                        icon: Icons.person_outline,
                        isDark: isDark,
                        onPressed: () => context.push(RouteNames.profile),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Contenido ────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      // ✅ KPIs - TODOS EN 0
                      Row(
                        children: [
                          TechnicianKPICard(
                            title: 'Productores',
                            value: '0',
                            icon: Icons.people,
                            color: AppTheme.primaryGreen,
                            isDark: isDark,
                            change: 0,
                          ),
                          const SizedBox(width: 12),
                          TechnicianKPICard(
                            title: 'Fincas',
                            value: '0',
                            icon: Icons.landscape,
                            color: AppTheme.secondaryGreen,
                            isDark: isDark,
                            change: 0,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          TechnicianKPICard(
                            title: 'Lotes activos',
                            value: '0',
                            icon: Icons.view_module,
                            color: AppTheme.goldCoffee,
                            isDark: isDark,
                            change: 0,
                          ),
                          const SizedBox(width: 12),
                          TechnicianKPICard(
                            title: 'Alertas',
                            value: '0',
                            icon: Icons.warning,
                            color: AppTheme.berryRed,
                            isDark: isDark,
                            change: 0,
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),

                      // ✅ Actividad del día - VACÍA
                      LiquidGlassCard(
                        isDark: isDark,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.primaryGreen.withOpacity(0.14),
                                  ),
                                  child: const Icon(Icons.calendar_today, color: AppTheme.primaryGreen, size: 16),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Actividad del día',
                                  style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: textColor),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    context.go(RouteNames.technicianAgenda);
                                  },
                                  child: Text('Ver Agenda', style: TextStyle(color: accent, fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            // ✅ Mostrar mensaje de vacío
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Icon(Icons.calendar_today_outlined,
                                    size: 32,
                                    color: textColor.withOpacity(0.2),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Sin actividades programadas',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: textColor.withOpacity(0.4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),

                      // ✅ Próxima visita - VACÍA
                      if (_visits.isNotEmpty)
                        NextVisitCard(
                          visit: _visits.first,
                          isDark: isDark,
                          onStartVisit: () {
                            _navigateToVisitRegistration();
                          },
                          onViewProducer: () {},
                        )
                      else
                        LiquidGlassCard(
                          isDark: isDark,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            width: double.infinity,
                            child: Column(
                              children: [
                                Icon(Icons.assignment_outlined,
                                  size: 32,
                                  color: textColor.withOpacity(0.2),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Sin visitas programadas',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: textColor.withOpacity(0.4),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                OutlinedButton.icon(
                                  onPressed: _navigateToVisitRegistration,
                                  icon: const Icon(Icons.add, size: 16),
                                  label: const Text('Programar visita'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppTheme.primaryGreen,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 70),

                      // ✅ Alertas - VACÍAS
                      Row(
                        children: [
                          Text(
                            'Alertas prioritarias',
                            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: textColor),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: Text('Ver todas', style: TextStyle(color: accent, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (_alerts.isEmpty)
                        LiquidGlassCard(
                          isDark: isDark,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle_outline,
                                  color: AppTheme.primaryGreen.withOpacity(0.3),
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Sin alertas pendientes',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: textColor.withOpacity(0.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ..._alerts.map((alert) => TechnicianAlertCard(alert: alert, isDark: isDark)),
                      const SizedBox(height: 12),

                      // ✅ Productores destacados - VACÍOS
                      Row(
                        children: [
                          Text(
                            'Productores destacados',
                            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: textColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_producers.isEmpty)
                        LiquidGlassCard(
                          isDark: isDark,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            width: double.infinity,
                            child: Column(
                              children: [
                                Icon(Icons.people_outline,
                                  size: 32,
                                  color: textColor.withOpacity(0.2),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Sin productores registrados',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: textColor.withOpacity(0.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          height: 190,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _producers.length,
                            itemBuilder: (context, index) {
                              return TechnicianProducerCard(
                                producer: _producers[index],
                                isDark: isDark,
                                onTap: () {},
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 22),

                      // ✅ Recordatorios - VACÍOS
                      ClayCard(
                        isDark: isDark,
                        accent: AppTheme.goldCoffee,
                        radius: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white24,
                                  ),
                                  child: const Icon(Icons.task_alt, color: Colors.white, size: 16),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Recordatorios',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : AppTheme.darkCoffee,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            if (_pendingTasks.isEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    'Sin recordatorios pendientes',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: (isDark ? Colors.white : AppTheme.darkCoffee).withOpacity(0.4),
                                    ),
                                  ),
                                ),
                              )
                            else
                              ..._pendingTasks.map((task) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        task,
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          color: (isDark ? Colors.white : AppTheme.darkCoffee).withOpacity(0.85),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: GlassFAB(
          label: 'Nueva Visita',
          icon: Icons.add,
          isDark: isDark,
          onPressed: () {
            _navigateToVisitRegistration();
          },
        ),
      ),
      // ── Bottom Navigation Bar ──────────────────────────────────
      bottomNavigationBar: GlassBottomNav(
        isDark: isDark,
        currentIndex: _currentIndex,
        items: const [
          Icons.home,           // ← Índice 0: Inicio (Dashboard)
          Icons.people,         // ← Índice 1: Productores
          Icons.calendar_today, // ← Índice 2: Agenda
          Icons.analytics,      // ← Índice 3: Diagnóstico / Reportes
          Icons.person,         // ← Índice 4: Perfil
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 0) {
            context.go(RouteNames.technicianDashboard);
          } else if (index == 1) {
            // context.go(RouteNames.technicianProducers);
          } else if (index == 2) {
            context.go(RouteNames.technicianAgenda);
          } else if (index == 3) {
            _navigateToCropDiagnosis();
          } else if (index == 4) {
            context.go(RouteNames.profile);
          }
        },
      ),
    );
  }

  /// ✅ Widget para el botón de notificaciones con badge
  Widget _buildNotificationButton(bool isDark, Color accentColor, int pendingCount) {
    if (pendingCount > 0) {
      return Stack(
        children: [
          GlowIconButton(
            icon: Icons.notifications_outlined,
            isDark: isDark,
            onPressed: () => context.push(RouteNames.notifications),
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

    return GlowIconButton(
      icon: Icons.notifications_outlined,
      isDark: isDark,
      onPressed: () => context.push(RouteNames.notifications),
    );
  }

  Widget _buildActivityItem(String emoji, String label, String value, bool isDark) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    return Expanded(
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
          Text(
            label,
            style: TextStyle(fontSize: 9, color: textColor.withOpacity(0.5)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}