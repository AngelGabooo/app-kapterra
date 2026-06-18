// lib/features/activities/presentation/screens/activities_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/activities/data/models/activity_model.dart';
import 'package:kaabcafe/features/activities/presentation/providers/activities_provider.dart';
import 'package:kaabcafe/features/activities/presentation/widgets/activity_card.dart';
import 'package:kaabcafe/features/activities/presentation/widgets/activity_compact_card.dart';
import 'package:kaabcafe/features/activities/presentation/widgets/activity_empty_state.dart';
import 'package:kaabcafe/features/activities/presentation/widgets/activity_filter_chips.dart';
import 'package:kaabcafe/features/activities/presentation/widgets/activity_kpi_card.dart';
import 'package:kaabcafe/features/activities/presentation/widgets/activity_search_bar.dart';
import 'package:kaabcafe/features/activities/domain/entities/activity_entity.dart';
import 'package:kaabcafe/features/farms/data/models/lot_model.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';

class ActivitiesListScreen extends StatefulWidget {
  final LotModel? initialLot;
  final FarmDetailsModel? initialFarm;

  const ActivitiesListScreen({
    super.key,
    this.initialLot,
    this.initialFarm,
  });

  @override
  State<ActivitiesListScreen> createState() => _ActivitiesListScreenState();
}

class _ActivitiesListScreenState extends State<ActivitiesListScreen> {
  int _currentIndex = 2;
  String _searchQuery = '';
  ActivityType? _selectedType;
  ActivityStatus? _selectedStatus;
  String _selectedLot = 'Todos los lotes';
  bool _isCompactView = false;

