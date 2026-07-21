// lib/features/costs/presentation/screens/costs_list_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/aurora_background.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';
import 'package:kaabcafe/features/costs/data/models/cost_model.dart';
import 'package:kaabcafe/features/costs/presentation/widgets/cost_card.dart';
import 'package:kaabcafe/features/costs/presentation/widgets/cost_compact_card.dart';
import 'package:kaabcafe/features/costs/presentation/widgets/cost_empty_state.dart';
import 'package:kaabcafe/features/costs/presentation/widgets/cost_filter_chips.dart';
import 'package:kaabcafe/features/costs/presentation/widgets/cost_search_bar.dart';
import 'package:kaabcafe/features/costs/presentation/widgets/cost_category_chart.dart';
import 'package:kaabcafe/features/activities/presentation/providers/activities_provider.dart';
import 'package:kaabcafe/features/activities/domain/entities/activity_entity.dart';

class CostsListScreen extends StatefulWidget {
  final String? lotId;
  final String? lotName;

  const CostsListScreen({
    super.key,
    this.lotId,
    this.lotName,
  });

  @override
  State<CostsListScreen> createState() => _CostsListScreenState();
}

class _CostsListScreenState extends State<CostsListScreen> {
  String _searchQuery = '';
  CostCategory? _selectedCategory;
  String _selectedLot = 'Todos los lotes';
  bool _isCompactView = false;

  List<CostModel> _costs = [];
  List<String> _availableLots = ['Todos los lotes'];

  @override
  void initState() {
    super.initState();
    _loadCostsFromActivities();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCostsFromActivities();
  }

  void _loadCostsFromActivities() {
    final activitiesProvider = Provider.of<ActivitiesProvider>(context, listen: false);
    final allActivities = activitiesProvider.activities;

    List<ActivityEntity> filteredActivities = allActivities;
    if (widget.lotId != null) {
      filteredActivities = allActivities.where((a) => a.lotId == widget.lotId).toList();
    }

    final newCosts = filteredActivities
        .where((activity) => activity.cost > 0)
        .map((activity) => _activityToCostModel(activity))
        .toList();

    setState(() {
      _costs = newCosts;
      _updateAvailableLots();
    });
  }

  CostModel _activityToCostModel(ActivityEntity activity) {
    CostCategory category = _getCategoryFromActivityType(activity.type);

    return CostModel(
      id: activity.id,
      concept: _getActivityTitle(activity.type),
      category: category,
      amount: activity.cost,
      date: activity.date,
      lotId: activity.lotId,
      lotName: activity.lotName,
      provider: activity.responsible,
      responsible: activity.responsible,
      hasInvoice: activity.evidenceUrls.isNotEmpty,
    );
  }

  CostCategory _getCategoryFromActivityType(ActivityTypeEntity type) {
    switch (type) {
      case ActivityTypeEntity.fertilization:
        return CostCategory.fertilizer;
      case ActivityTypeEntity.pruning:
        return CostCategory.labor;
      case ActivityTypeEntity.pestControl:
        return CostCategory.fertilizer;
      case ActivityTypeEntity.weedControl:
        return CostCategory.fertilizer;
      case ActivityTypeEntity.irrigation:
        return CostCategory.fuel;
      case ActivityTypeEntity.harvest:
        return CostCategory.labor;
      case ActivityTypeEntity.inspection:
        return CostCategory.maintenance;
      case ActivityTypeEntity.other:
        return CostCategory.other;
    }
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

  void _updateAvailableLots() {
    final lotNames = _costs.map((c) => c.lotName).toSet().toList();
    _availableLots = ['Todos los lotes', ...lotNames];

    if (_availableLots.length == 2 && _selectedLot == 'Todos los lotes') {
      _selectedLot = _availableLots[1];
    }
  }

  double get _totalCost => _costs.fold(0, (sum, c) => sum + c.amount);

  double get _currentMonthCost => _costs.where((c) =>
  c.date.year == DateTime.now().year &&
      c.date.month == DateTime.now().month).fold(0, (sum, c) => sum + c.amount);

  double get _costPerKg => _totalCost > 0 ? _totalCost / 5000 : 0;
  double get _variation => _costs.isNotEmpty ? 8.5 : 0;

  List<CostModel> get _filteredCosts {
    return _costs.where((cost) {
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesConcept = cost.concept.toLowerCase().contains(query);
        final matchesProvider = cost.provider?.toLowerCase().contains(query) ?? false;
        final matchesLot = cost.lotName.toLowerCase().contains(query);
        if (!matchesConcept && !matchesProvider && !matchesLot) return false;
      }
      if (_selectedCategory != null && cost.category != _selectedCategory) return false;
      if (_selectedLot != 'Todos los lotes' && cost.lotName != _selectedLot) return false;
      return true;
    }).toList();
  }

