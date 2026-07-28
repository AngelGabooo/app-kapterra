// lib/features/technician/presentation/screens/technician_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/providers/appointment_provider.dart';
import 'package:kaabcafe/core/providers/user_provider.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/glass_widgets.dart';
import 'package:kaabcafe/core/widgets/aurora_background.dart';
// ✅ Importar SOLO el modelo de technician_visit_model.dart
import 'package:kaabcafe/features/technician/data/models/technician_visit_model.dart';
// ✅ Importar los modelos de technician_model.dart (pero no TechnicianVisitModel)
import 'package:kaabcafe/features/technician/data/models/technician_model.dart' show TechnicianProducerModel, TechnicianAlertModel;
import 'package:kaabcafe/features/technician/presentation/widgets/technician_kpi_card.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/alert_card.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/producer_card.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/join_cooperative_dialog.dart';
import 'package:kaabcafe/features/technician/providers/technician_visits_provider.dart';
import 'package:kaabcafe/features/technician/providers/technician_producers_provider.dart';

class TechnicianDashboardScreen extends StatefulWidget {
  const TechnicianDashboardScreen({super.key});
  @override
  State<TechnicianDashboardScreen> createState() => _TechnicianDashboardScreenState();
}

class _TechnicianDashboardScreenState extends State<TechnicianDashboardScreen> {
  int _currentIndex = 0;

  final List<TechnicianAlertModel> _alerts = [];
  final List<String> _pendingTasks = [];

