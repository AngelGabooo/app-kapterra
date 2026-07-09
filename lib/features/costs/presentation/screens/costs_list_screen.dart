import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

class CostsListScreen extends StatefulWidget {
  const CostsListScreen({super.key});

  @override
  State<CostsListScreen> createState() => _CostsListScreenState();
}

class _CostsListScreenState extends State<CostsListScreen> {
  int _currentIndex = 2;
  String _searchQuery = '';
  CostCategory? _selectedCategory;
  String _selectedLot = 'Todos los lotes';
  bool _isCompactView = false;

  final List<CostModel> _costs = [];
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
    _loadMockCosts();
  }

  void _loadMockCosts() {
    _costs.addAll([
      CostModel(
        id: '1',
        concept: 'Fertilizante Foliar',
        category: CostCategory.fertilizer,
        amount: 1250,
        date: DateTime(2026, 6, 15),
        lotId: '1',
        lotName: 'Lote Norte',
        provider: 'AgroServicios del Sur',
        responsible: 'Juan Pérez',
        hasInvoice: true,
      ),
      CostModel(
        id: '2',
        concept: 'Mano de obra - Poda',
        category: CostCategory.labor,
        amount: 2500,
        date: DateTime(2026, 6, 12),
        lotId: '2',
        lotName: 'Lote Sur',
        provider: 'Cooperativa Local',
        responsible: 'Pedro López',
        hasInvoice: false,
      ),
      CostModel(
        id: '3',
        concept: 'Transporte de cosecha',
        category: CostCategory.transportation,
        amount: 850,
        date: DateTime(2026, 6, 8),
        lotId: '4',
        lotName: 'Lote Geisha',
        provider: 'Transportes del Café',
        responsible: 'Carlos Ruiz',
        hasInvoice: true,
      ),
      CostModel(
        id: '4',
        concept: 'Combustible',
        category: CostCategory.fuel,
        amount: 1800,
        date: DateTime(2026, 6, 5),
        lotId: '1',
        lotName: 'Lote Norte',
        provider: 'Gasolinera Central',
        responsible: 'Juan Pérez',
        hasInvoice: false,
      ),
      CostModel(
        id: '5',
        concept: 'Mantenimiento de equipo',
        category: CostCategory.maintenance,
        amount: 3200,
        date: DateTime(2026, 6, 1),
        lotId: '3',
        lotName: 'Lote Río',
        provider: 'Talleres Agrícolas',
        responsible: 'Pedro López',
        hasInvoice: true,
      ),
    ]);
  }

  double get _totalCost => _costs.fold(0, (sum, c) => sum + c.amount);
  double get _currentMonthCost => _costs.where((c) =>
  c.date.year == DateTime.now().year &&
      c.date.month == DateTime.now().month).fold(0, (sum, c) => sum + c.amount);
  double get _costPerKg => _totalCost / 5000;
  double get _variation => 8.5;

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
        content: Text('Próximamente: Registro de Costos'),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }

  void _showCostDetail(CostModel cost) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ModernCostDetailSheet(cost: cost, isDark: Theme.of(context).brightness == Brightness.dark),
    );
  }

  void _editCost(CostModel cost) {
    debugPrint('Editar costo: ${cost.concept}');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final filteredCosts = _filteredCosts;
    final distribution = _categoryDistribution;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: AuroraBackground(
        isDark: isDark,
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header Sliver
              SliverToBoxAdapter(
                child: _buildHeader(isDark),
              ),

              // KPIs Sliver
              SliverToBoxAdapter(
                child: _buildModernKPIs(isDark),
              ),

              // Category Chart Sliver
              if (distribution.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildCategoryChart(distribution, isDark),
                ),

              // Search Section Sliver
              SliverToBoxAdapter(
                child: _buildSearchSection(isDark),
              ),

              // Filter Chips Sliver
              SliverToBoxAdapter(
                child: _buildFilterSection(isDark),
              ),

              // Lot Filter & View Toggle Sliver
              SliverToBoxAdapter(
                child: _buildLotFilterAndViewToggle(isDark),
              ),

              // Cost List Sliver
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

              // ✅ Padding inferior para que no se superponga con la barra
              const SliverToBoxAdapter(
                child: SizedBox(height: 90),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildModernFAB(isDark),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _buildBottomNavigationBar(isDark),
    );
  }

  Widget _buildHeader(bool isDark) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Costos',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Control financiero de tu producción',
                  style: TextStyle(
                    fontSize: 13,
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
            size: 48,
            iconSize: 22,
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
        // ✅ SIN SOMBRAS EN AMBOS MODOS
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
      label: 'Registrar Costo',
      icon: Icons.add,
      isDark: isDark,
      onPressed: _navigateToRegisterCost,
      accentColor: AppTheme.primaryGreen,
    );
  }

  Widget _buildBottomNavigationBar(bool isDark) {
    return NeumorphicBottomNav(
      isDark: isDark,
      currentIndex: _currentIndex,
      items: const [
        Icons.home_outlined,
        Icons.landscape_outlined,
        Icons.attach_money_outlined,
        Icons.assignment_outlined,
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
          case 3:
            context.go(RouteNames.activities);
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
                // Header
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

                // Amount Card
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

                // Details
                _buildDetailRow(Icons.landscape, 'Lote', cost.lotName, textColor),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.calendar_today, 'Fecha', '${cost.date.day}/${cost.date.month}/${cost.date.year}', textColor),
                const SizedBox(height: 12),
                if (cost.provider != null) ...[
                  _buildDetailRow(Icons.business, 'Proveedor', cost.provider!, textColor),
                  const SizedBox(height: 12),
                ],
                _buildDetailRow(Icons.person, 'Responsable', cost.responsible, textColor),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.receipt, 'Comprobante', cost.hasInvoice ? 'Disponible' : 'No disponible', textColor),

                const SizedBox(height: 20),

                // Actions
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
                        },
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Editar'),
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