  Map<CostCategory, double> get _categoryDistribution {
    final Map<CostCategory, double> distribution = {};
    final filtered = _filteredCosts;
    final total = filtered.fold(0.0, (sum, c) => sum + c.amount);
    for (var cost in filtered) {
      distribution[cost.category] = (distribution[cost.category] ?? 0) + cost.amount;
    }
    if (total > 0) {
      distribution.forEach((key, value) {
        distribution[key] = (value / total) * 100;
      });
    }
    return distribution;
  }

  void _navigateToRegisterCost() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registra actividades con costos para verlos aquí'),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
    context.push(RouteNames.registerActivity);
  }

  void _showCostDetail(CostModel cost) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ModernCostDetailSheet(
          cost: cost,
          isDark: Theme.of(context).brightness == Brightness.dark
      ),
    );
  }

  void _editCost(CostModel cost) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editar actividad: ${cost.concept}'),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }

  void _goBack() {
    if (widget.lotId != null) {
      // Volver a lot_detail_screen
      Navigator.pop(context);
    } else {
      context.go(RouteNames.myFarms);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final filteredCosts = _filteredCosts;
    final distribution = _categoryDistribution;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<ActivitiesProvider>(
        builder: (context, provider, child) {
          final allActivities = provider.activities;
          List<ActivityEntity> filteredActivities = allActivities;
          if (widget.lotId != null) {
            filteredActivities = allActivities.where((a) => a.lotId == widget.lotId).toList();
          }

          final newCosts = filteredActivities
              .where((activity) => activity.cost > 0)
              .map((activity) => _activityToCostModel(activity))
              .toList();

          if (_costs.length != newCosts.length ||
              _costs.any((c) => !newCosts.any((nc) => nc.id == c.id))) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _costs = newCosts;
                _updateAvailableLots();
              });
            });
          }

          return AuroraBackground(
            isDark: isDark,
            child: SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildHeader(isDark),
                  ),
                  SliverToBoxAdapter(
                    child: _buildModernKPIs(isDark),
                  ),
                  if (distribution.isNotEmpty)
                    SliverToBoxAdapter(
                      child: _buildCategoryChart(distribution, isDark),
                    ),
                  SliverToBoxAdapter(
                    child: _buildSearchSection(isDark),
                  ),
                  SliverToBoxAdapter(
                    child: _buildFilterSection(isDark),
                  ),
                  SliverToBoxAdapter(
                    child: _buildLotFilterAndViewToggle(isDark),
                  ),
                  filteredCosts.isEmpty
                      ? SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: CostEmptyState(
                        onRegister: _navigateToRegisterCost,
                        isDark: isDark,
                      ),
                    ),
                  )
                      : SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final cost = filteredCosts[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200 + (index * 50)),
                              curve: Curves.easeOut,
                              child: _isCompactView
                                  ? CostCompactCard(
                                cost: cost,
                                isDark: isDark,
                                onTap: () => _showCostDetail(cost),
                                onEdit: () => _editCost(cost),
                              )
                                  : CostCard(
                                cost: cost,
                                isDark: isDark,
                                onTap: () => _showCostDetail(cost),
                                onEdit: () => _editCost(cost),
                              ),
                            ),
                          );
                        },
                        childCount: filteredCosts.length,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 90),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: _buildModernFAB(isDark),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // ✅ Eliminamos la barra de navegación inferior
    );
  }

  Widget _buildHeader(bool isDark) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 20, 20, 0),
      child: Row(
        children: [
          // ✅ Botón de regreso
          IconButton(
            onPressed: _goBack,
            icon: Icon(Icons.arrow_back, color: textColor),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.lotName != null ? 'Costos del Lote' : 'Costos',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.lotName != null
                      ? 'Costos generados por actividades en ${widget.lotName}'
                      : 'Control financiero de tu producción',
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
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

  Widget _buildModernKPIs(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryGreen,
            AppTheme.secondaryGreen,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gastos Totales',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${_totalCost.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'MXN',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_costs.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.trending_up, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          '+${_variation.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.white.withOpacity(0.2), height: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Este Mes',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${_currentMonthCost.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Costo por kg',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${_costPerKg.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChart(Map<CostCategory, double> distribution, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CostCategoryChart(
        distribution: distribution,
        isDark: isDark,
      ),
    );
  }

  Widget _buildSearchSection(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CostSearchBar(
        isDark: isDark,
        onSearchChanged: (query) => setState(() => _searchQuery = query),
      ),
    );
  }

  Widget _buildFilterSection(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: CostFilterChips(
        isDark: isDark,
        selectedCategory: _selectedCategory,
        onCategorySelected: (category) => setState(() => _selectedCategory = category),
        onClearFilters: () => setState(() => _selectedCategory = null),
      ),
    );
  }

  Widget _buildLotFilterAndViewToggle(bool isDark) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    if (widget.lotId != null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        child: Text(lot),
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

  Widget _buildModernFAB(bool isDark) {
    return NeumorphicActionButton(
      label: 'Registrar Actividad',
      icon: Icons.add,
      isDark: isDark,
      onPressed: _navigateToRegisterCost,
      accentColor: AppTheme.primaryGreen,
    );
  }

  void _showFilterDialog(bool isDark) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark
        ? AppTheme.coffeeDeep.withOpacity(0.9)
        : Colors.white;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filtros Avanzados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 16),
            Text('Rango de fechas', style: TextStyle(color: textColor.withOpacity(0.7))),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textColor,
                      side: BorderSide(color: textColor.withOpacity(0.2)),
                    ),
                    child: Text('Inicio', style: TextStyle(color: textColor)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textColor,
                      side: BorderSide(color: textColor.withOpacity(0.2)),
                    ),
                    child: Text('Fin', style: TextStyle(color: textColor)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Monto mínimo', style: TextStyle(color: textColor.withOpacity(0.7))),
            const SizedBox(height: 8),
            TextField(
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                prefixText: '\$ ',
                prefixStyle: TextStyle(color: textColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: textColor.withOpacity(0.2)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: textColor.withOpacity(0.2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.primaryGreen),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textColor,
                      side: BorderSide(color: textColor.withOpacity(0.2)),
                    ),
                    child: Text('Cancelar', style: TextStyle(color: textColor)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    child: const Text('Aplicar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Modern Bottom Sheet para detalle de costo
class _ModernCostDetailSheet extends StatelessWidget {
  final CostModel cost;
  final bool isDark;

  const _ModernCostDetailSheet({required this.cost, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark
        ? AppTheme.coffeeDeep.withOpacity(0.95)
        : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                        color: cost.category.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(cost.category.icon, color: cost.category.color, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cost.concept,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cost.category.title,
                            style: TextStyle(
                              fontSize: 12,
                              color: cost.category.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Monto Total',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      Text(
                        cost.formattedAmount,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                _buildDetailRow(Icons.landscape, 'Lote', cost.lotName, textColor),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.calendar_today, 'Fecha', '${cost.date.day}/${cost.date.month}/${cost.date.year}', textColor),
                const SizedBox(height: 12),
                if (cost.provider != null) ...[
                  _buildDetailRow(Icons.person, 'Responsable', cost.provider!, textColor),
                  const SizedBox(height: 12),
                ],
                _buildDetailRow(Icons.receipt, 'Comprobante', cost.hasInvoice ? 'Disponible' : 'No disponible', textColor),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close, size: 18, color: textColor),
                        label: Text('Cerrar', style: TextStyle(color: textColor)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: textColor.withOpacity(0.2)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Editar actividad relacionada'),
                              backgroundColor: AppTheme.primaryGreen,
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Ver Actividad'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
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
      children: [
        Icon(icon, size: 18, color: AppTheme.primaryGreen),
        const SizedBox(width: 12),
        SizedBox(
          width: 85,
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
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}