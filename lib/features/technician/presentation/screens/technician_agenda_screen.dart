import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/glass_widgets.dart';
import 'package:kaabcafe/core/widgets/aurora_background.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/agenda_visit_card.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/technician_kpi_card.dart';

class TechnicianAgendaScreen extends StatefulWidget {
  const TechnicianAgendaScreen({super.key});

  @override
  State<TechnicianAgendaScreen> createState() => _TechnicianAgendaScreenState();
}

class _TechnicianAgendaScreenState extends State<TechnicianAgendaScreen> {
  int _currentIndex = 2;
  String _selectedView = 'Diaria';

  final List<Map<String, dynamic>> _visits = [
    {
      'producerName': 'Juan Pérez',
      'farmName': 'El Mirador',
      'lotName': 'Lote Norte',
      'location': 'Motozintla, Chiapas',
      'time': '10:30 AM',
      'objective': 'Inspección por riesgo de roya',
      'status': 'Confirmada',
      'isUrgent': true,
    },
    {
      'producerName': 'María López',
      'farmName': 'La Esperanza',
      'lotName': 'Lote Geisha',
      'location': 'Tapachula, Chiapas',
      'time': '02:00 PM',
      'objective': 'Certificación de lote Geisha',
      'status': 'Pendiente',
      'isUrgent': false,
    },
    {
      'producerName': 'Carlos Gómez',
      'farmName': 'Los Naranjos',
      'lotName': 'Lote Sur',
      'location': 'Ocosingo, Chiapas',
      'time': '04:30 PM',
      'objective': 'Revisión de humedad en lote',
      'status': 'Reprogramar',
      'isUrgent': true,
    },
  ];

  final List<String> _viewOptions = ['Diaria', 'Semanal', 'Mensual'];
  final List<String> _pendingTasks = [
    '📌 Llevar medidor de humedad',
    '📌 Tomar fotografías del lote',
    '📌 Obtener firma del productor',
  ];

  void _navigateToVisitRegistration([Map<String, dynamic>? visitData]) {
    context.push(
      RouteNames.technicianVisitRegistration,
      extra: visitData ?? {
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
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Header Sliver ──────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
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
                                'Agenda de Visitas',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: textColor,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Organiza y administra tus recorridos.',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: textColor.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GlowIconButton(
                          icon: Icons.search,
                          isDark: isDark,
                          onPressed: () {},
                        ),
                        GlowIconButton(
                          icon: Icons.view_agenda,
                          isDark: isDark,
                          onPressed: () {},
                        ),
                        GlowIconButton(
                          icon: Icons.filter_list,
                          isDark: isDark,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── KPIs ────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        TechnicianKPICard(
                          title: 'Visitas programadas',
                          value: '5',
                          icon: Icons.calendar_today,
                          color: AppTheme.primaryGreen,
                          isDark: isDark,
                        ),
                        const SizedBox(width: 12),
                        TechnicianKPICard(
                          title: 'Completadas',
                          value: '2',
                          icon: Icons.check_circle,
                          color: AppTheme.secondaryGreen,
                          isDark: isDark,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        TechnicianKPICard(
                          title: 'Pendientes',
                          value: '3',
                          icon: Icons.pending,
                          color: AppTheme.alertOrange,
                          isDark: isDark,
                        ),
                        const SizedBox(width: 12),
                        TechnicianKPICard(
                          title: 'Requieren prioridad',
                          value: '2',
                          icon: Icons.warning,
                          color: AppTheme.berryRed,
                          isDark: isDark,
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                  ]),
                ),
              ),

              // ── Calendario ──────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    LiquidGlassCard(
                      isDark: isDark,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Calendario',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                ),
                              ),
                              const Spacer(),
                              ..._viewOptions.map((view) {
                                final isSelected = view == _selectedView;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedView = view;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    margin: const EdgeInsets.only(left: 6),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? accent.withOpacity(0.15)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Text(
                                      view,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? accent
                                            : textColor.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildCalendar(isDark, textColor, accent),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                  ]),
                ),
              ),

              // ── Próxima visita ──────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildNextVisitCard(isDark, textColor),
                    const SizedBox(height: 22),
                  ]),
                ),
              ),

              // ── Lista de visitas ────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Row(
                      children: [
                        Text(
                          'Todas las visitas',
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Ver todas',
                            style: TextStyle(
                              color: accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ]),
                ),
              ),

              // ── Tarjetas de visitas ─────────────────────────────
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final visit = _visits[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AgendaVisitCard(
                          producerName: visit['producerName'],
                          farmName: visit['farmName'],
                          location: visit['location'],
                          time: visit['time'],
                          objective: visit['objective'],
                          status: visit['status'],
                          isUrgent: visit['isUrgent'],
                          isDark: isDark,
                          onViewDetails: () {},
                          onStart: () {
                            _navigateToVisitRegistration({
                              'producerName': visit['producerName'],
                              'farmName': visit['farmName'],
                              'lotName': visit['lotName'] ?? 'Lote Principal',
                              'location': visit['location'],
                            });
                          },
                        ),
                      ),
                    );
                  },
                  childCount: _visits.length,
                ),
              ),

              // ── Recordatorios ────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 22),
                    ClayCard(
                      isDark: isDark,
                      accent: AppTheme.goldCoffee,
                      radius: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white24,
                                ),
                                child: const Icon(
                                  Icons.task_alt,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Recordatorios',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : AppTheme.darkCoffee,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ..._pendingTasks.map((task) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
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
                  ]),
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
          label: 'Programar Visita',
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

  Widget _buildNextVisitCard(bool isDark, Color textColor) {
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
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryGreen,
                      AppTheme.secondaryGreen,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    'JP',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Juan Pérez',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '🌱 El Mirador • ☕ Lote Norte',
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor.withOpacity(0.6),
                      ),
                    ),
                    Text(
                      '📍 Motozintla, Chiapas • 🕙 10:30 AM',
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
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.coffeeDark.withOpacity(0.3)
                  : const Color(0xFFF5F0E8).withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.task_alt,
                  size: 14,
                  color: AppTheme.primaryGreen,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Inspección por riesgo de roya',
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _navigateToVisitRegistration({
                      'producerName': 'Juan Pérez',
                      'farmName': 'El Mirador',
                      'lotName': 'Lote Norte',
                      'location': 'Motozintla, Chiapas',
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('▶ Iniciar visita'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.goldCoffee,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: BorderSide(
                      color: AppTheme.goldCoffee.withOpacity(0.3),
                      width: 1,
                    ),
                    elevation: 0,
                  ),
                  child: const Text('📍 Ver ruta'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(bool isDark, Color textColor, Color accent) {
    final days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    final dates = List.generate(7, (index) => index + 10);

    return Column(
      children: [
        Row(
          children: days.map((day) => Expanded(
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: textColor.withOpacity(0.5),
                ),
              ),
            ),
          )).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(7, (index) {
            final isToday = index == 2;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isToday
                      ? accent.withOpacity(0.15)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      '${dates[index]}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                        color: isToday ? accent : textColor.withOpacity(0.7),
                      ),
                    ),
                    if (index == 0 || index == 3)
                      Positioned(
                        bottom: 4,
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    if (index == 2)
                      Positioned(
                        bottom: 4,
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppTheme.goldCoffee,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}