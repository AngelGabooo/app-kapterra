// lib/features/technician/presentation/screens/technician_agenda_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/glass_widgets.dart';
import 'package:kaabcafe/core/widgets/aurora_background.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/agenda_visit_card.dart';
import 'package:kaabcafe/features/technician/presentation/widgets/technician_kpi_card.dart';
import 'package:kaabcafe/features/technician/providers/technician_visits_provider.dart';
import 'package:kaabcafe/features/technician/data/models/technician_visit_model.dart';

class TechnicianAgendaScreen extends StatefulWidget {
  const TechnicianAgendaScreen({super.key});

  @override
  State<TechnicianAgendaScreen> createState() => _TechnicianAgendaScreenState();
}

class _TechnicianAgendaScreenState extends State<TechnicianAgendaScreen> {
  int _currentIndex = 2;
  String _selectedView = 'Diaria';

  final List<String> _viewOptions = ['Diaria', 'Semanal', 'Mensual'];
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final accent = isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen;

    // ✅ Obtener visitas del provider
    final visitsProvider = Provider.of<TechnicianVisitsProvider>(context);
    final allVisits = visitsProvider.visits;
    final pendingVisits = allVisits.where((v) => v.status == 'pending').toList();
    final completedVisits = visitsProvider.completedCount;
    final totalVisits = visitsProvider.totalVisits;
    final pendingCount = visitsProvider.pendingCount;
    final urgentCount = visitsProvider.urgentCount;

    // ✅ Obtener próxima visita
    final nextVisit = pendingVisits.isNotEmpty ? pendingVisits.first : null;

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
                                nextVisit != null
                                    ? 'Tienes una visita pendiente'
                                    : 'Organiza y administra tus recorridos.',
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
                          value: '$totalVisits',
                          icon: Icons.calendar_today,
                          color: AppTheme.primaryGreen,
                          isDark: isDark,
                        ),
                        const SizedBox(width: 12),
                        TechnicianKPICard(
                          title: 'Completadas',
                          value: '$completedVisits',
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
                          value: '$pendingCount',
                          icon: Icons.pending,
                          color: AppTheme.alertOrange,
                          isDark: isDark,
                        ),
                        const SizedBox(width: 12),
                        TechnicianKPICard(
                          title: 'Requieren prioridad',
                          value: '$urgentCount',
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
                          _buildCalendar(isDark, textColor, accent, allVisits),
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
                    _buildNextVisitCard(isDark, textColor, nextVisit),
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
              if (allVisits.isEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.03)
                              : AppTheme.darkCoffee.withOpacity(0.02),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: textColor.withOpacity(0.06),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 48,
                              color: textColor.withOpacity(0.15),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Sin visitas programadas',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: textColor.withOpacity(0.4),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Programa tu primera visita desde el botón +',
                              style: TextStyle(
                                fontSize: 12,
                                color: textColor.withOpacity(0.3),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                    ]),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final visit = allVisits[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AgendaVisitCard(
                            producerName: visit.producerName,
                            farmName: visit.farmName,
                            location: visit.location,
                            time: _formatTime(visit.visitDate),
                            objective: visit.objective,
                            status: visit.status == 'pending' ? 'Pendiente' : 'Completada',
                            isUrgent: visit.isUrgent,
                            isDark: isDark,
                            onViewDetails: () {
                              _showVisitDetailsDialog(visit);
                            },
                            onStart: () {
                              _navigateToVisitRegistration({
                                'producerName': visit.producerName,
                                'farmName': visit.farmName,
                                'lotName': visit.lotName,
                                'location': visit.location,
                                'visitId': visit.id,
                              });
                            },
                          ),
                        ),
                      );
                    },
                    childCount: allVisits.length,
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
                          if (_pendingTasks.isEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
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

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildNextVisitCard(bool isDark, Color textColor, TechnicianVisitModel? nextVisit) {
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
          if (nextVisit != null)
            _buildNextVisitContent(nextVisit, isDark, textColor)
          else
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 32,
                      color: textColor.withOpacity(0.2),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No hay visitas programadas',
                      style: TextStyle(
                        fontSize: 13,
                        color: textColor.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        _navigateToVisitRegistration();
                      },
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
        ],
      ),
    );
  }

  Widget _buildNextVisitContent(TechnicianVisitModel visit, bool isDark, Color textColor) {
    return Column(
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
              onPressed: () {
                _showVisitDetailsDialog(visit);
              },
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
    );
  }

  void _showVisitDetailsDialog(TechnicianVisitModel visit) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDark ? AppTheme.coffeeDeep : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.assignment_outlined,
                        color: AppTheme.primaryGreen,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detalles de la visita',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          'Información de la visita programada',
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow('👨‍🌾 Productor', visit.producerName, textColor),
              _buildDetailRow('🌱 Finca', visit.farmName, textColor),
              _buildDetailRow('☕ Lote', visit.lotName, textColor),
              _buildDetailRow('📍 Ubicación', visit.location, textColor),
              _buildDetailRow('📅 Fecha', _formatDate(visit.visitDate), textColor),
              _buildDetailRow('⏰ Hora', _formatTime(visit.visitDate), textColor),
              _buildDetailRow('🎯 Objetivo', visit.objective, textColor),
              if (visit.isUrgent)
                _buildDetailRow('⚠️ Prioridad', 'Urgente', textColor, isUrgent: true),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _navigateToVisitRegistration({
                      'producerName': visit.producerName,
                      'farmName': visit.farmName,
                      'lotName': visit.lotName,
                      'location': visit.location,
                      'visitId': visit.id,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Iniciar visita'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color textColor, {bool isUrgent = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: textColor.withOpacity(0.5),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isUrgent ? AppTheme.berryRed : textColor,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildCalendar(bool isDark, Color textColor, Color accent, List<TechnicianVisitModel> visits) {
    final days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    final dates = List.generate(7, (index) => index + 10);

    // ✅ Obtener días con visitas
    final visitDays = visits.map((v) => v.visitDate.day).toSet();

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
            final day = dates[index];
            final isToday = index == 2;
            final hasVisit = visitDays.contains(day);

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
                      '$day',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                        color: isToday ? accent : textColor.withOpacity(0.7),
                      ),
                    ),
                    if (hasVisit)
                      Positioned(
                        bottom: 2,
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen,
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