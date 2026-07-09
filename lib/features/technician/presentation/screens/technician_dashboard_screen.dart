import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  final List<TechnicianProducerModel> _producers = [
    TechnicianProducerModel(
      id: '1',
      name: 'Juan Pérez',
      location: 'Motozintla, Chiapas',
      production: 1850,
      traceability: 96,
      status: ProducerStatus.excellent,
      lastVisit: 'Hace 3 días',
    ),
    TechnicianProducerModel(
      id: '2',
      name: 'María López',
      location: 'Tapachula, Chiapas',
      production: 1200,
      traceability: 78,
      status: ProducerStatus.requiresAttention,
      lastVisit: 'Hace 1 semana',
    ),
    TechnicianProducerModel(
      id: '3',
      name: 'Carlos Gómez',
      location: 'Ocosingo, Chiapas',
      production: 800,
      traceability: 45,
      status: ProducerStatus.risk,
      lastVisit: 'Hace 2 semanas',
    ),
  ];

  final List<TechnicianVisitModel> _visits = [
    TechnicianVisitModel(
      id: '1',
      producerName: 'Juan Pérez',
      location: 'Motozintla, Chiapas',
      time: '10:30 AM',
      objective: 'Inspección por riesgo de roya',
      isUrgent: true,
    ),
    TechnicianVisitModel(
      id: '2',
      producerName: 'María López',
      location: 'Tapachula, Chiapas',
      time: '02:00 PM',
      objective: 'Certificación de lote Geisha',
      isUrgent: false,
    ),
  ];

  final List<TechnicianAlertModel> _alerts = [
    TechnicianAlertModel(
      id: '1',
      title: 'Posible roya detectada',
      description: 'Lote Norte - Motozintla',
      isCritical: true,
      date: DateTime.now(),
    ),
    TechnicianAlertModel(
      id: '2',
      title: 'Productor sin actividad reciente',
      description: 'María López - 8 días sin registro',
      isCritical: false,
      date: DateTime.now(),
    ),
    TechnicianAlertModel(
      id: '3',
      title: 'Lote pendiente de certificación',
      description: 'Lote Geisha - Vence en 5 días',
      isCritical: true,
      date: DateTime.now(),
    ),
  ];

  final List<String> _pendingTasks = [
    'Certificar Lote Geisha',
    'Revisar humedad en Lote Norte',
    'Enviar recomendación a María López',
  ];

  void _navigateToVisitRegistration() {
    context.push(
      RouteNames.technicianVisitRegistration,
      extra: {
        'producerName': 'Juan Pérez',
        'farmName': 'El Mirador',
        'lotName': 'Lote Norte',
        'location': 'Motozintla, Chiapas',
      },
    );
  }

  // ✅ NUEVO: Navegar al Diagnóstico del Cultivo
  void _navigateToCropDiagnosis() {
    context.push(
      RouteNames.technicianCropDiagnosis,
      extra: {
        'lotName': 'Lote Norte',
        'farmName': 'El Mirador',
        'producerName': 'Juan Pérez',
        'location': 'Motozintla, Chiapas',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final accent = isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen;

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
                              'Buenos días, Carlos',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: textColor,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tienes 5 actividades programadas para hoy.',
                              style: TextStyle(fontSize: 12.5, color: textColor.withOpacity(0.6)),
                            ),
                          ],
                        ),
                      ),
                      GlowIconButton(
                        icon: Icons.notifications_outlined,
                        isDark: isDark,
                        onPressed: () => context.push(RouteNames.notifications),
                      ),
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
                      // KPIs
                      Row(
                        children: [
                          TechnicianKPICard(
                            title: 'Productores',
                            value: '42',
                            icon: Icons.people,
                            color: AppTheme.primaryGreen,
                            isDark: isDark,
                            change: 12.5,
                          ),
                          const SizedBox(width: 12),
                          TechnicianKPICard(
                            title: 'Fincas',
                            value: '97',
                            icon: Icons.landscape,
                            color: AppTheme.secondaryGreen,
                            isDark: isDark,
                            change: 5.3,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          TechnicianKPICard(
                            title: 'Lotes activos',
                            value: '168',
                            icon: Icons.view_module,
                            color: AppTheme.goldCoffee,
                            isDark: isDark,
                            change: 8.7,
                          ),
                          const SizedBox(width: 12),
                          TechnicianKPICard(
                            title: 'Alertas',
                            value: '11',
                            icon: Icons.warning,
                            color: AppTheme.berryRed,
                            isDark: isDark,
                            change: -2.1,
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),

                      // Actividad del día
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
                                    // ✅ Navegar a la agenda
                                    context.go(RouteNames.technicianAgenda);
                                  },
                                  child: Text('Ver Agenda', style: TextStyle(color: accent, fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                _buildActivityItem('👨‍🌾', 'Visitas', '3', isDark),
                                _buildActivityItem('🔍', 'Inspecciones', '2', isDark),
                                _buildActivityItem('🏅', 'Certificaciones', '1', isDark),
                                _buildActivityItem('💡', 'Recomendaciones', '4', isDark),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Próxima visita
                      if (_visits.isNotEmpty)
                        NextVisitCard(
                          visit: _visits.first,
                          isDark: isDark,
                          onStartVisit: () {
                            _navigateToVisitRegistration();
                          },
                          onViewProducer: () {},
                        ),
                      const SizedBox(height: 70),

                      // Alertas
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
                      ..._alerts.map((alert) => TechnicianAlertCard(alert: alert, isDark: isDark)),
                      const SizedBox(height: 12),

                      // Productores destacados
                      Row(
                        children: [
                          Text(
                            'Productores destacados',
                            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: textColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
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

                      // Recordatorios
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
          Icons.analytics,      // ← Índice 3: Diagnóstico / Reportes  ✅ NUEVA
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
            // ✅ CONEXIÓN: Navegar al Diagnóstico del Cultivo
            _navigateToCropDiagnosis();
          } else if (index == 4) {
            context.go(RouteNames.profile);
          }
        },
      ),
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