  final List<String> _availableLots = [
    'Todos los lotes',
    'Lote Norte',
    'Lote Sur',
    'Lote Río',
    'Lote Geisha',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ActivitiesProvider>(context, listen: false);
      provider.loadActivities();
      provider.loadSummary();
    });
  }

  void _navigateToRegisterActivity() {
    final lot = widget.initialLot ?? LotModel(
      id: 'default',
      name: 'Lote Principal',
      variety: 'Bourbon',
      estimatedProduction: 500,
      area: 2.5,
      status: LotStatus.healthy,
      treesCount: 5000,
    );

    final farm = widget.initialFarm ?? FarmDetailsModel(
      id: 'default',
      name: 'Mi Finca',
      location: 'Chiapas, México',
      hectares: 10.0,
      lots: 5,
      productivity: 800,
      status: FarmHealthStatus.healthy,
      imageUrl: '',
      latitude: 0,
      longitude: 0,
    );

    context.push(
      RouteNames.registerActivity,
      extra: {
        'lot': lot,
        'farm': farm,
      },
    );
  }

  void _goBack() {
    if (widget.initialLot != null && widget.initialFarm != null) {
      context.go(
        RouteNames.lotHistory,
        extra: {
          'lot': widget.initialLot,
          'farm': widget.initialFarm,
        },
      );
    } else {
      context.go(RouteNames.myFarms);
    }
  }

  void _showActivityDetail(ActivityModel activity, String lotName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ActivityDetailSheet(
        activity: activity,
        lotName: lotName,
      ),
    );
  }

  ActivityModel _entityToModel(ActivityEntity entity) {
    return ActivityModel(
      id: entity.id,
      type: _stringToActivityType(entity.type.toString().split('.').last),
      status: _stringToActivityStatus(entity.status.toString().split('.').last),
      date: entity.date,
      responsible: entity.responsible,
      description: entity.description,
      quantity: entity.quantity,
      quantityUnit: entity.quantityUnit,
      cost: entity.cost,
      evidenceUrls: entity.evidenceUrls,
      observations: entity.observations,
    );
  }

  ActivityType _stringToActivityType(String type) {
    switch (type) {
      case 'fertilization': return ActivityType.fertilization;
      case 'pruning': return ActivityType.pruning;
      case 'pestControl': return ActivityType.pestControl;
      case 'weedControl': return ActivityType.weedControl;
      case 'irrigation': return ActivityType.irrigation;
      case 'harvest': return ActivityType.harvest;
      case 'inspection': return ActivityType.inspection;
      default: return ActivityType.other;
    }
  }

  ActivityStatus _stringToActivityStatus(String status) {
    switch (status) {
      case 'completed': return ActivityStatus.completed;
      case 'pending': return ActivityStatus.pending;
      case 'inProgress': return ActivityStatus.inProgress;
      case 'cancelled': return ActivityStatus.cancelled;
      default: return ActivityStatus.pending;
    }
  }

  LotModel _createLotModel(ActivityEntity entity) {
    return LotModel(
      id: entity.lotId,
      name: entity.lotName,
      variety: 'Bourbon',
      estimatedProduction: 500,
      area: 2.5,
      status: LotStatus.healthy,
      treesCount: 5000,
    );
  }

  FarmDetailsModel _createFarmModel(ActivityEntity entity) {
    return FarmDetailsModel(
      id: entity.farmId,
      name: entity.farmName,
      location: 'Chiapas, México',
      hectares: 10.0,
      lots: 5,
      productivity: 800,
      status: FarmHealthStatus.healthy,
      imageUrl: '',
      latitude: 0,
      longitude: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBeige,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildKPIs(),
            ActivitySearchBar(
              onSearchChanged: (query) {
                setState(() => _searchQuery = query);
                final provider = Provider.of<ActivitiesProvider>(context, listen: false);
                provider.setSearchQuery(query);
              },
            ),
            ActivityFilterChips(
              selectedType: _selectedType,
              selectedStatus: _selectedStatus,
              onTypeSelected: (type) => setState(() => _selectedType = type),
              onStatusSelected: (status) => setState(() => _selectedStatus = status),
              onClearFilters: () => setState(() {
                _selectedType = null;
                _selectedStatus = null;
                _selectedLot = 'Todos los lotes';
                final provider = Provider.of<ActivitiesProvider>(context, listen: false);
                provider.clearFilters();
              }),
            ),
            _buildLotFilterAndViewToggle(),
            Expanded(
              child: Consumer<ActivitiesProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text('Error: ${provider.error}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => provider.loadActivities(),
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    );
                  }

                  final activities = provider.activities;

                  if (activities.isEmpty) {
                    return ActivityEmptyState(onRegister: _navigateToRegisterActivity);
                  }

                  var filtered = List<ActivityEntity>.from(activities);

                  if (_searchQuery.isNotEmpty) {
                    final query = _searchQuery.toLowerCase();
                    filtered = filtered.where((a) =>
                    a.type.title.toLowerCase().contains(query) ||
                        a.responsible.toLowerCase().contains(query) ||
                        a.description.toLowerCase().contains(query)
                    ).toList();
                  }

                  if (_selectedType != null) {
                    filtered = filtered.where((a) =>
                        a.type.toString().contains(_selectedType!.toString().split('.').last)
                    ).toList();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final activityEntity = filtered[index];
                      final activityModel = _entityToModel(activityEntity);
                      final lotModel = _createLotModel(activityEntity);
                      final farmModel = _createFarmModel(activityEntity);

                      return AnimatedContainer(
                        duration: Duration(milliseconds: 200 + (index * 50)),
                        curve: Curves.easeOut,
                        child: _isCompactView
                            ? ActivityCompactCard(
                          activity: activityModel,
                          lotName: activityEntity.lotName,
                          lot: lotModel,
                          farm: farmModel,
                          onTap: () => _showActivityDetail(activityModel, activityEntity.lotName),
                        )
                            : ActivityCard(
                          activity: activityModel,
                          lotName: activityEntity.lotName,
                          lot: lotModel,
                          farm: farmModel,
                          onTap: () => _showActivityDetail(activityModel, activityEntity.lotName),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToRegisterActivity,
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Registrar Actividad'),
        elevation: 4,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: _goBack,
            icon: Icon(Icons.arrow_back, color: AppTheme.darkCoffee),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Actividades',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkCoffee,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Gestiona las actividades realizadas en tus lotes.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.darkCoffee.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, color: AppTheme.darkCoffee),
          ),
          IconButton(
            onPressed: () => _showFilterDialog(),
            icon: Icon(Icons.filter_list, color: AppTheme.darkCoffee),
          ),
        ],
      ),
    );
  }

  Widget _buildKPIs() {
    return Consumer<ActivitiesProvider>(
      builder: (context, provider, child) {
        final summary = provider.summary;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: ActivityKPICard(
                  title: 'Actividades registradas',
                  value: '${summary?.totalActivities ?? 0}',
                  icon: Icons.assignment,
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ActivityKPICard(
                  title: 'Lotes con actividad',
                  value: '${provider.activities.map((a) => a.lotId).toSet().length}',
                  icon: Icons.landscape,
                  color: AppTheme.goldCoffee,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLotFilterAndViewToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedLot,
                  isExpanded: true,
                  icon: Icon(Icons.expand_more, color: AppTheme.primaryGreen),
                  items: _availableLots.map((lot) {
                    return DropdownMenuItem(
                      value: lot,
                      child: Text(lot, style: const TextStyle(color: AppTheme.darkCoffee)),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedLot = value!),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: _isCompactView ? AppTheme.primaryGreen : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isCompactView ? AppTheme.primaryGreen : Colors.grey.withOpacity(0.2),
              ),
            ),
            child: IconButton(
              onPressed: () => setState(() => _isCompactView = !_isCompactView),
              icon: Icon(
                _isCompactView ? Icons.view_module : Icons.view_list,
                color: _isCompactView ? Colors.white : AppTheme.darkCoffee,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
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
        onTap: (index) {
          setState(() => _currentIndex = index);
          switch (index) {
            case 0:
              context.go(RouteNames.dashboard);
              break;
            case 1:
              context.go(RouteNames.myFarms);
              break;
            case 2:
              break;
            case 4:
              context.go(RouteNames.profile);
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppTheme.primaryGreen,
        unselectedItemColor: AppTheme.darkCoffee.withOpacity(0.5),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.landscape), label: 'Fincas'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Actividades'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Indicadores'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Filtros avanzados'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
            ),
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }
}

// Bottom Sheet para detalle de actividad
class _ActivityDetailSheet extends StatelessWidget {
  final ActivityModel activity;
  final String lotName;

  const _ActivityDetailSheet({
    required this.activity,
    required this.lotName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: activity.type.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(activity.type.icon, color: activity.type.color, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.type.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkCoffee,
                            ),
                          ),
                          Text(
                            lotName,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.darkCoffee.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildDetailRow(Icons.person, 'Responsable', activity.responsible),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.description, 'Descripción', activity.description),
                if (activity.quantity > 0) ...[
                  const SizedBox(height: 12),
                  _buildDetailRow(Icons.abc, 'Cantidad', '${activity.quantity} ${activity.quantityUnit}'),
                ],
                if (activity.cost > 0) ...[
                  const SizedBox(height: 12),
                  _buildDetailRow(Icons.attach_money, 'Costo', '\$${activity.cost.toStringAsFixed(2)} MXN'),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Cerrar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppTheme.primaryGreen),
        const SizedBox(width: 12),
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(fontSize: 13, color: AppTheme.darkCoffee.withOpacity(0.6)),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.darkCoffee),
          ),
        ),
      ],
    );
  }
}