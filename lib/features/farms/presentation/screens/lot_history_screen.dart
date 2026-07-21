// lib/features/farms/presentation/screens/lot_history_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/farms/data/models/lot_model.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';
import 'package:kaabcafe/features/farms/data/models/history_event_model.dart';
import 'package:kaabcafe/features/farms/presentation/widgets/history_event_card.dart';
import 'package:kaabcafe/features/activities/presentation/providers/activities_provider.dart';
import 'package:kaabcafe/features/activities/domain/entities/activity_entity.dart';

class LotHistoryScreen extends StatefulWidget {
  final LotModel lot;
  final FarmDetailsModel farm;

  const LotHistoryScreen({
    super.key,
    required this.lot,
    required this.farm
  });

  @override
  State<LotHistoryScreen> createState() => _LotHistoryScreenState();
}

class _LotHistoryScreenState extends State<LotHistoryScreen> {
  EventType? _selectedFilter;
  List<HistoryEventModel> _events = [];
  List<HistoryEventModel> _filteredEvents = [];

  @override
  void initState() {
    super.initState();
    // Cargar eventos después del primer build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEvents();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recargar eventos cuando cambie el provider
    _loadEvents();
  }

  void _loadEvents() {
    final activitiesProvider = Provider.of<ActivitiesProvider>(context, listen: false);
    final lotActivities = activitiesProvider.activities
        .where((activity) => activity.lotId == widget.lot.id)
        .toList();

    setState(() {
      _events = lotActivities.map((activity) => _activityToHistoryEvent(activity)).toList();
      _applyFilter();
    });
  }

  HistoryEventModel _activityToHistoryEvent(ActivityEntity activity) {
    return HistoryEventModel(
      id: activity.id,
      type: EventType.activity,
      title: _getActivityTitle(activity.type),
      description: activity.description.isNotEmpty
          ? activity.description
          : 'Actividad registrada - Responsable: ${activity.responsible}',
      date: activity.date,
      responsible: activity.responsible,
      attachments: activity.evidenceUrls,
      amount: activity.cost > 0 ? activity.cost : null,
    );
  }

  String _getActivityTitle(ActivityTypeEntity type) {
    switch (type) {
      case ActivityTypeEntity.fertilization:
        return 'Fertilización aplicada';
      case ActivityTypeEntity.pruning:
        return 'Poda realizada';
      case ActivityTypeEntity.pestControl:
        return 'Control de plagas aplicado';
      case ActivityTypeEntity.weedControl:
        return 'Control de malezas realizado';
      case ActivityTypeEntity.irrigation:
        return 'Riego aplicado';
      case ActivityTypeEntity.harvest:
        return 'Cosecha registrada';
      case ActivityTypeEntity.inspection:
        return 'Inspección técnica realizada';
      case ActivityTypeEntity.other:
        return 'Otra actividad registrada';
    }
  }

  void _applyFilter() {
    setState(() {
      if (_selectedFilter == null) {
        _filteredEvents = List.from(_events);
      } else {
        _filteredEvents = _events.where((e) => e.type == _selectedFilter).toList();
      }
    });
  }

  void _onEventTap(HistoryEventModel event) {
    debugPrint('Evento seleccionado: ${event.title}');
    // TODO: Mostrar detalle del evento
  }

  void _navigateToRegisterActivity() {
    context.push(
      RouteNames.registerActivity,
      extra: {
        'lot': widget.lot,
        'farm': widget.farm,
      },
    );
  }

  void _navigateToActivitiesList() {
    context.push(
      RouteNames.activities,
      extra: {
        'lot': widget.lot,
        'farm': widget.farm,
      },
    );
  }

