import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/farms/data/models/lot_model.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';
import 'package:kaabcafe/features/farms/data/models/history_event_model.dart';
import 'package:kaabcafe/features/farms/presentation/widgets/history_event_card.dart';

class LotHistoryScreen extends StatefulWidget {
  final LotModel lot;
  final FarmDetailsModel farm;

  const LotHistoryScreen({super.key, required this.lot, required this.farm});

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
    _loadEvents();
  }

  void _loadEvents() {
    _events = [
      HistoryEventModel(
        id: '1',
        type: EventType.activity,
        title: 'Fertilización aplicada',
        description: 'Se aplicaron 50 kg de fertilizante foliar en todo el lote.',
        date: DateTime(2026, 6, 15, 10, 30),
        responsible: 'Juan Pérez',
        attachments: ['foto1.jpg', 'foto2.jpg', 'foto3.jpg'],
        amount: 1250,
      ),
      HistoryEventModel(
        id: '2',
        type: EventType.cost,
        title: 'Compra de fertilizante',
        description: 'Compra de fertilizante orgánico para el lote.',
        date: DateTime(2026, 6, 10, 14, 15),
        responsible: 'Pedro López',
        attachments: ['factura.pdf'],
        amount: 1250,
        producer: 'AgroServicios del Sur',
      ),
      HistoryEventModel(
        id: '3',
        type: EventType.alert,
        title: 'Posible riesgo de roya detectado',
        description: 'Se detectó un patrón inusual de humedad que podría favorecer la roya.',
        date: DateTime(2026, 6, 5, 9, 0),
        responsible: 'Sistema IA',
        attachments: ['reporte.pdf'],
      ),
      HistoryEventModel(
        id: '4',
        type: EventType.aiRecommendation,
        title: 'Recomendación de monitoreo',
        description: 'La IA recomienda aumentar monitoreo de humedad en el sector norte.',
        date: DateTime(2026, 6, 3, 8, 30),
        responsible: 'Sistema IA',
        confidence: '92',
      ),
      HistoryEventModel(
        id: '5',
        type: EventType.production,
        title: 'Cosecha parcial registrada',
        description: 'Primera cosecha del año con excelente calidad.',
        date: DateTime(2026, 5, 15, 11, 0),
        responsible: 'Equipo de cosecha',
        attachments: ['cosecha1.jpg'],
        amount: 220,
      ),
      HistoryEventModel(
        id: '6',
        type: EventType.traceability,
        title: 'Pasaporte digital generado',
        description: 'Se generó el pasaporte digital de trazabilidad para este lote.',
        date: DateTime(2026, 5, 1, 12, 0),
        responsible: 'Sistema',
      ),
      HistoryEventModel(
        id: '7',
        type: EventType.milestone,
        title: 'Primera certificación obtenida',
        description: 'El lote obtuvo certificación de comercio justo.',
        date: DateTime(2026, 4, 20, 10, 0),
        responsible: 'Certificadora',
        attachments: ['certificado.pdf'],
      ),
    ];
    _applyFilter();
  }

  void _applyFilter() {
    setState(() {
      if (_selectedFilter == null) {
        _filteredEvents = _events;
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
  double get _totalProduction => _events.where((e) => e.type == EventType.production && e.amount != null).fold(0, (sum, e) => sum + (e.amount ?? 0));
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
                    // Botón para ver todas las actividades
                    IconButton(
                      onPressed: _navigateToActivitiesList,
                      icon: Icon(Icons.list_alt, color: AppTheme.primaryGreen),
                      tooltip: 'Ver todas las actividades',
                    ),
                    // Botón para registrar nueva actividad
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
              Expanded(
                child: _filteredEvents.isEmpty
                    ? Center(
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
                )
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredEvents.length,
                  itemBuilder: (context, index) {
                    return HistoryEventCard(
                      event: _filteredEvents[index],
                      onTap: () => _onEventTap(_filteredEvents[index]),
                    );
                  },
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