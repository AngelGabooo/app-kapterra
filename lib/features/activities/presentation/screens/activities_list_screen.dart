// lib/features/activities/presentation/screens/activities_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/aurora_background.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';
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

  // ✅ Lista vacía inicialmente, se llena desde el provider
  List<String> _availableLots = ['Todos los lotes'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ActivitiesProvider>(context, listen: false);
      provider.loadActivities();
      provider.loadSummary();
    });
  }

  // ✅ Método para actualizar los lotes disponibles - AHORA SIN setState
  void _updateAvailableLots(List<ActivityEntity> activities) {
    final lotNames = activities.map((a) => a.lotName).toSet().toList();
    final newLots = ['Todos los lotes', ...lotNames];

    // Solo actualizar si hay cambios
    if (_availableLots.length != newLots.length ||
        _availableLots.any((lot) => !newLots.contains(lot))) {
      setState(() {
        _availableLots = newLots;
        if (_selectedLot != 'Todos los lotes' && !lotNames.contains(_selectedLot)) {
          _selectedLot = 'Todos los lotes';
        }
      });
    }
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
      Navigator.pop(context);
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
        isDark: Theme.of(context).brightness == Brightness.dark,
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: AuroraBackground(
        isDark: isDark,
        child: SafeArea(
          child: Consumer<ActivitiesProvider>(
            builder: (context, provider, child) {
              final activities = provider.activities;

              // ✅ Actualizar lista de lotes disponibles - Usando addPostFrameCallback
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _updateAvailableLots(activities);
                }
              });

              // ✅ Manejar estados de carga y error fuera del CustomScrollView
              if (provider.isLoading && activities.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.error != null && activities.isEmpty) {
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

              // ✅ Si no hay actividades, mostrar estado vacío
              if (activities.isEmpty) {
                return ActivityEmptyState(
                  onRegister: _navigateToRegisterActivity,
                  isDark: isDark,
                );
              }

              // ✅ Filtrar actividades
              var filtered = List<ActivityEntity>.from(activities);

              if (_selectedLot != 'Todos los lotes') {
                filtered = filtered.where((a) => a.lotName == _selectedLot).toList();
              }

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

              // ✅ Si después de filtrar no hay resultados, mostrar mensaje
              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: isDark ? Colors.white.withOpacity(0.3) : AppTheme.darkCoffee.withOpacity(0.3)),
                      const SizedBox(height: 16),
                      Text(
                        'No se encontraron actividades',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white.withOpacity(0.5) : AppTheme.darkCoffee.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Prueba con otros filtros',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white.withOpacity(0.3) : AppTheme.darkCoffee.withOpacity(0.3),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _selectedType = null;
                            _selectedLot = 'Todos los lotes';
                          });
                        },
                        child: const Text('Limpiar filtros'),
                      ),
                    ],
                  ),
                );
              }

              // ✅ Mostrar lista de actividades con CustomScrollView
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // ── Header ──────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: _buildHeader(isDark),
                  ),

                  // ── KPIs ────────────────────────────────────────────
                  SliverToBoxAdapter(
                    child: _buildKPIs(isDark, filtered),
                  ),

                  // ── Search Bar ──────────────────────────────────────
                  SliverToBoxAdapter(
                    child: ActivitySearchBar(
                      isDark: isDark,
                      onSearchChanged: (query) {
                        setState(() => _searchQuery = query);
                      },
                    ),
                  ),

                  // ── Filter Chips ────────────────────────────────────
                  SliverToBoxAdapter(
                    child: ActivityFilterChips(
                      isDark: isDark,
                      selectedType: _selectedType,
                      selectedStatus: _selectedStatus,
                      onTypeSelected: (type) => setState(() => _selectedType = type),
                      onStatusSelected: (status) => setState(() => _selectedStatus = status),
                      onClearFilters: () => setState(() {
                        _selectedType = null;
                        _selectedStatus = null;
                        _selectedLot = 'Todos los lotes';
                      }),
                    ),
                  ),

                  // ── Lot Filter & View Toggle ───────────────────────
                  SliverToBoxAdapter(
                    child: _buildLotFilterAndViewToggle(isDark),
                  ),

                  // ── Activity List ──────────────────────────────────
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final activityEntity = filtered[index];
                          final activityModel = _entityToModel(activityEntity);
                          final lotModel = _createLotModel(activityEntity);
                          final farmModel = _createFarmModel(activityEntity);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200 + (index * 50)),
                              curve: Curves.easeOut,
                              child: _isCompactView
                                  ? ActivityCompactCard(
                                activity: activityModel,
                                lotName: activityEntity.lotName,
                                lot: lotModel,
                                farm: farmModel,
                                isDark: isDark,
                                onTap: () => _showActivityDetail(activityModel, activityEntity.lotName),
                              )
                                  : ActivityCard(
                                activity: activityModel,
                                lotName: activityEntity.lotName,
                                lot: lotModel,
                                farm: farmModel,
                                isDark: isDark,
                                onTap: () => _showActivityDetail(activityModel, activityEntity.lotName),
                              ),
                            ),
                          );
                        },
                        childCount: filtered.length,
                      ),
                    ),
                  ),

                  // ── Bottom Padding ──────────────────────────────────
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 90),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: _buildModernFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader(bool isDark) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    // Determinar el título según si hay un lote inicial
    String title = 'Actividades';
    String subtitle = 'Gestiona las actividades realizadas en tus lotes.';

    if (widget.initialLot != null) {
      title = 'Actividades del Lote';
      subtitle = 'Actividades realizadas en ${widget.initialLot!.name}';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 0),
      child: Row(
        children: [
          NeumorphicIconButton(
            icon: Icons.arrow_back,
            isDark: isDark,
            onPressed: _goBack,
            size: 44,
            iconSize: 20,
            color: textColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          NeumorphicIconButton(
            icon: Icons.search,
            isDark: isDark,
            onPressed: () {},
            size: 44,
            iconSize: 20,
            color: textColor,
          ),
          const SizedBox(width: 4),
          NeumorphicIconButton(
            icon: Icons.filter_list,
            isDark: isDark,
            onPressed: () => _showFilterDialog(isDark),
            size: 44,
            iconSize: 20,
            color: AppTheme.primaryGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildKPIs(bool isDark, List<ActivityEntity> filteredActivities) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: ActivityKPICard(
              title: 'Actividades',
              value: '${filteredActivities.length}',
              icon: Icons.assignment,
              color: AppTheme.primaryGreen,
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ActivityKPICard(
              title: 'Lotes',
              value: '${filteredActivities.map((a) => a.lotId).toSet().length}',
              icon: Icons.landscape,
              color: AppTheme.goldCoffee,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLotFilterAndViewToggle(bool isDark) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    // Si hay un lote inicial, ocultar el filtro de lotes
    if (widget.initialLot != null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: NeumorphicBox(
              isDark: isDark,
              borderRadius: 16,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                height: 48,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedLot,
                    isExpanded: true,
                    icon: Icon(Icons.expand_more, color: AppTheme.primaryGreen),
                    style: TextStyle(color: textColor, fontSize: 14),
                    dropdownColor: isDark ? AppTheme.coffeeDeep : Colors.white,
                    items: _availableLots.map((lot) {
                      return DropdownMenuItem(
                        value: lot,
                        child: Text(lot, style: TextStyle(color: textColor)),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedLot = value!),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          NeumorphicIconButton(
            icon: _isCompactView ? Icons.view_module : Icons.view_list,
            isDark: isDark,
            onPressed: () => setState(() => _isCompactView = !_isCompactView),
            size: 48,
            iconSize: 22,
            color: _isCompactView ? AppTheme.primaryGreen : textColor,
          ),
        ],
      ),
    );
  }

  Widget _buildModernFAB() {
    return NeumorphicActionButton(
      label: 'Registrar Actividad',
      icon: Icons.add,
      isDark: Theme.of(context).brightness == Brightness.dark,
      onPressed: _navigateToRegisterActivity,
      accentColor: AppTheme.primaryGreen,
    );
  }

  Widget _buildBottomNavigationBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Si hay un lote inicial (viniendo de lot_detail), no mostrar la barra de navegación
    if (widget.initialLot != null && widget.initialFarm != null) {
      return const SizedBox.shrink();
    }

    return NeumorphicBottomNav(
      isDark: isDark,
      currentIndex: _currentIndex,
      items: const [
        Icons.home_outlined,
        Icons.landscape_outlined,
        Icons.assignment_outlined,
        Icons.analytics_outlined,
        Icons.person_outline,
      ],
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
    );
  }

  void _showFilterDialog(bool isDark) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark
        ? AppTheme.coffeeDeep.withOpacity(0.9)
        : Colors.white;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text(
          'Filtros avanzados',
          style: TextStyle(color: textColor),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: textColor,
            ),
            child: Text('Cancelar', style: TextStyle(color: textColor)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
              elevation: 0,
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
  final bool isDark;

  const _ActivityDetailSheet({
    required this.activity,
    required this.lotName,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark
        ? AppTheme.coffeeDeep.withOpacity(0.95)
        : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: textColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
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
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          Text(
                            lotName,
                            style: TextStyle(
                              fontSize: 14,
                              color: textColor.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildDetailRow(Icons.person, 'Responsable', activity.responsible, textColor),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.description, 'Descripción', activity.description, textColor),
                if (activity.quantity > 0) ...[
                  const SizedBox(height: 12),
                  _buildDetailRow(Icons.abc, 'Cantidad', '${activity.quantity} ${activity.quantityUnit}', textColor),
                ],
                if (activity.cost > 0) ...[
                  const SizedBox(height: 12),
                  _buildDetailRow(Icons.attach_money, 'Costo', '\$${activity.cost.toStringAsFixed(2)} MXN', textColor),
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
                      elevation: 0,
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

  Widget _buildDetailRow(IconData icon, String label, String value, Color textColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppTheme.primaryGreen),
        const SizedBox(width: 12),
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: textColor.withOpacity(0.6),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}