  void _navigateToVisitRegistration([Map<String, dynamic>? visitData]) {
    context.push(
      RouteNames.technicianVisitRegistration,
      extra: visitData ?? {
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

  void _showJoinCooperativeDialog() {
    showDialog(
      context: context,
      builder: (context) => const JoinCooperativeDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final accent = isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen;

    final appointmentProvider = Provider.of<AppointmentProvider>(context);
    final pendingCount = appointmentProvider.pendingAppointments.length;

    final visitsProvider = Provider.of<TechnicianVisitsProvider>(context);
    final allVisits = visitsProvider.visits;
    final pendingVisits = allVisits.where((v) => v.status == 'pending').toList();
    final nextVisit = pendingVisits.isNotEmpty ? pendingVisits.first : null;
    final completedVisits = visitsProvider.completedCount;

    final producersProvider = Provider.of<TechnicianProducersProvider>(context);
    final producers = producersProvider.producers;

    return Scaffold(
      extendBody: true,
      backgroundColor: AppTheme.neuBase(isDark),
      body: AuroraBackground(
        isDark: isDark,
        child: SafeArea(
          child: Column(
            children: [
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
                              nextVisit != null
                                  ? 'Tienes una visita programada para hoy'
                                  : 'No tienes actividades programadas para hoy.',
                              style: TextStyle(fontSize: 12.5, color: textColor.withOpacity(0.6)),
                            ),
                          ],
                        ),
                      ),
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

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),

                      _buildJoinCooperativeButton(isDark, textColor),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          TechnicianKPICard(
                            title: 'Productores',
                            value: '${producersProvider.count}',
                            icon: Icons.people,
                            color: AppTheme.primaryGreen,
                            isDark: isDark,
                            change: producersProvider.count.toDouble(),
                          ),
                          const SizedBox(width: 12),
                          TechnicianKPICard(
                            title: 'Visitas',
                            value: '${visitsProvider.totalVisits}',
                            icon: Icons.assignment,
                            color: AppTheme.secondaryGreen,
                            isDark: isDark,
                            change: visitsProvider.totalVisits.toDouble(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          TechnicianKPICard(
                            title: 'Pendientes',
                            value: '${visitsProvider.pendingCount}',
                            icon: Icons.pending,
                            color: AppTheme.alertOrange,
                            isDark: isDark,
                            change: visitsProvider.pendingCount.toDouble(),
                          ),
                          const SizedBox(width: 12),
                          TechnicianKPICard(
                            title: 'Completadas',
                            value: '$completedVisits',
                            icon: Icons.check_circle,
                            color: AppTheme.secondaryGreen,
                            isDark: isDark,
                            change: completedVisits.toDouble(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),

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
                            if (pendingVisits.isNotEmpty)
                              _buildTodayVisits(pendingVisits, isDark, textColor)
                            else
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

                      if (nextVisit != null)
                        _buildNextVisitCard(nextVisit, isDark, textColor)
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

                      Row(
                        children: [
                          Text(
                            'Productores destacados',
                            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: textColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (producers.isEmpty)
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
                            itemCount: producers.length > 5 ? 5 : producers.length,
                            itemBuilder: (context, index) {
                              final producer = producers[index];
                              return TechnicianProducerCard(
                                producer: producer,
                                isDark: isDark,
                                onTap: () {
                                  context.push(RouteNames.technicianProducers);
                                },
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 22),

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
          onPressed: _navigateToVisitRegistration,
        ),
      ),
      bottomNavigationBar: GlassBottomNav(
        isDark: isDark,
        currentIndex: _currentIndex,
        items: const [
          Icons.home,
          Icons.people,
          Icons.calendar_today,
          Icons.analytics,
          Icons.person,
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 0) {
            context.go(RouteNames.technicianDashboard);
          } else if (index == 1) {
            context.go(RouteNames.technicianProducers);
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

  // ✅ Método corregido - ahora recibe List<TechnicianVisitModel>
  Widget _buildTodayVisits(List<TechnicianVisitModel> visits, bool isDark, Color textColor) {
    return Column(
      children: visits.take(3).map((visit) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark
                ? AppTheme.coffeeDeep.withOpacity(0.3)
                : const Color(0xFFF5F0E8).withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    visit.producerName.split(' ').map((e) => e[0]).take(2).join().toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      visit.producerName,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${_formatTime(visit.visitDate)} • ${visit.objective}',
                      style: TextStyle(
                        fontSize: 11,
                        color: textColor.withOpacity(0.5),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  _navigateToVisitRegistration({
                    'producerName': visit.producerName,
                    'farmName': visit.farmName,
                    'lotName': visit.lotName,
                    'location': visit.location,
                    'visitId': visit.id,
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(color: AppTheme.primaryGreen.withOpacity(0.3)),
                ),
                child: Text(
                  'Iniciar',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNextVisitCard(TechnicianVisitModel visit, bool isDark, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.coffeeDeep.withOpacity(0.7)
            : const Color(0xFFE8E0D5).withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : AppTheme.darkCoffee.withOpacity(0.04),
          width: 0.5,
        ),
        boxShadow: const [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.star,
                  color: AppTheme.goldCoffee,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Próxima visita',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      visit.producerName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  if (visit.isUrgent)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.berryRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Urgente',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.berryRed,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: textColor.withOpacity(0.4)),
                  const SizedBox(width: 4),
                  Text(
                    visit.location,
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: textColor.withOpacity(0.4)),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(visit.visitDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.flag, size: 14, color: textColor.withOpacity(0.4)),
                  const SizedBox(width: 4),
                  Text(
                    visit.objective,
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _navigateToVisitRegistration({
                          'producerName': visit.producerName,
                          'farmName': visit.farmName,
                          'lotName': visit.lotName,
                          'location': visit.location,
                          'visitId': visit.id,
                        });
                      },
                      icon: const Icon(Icons.play_arrow, size: 16),
                      label: const Text('Iniciar visita'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: AppTheme.primaryGreen.withOpacity(0.3)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.info_outline, size: 16),
                    label: const Text('Detalles'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textColor.withOpacity(0.6),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: textColor.withOpacity(0.1)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

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

  Widget _buildJoinCooperativeButton(bool isDark, Color textColor) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryGreen.withOpacity(0.1),
            AppTheme.goldCoffee.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryGreen.withOpacity(0.2),
        ),
      ),
      child: GestureDetector(
        onTap: _showJoinCooperativeDialog,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.engineering_outlined,
                  color: AppTheme.primaryGreen,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Unirse a una Cooperativa',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    Text(
                      'Encuentra una cooperativa para trabajar',
                      style: TextStyle(
                        fontSize: 11,
                        color: textColor.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.primaryGreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}