  int get _totalActivities => _events.where((e) => e.type == EventType.activity).length;
  double get _totalCosts => _events.where((e) => e.amount != null).fold(0, (sum, e) => sum + (e.amount ?? 0));
  double get _totalProduction => 0;
  int get _totalTraceability => _events.where((e) => e.type == EventType.traceability).length;

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
          child: Consumer<ActivitiesProvider>(
            builder: (context, provider, child) {
              // ✅ Actualizar eventos cuando cambie el provider
              final lotActivities = provider.activities
                  .where((activity) => activity.lotId == widget.lot.id)
                  .toList();

              // ✅ Solo actualizar si la lista cambió
              final newEvents = lotActivities.map((activity) => _activityToHistoryEvent(activity)).toList();
              if (_events.length != newEvents.length ||
                  _events.any((e) => !newEvents.any((ne) => ne.id == e.id))) {
                // Programar actualización después del build
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _events = newEvents;
                    _applyFilter();
                  });
                });
              }

              if (provider.isLoading && _events.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return _buildContent();
            },
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
          currentIndex: 2,
          onTap: (index) {
            if (index == 0) {
              context.go(RouteNames.dashboard);
            } else if (index == 1) {
              context.go(RouteNames.myFarms);
            } else if (index == 4) {
              context.go(RouteNames.profile);
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.primaryGreen,
          unselectedItemColor: AppTheme.darkCoffee.withOpacity(0.5),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
            BottomNavigationBarItem(icon: Icon(Icons.landscape), label: 'Fincas'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historial'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Indicadores'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          // Barra superior con botones de acción
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  color: AppTheme.darkCoffee,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Historial del Lote',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkCoffee,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Consulta la evolución completa del lote.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.darkCoffee.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _navigateToActivitiesList,
                  icon: Icon(Icons.list_alt, color: AppTheme.primaryGreen),
                  tooltip: 'Ver todas las actividades',
                ),
                IconButton(
                  onPressed: _navigateToRegisterActivity,
                  icon: Icon(Icons.add_circle_outline, color: AppTheme.primaryGreen),
                  tooltip: 'Registrar actividad',
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.share, color: AppTheme.darkCoffee),
                ),
              ],
            ),
          ),

          // Resumen del lote
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  AppTheme.lightBeige,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
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
                    gradient: LinearGradient(
                      colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.agriculture, size: 30, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.lot.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkCoffee,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.farm.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.darkCoffee.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          _buildChip(Icons.location_on, widget.farm.location),
                          _buildChip(Icons.emoji_nature, widget.lot.variety),
                          _buildChip(Icons.landscape, '${widget.lot.area} ha'),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.lot.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: widget.lot.statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.lot.statusText,
                        style: TextStyle(
                          fontSize: 11,
                          color: widget.lot.statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // KPIs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildKPI(Icons.assignment, 'Actividades', '$_totalActivities'),
                const SizedBox(width: 12),
                _buildKPI(Icons.attach_money, 'Costos', '\$${_totalCosts.toStringAsFixed(0)}'),
                const SizedBox(width: 12),
                _buildKPI(Icons.eco, 'Producción', '${_totalProduction.toStringAsFixed(0)} kg'),
                const SizedBox(width: 12),
                _buildKPI(Icons.qr_code, 'Trazabilidad', '$_totalTraceability'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Filtros
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterChip('Todos', null),
                const SizedBox(width: 8),
                _buildFilterChip('Actividades', EventType.activity),
                const SizedBox(width: 8),
                _buildFilterChip('Costos', EventType.cost),
                const SizedBox(width: 8),
                _buildFilterChip('Producción', EventType.production),
                const SizedBox(width: 8),
                _buildFilterChip('Alertas', EventType.alert),
                const SizedBox(width: 8),
                _buildFilterChip('IA', EventType.aiRecommendation),
                const SizedBox(width: 8),
                _buildFilterChip('Trazabilidad', EventType.traceability),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Lista de eventos
          _buildEventList(),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    if (_filteredEvents.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.history,
                  size: 50,
                  color: AppTheme.primaryGreen.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'No hay eventos registrados',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkCoffee,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Comienza registrando actividades para construir\nla historia de tu lote.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.darkCoffee.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _navigateToRegisterActivity,
                icon: const Icon(Icons.add),
                label: const Text('Registrar Actividad'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: _filteredEvents.map((event) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: HistoryEventCard(
              event: event,
              onTap: () => _onEventTap(event),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: AppTheme.darkCoffee.withOpacity(0.5)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: AppTheme.darkCoffee.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPI(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: AppTheme.primaryGreen),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkCoffee,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: AppTheme.darkCoffee.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, EventType? type) {
    final isSelected = _selectedFilter == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = type;
          _applyFilter();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Colors.white : AppTheme.darkCoffee,
          ),
        ),
      ),
    );
  }
}