// lib/features/costs/presentation/screens/costs_list_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
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
      const SnackBar(content: Text('Próximamente: Registro de Costos'), backgroundColor: AppTheme.primaryGreen),
    );
  }

  void _showCostDetail(CostModel cost) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ModernCostDetailSheet(cost: cost),
    );
  }

  void _editCost(CostModel cost) {
    debugPrint('Editar costo: ${cost.concept}');
  }

  @override
  Widget build(BuildContext context) {
    final filteredCosts = _filteredCosts;
    final distribution = _categoryDistribution;

    return Scaffold(
      backgroundColor: AppTheme.lightBeige,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header Sliver
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),

            // KPIs Sliver
            SliverToBoxAdapter(
              child: _buildModernKPIs(),
            ),

            // Category Chart Sliver
            if (distribution.isNotEmpty)
              SliverToBoxAdapter(
                child: _buildCategoryChart(distribution),
              ),

            // Search Section Sliver
            SliverToBoxAdapter(
              child: _buildSearchSection(),
            ),

            // Filter Chips Sliver
            SliverToBoxAdapter(
              child: _buildFilterSection(),
            ),

            // Lot Filter & View Toggle Sliver
            SliverToBoxAdapter(
              child: _buildLotFilterAndViewToggle(),
            ),

            // Cost List Sliver
            filteredCosts.isEmpty
                ? SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: CostEmptyState(onRegister: _navigateToRegisterCost),
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
                          onTap: () => _showCostDetail(cost),
                          onEdit: () => _editCost(cost),
                        )
                            : CostCard(
                          cost: cost,
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

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildModernFAB(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Costos',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkCoffee,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Control financiero de tu producción',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.darkCoffee.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () => _showFilterDialog(),
              icon: Icon(Icons.filter_list, color: AppTheme.primaryGreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernKPIs() {
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
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
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

  Widget _buildCategoryChart(Map<CostCategory, double> distribution) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CostCategoryChart(distribution: distribution),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CostSearchBar(
        onSearchChanged: (query) => setState(() => _searchQuery = query),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: CostFilterChips(
        selectedCategory: _selectedCategory,
        onCategorySelected: (category) => setState(() => _selectedCategory = category),
        onClearFilters: () => setState(() => _selectedCategory = null),
      ),
    );
  }

  Widget _buildLotFilterAndViewToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 48,
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
                  style: TextStyle(color: AppTheme.darkCoffee, fontSize: 14),
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
          const SizedBox(width: 12),
          Container(
            height: 48,
            width: 48,
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
                size: 22,
                color: _isCompactView ? Colors.white : AppTheme.darkCoffee,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernFAB() {
    return FloatingActionButton(
      onPressed: _navigateToRegisterCost,
      backgroundColor: AppTheme.primaryGreen,
      foregroundColor: Colors.white,
      elevation: 4,
      child: const Icon(Icons.add, size: 24),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, -3),
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
            case 3:
              context.go(RouteNames.activities);
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
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.landscape_outlined), label: 'Fincas'),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money_outlined), label: 'Costos'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Actividades'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filtros Avanzados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Rango de fechas'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Inicio'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Fin'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Monto mínimo'),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                prefixText: '\$ ',
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
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

  const _ModernCostDetailSheet({required this.cost});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
                color: Colors.grey.withOpacity(0.3),
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
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkCoffee,
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
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Monto Total',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
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
                _buildDetailRow(Icons.landscape, 'Lote', cost.lotName),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.calendar_today, 'Fecha', '${cost.date.day}/${cost.date.month}/${cost.date.year}'),
                const SizedBox(height: 12),
                if (cost.provider != null) ...[
                  _buildDetailRow(Icons.business, 'Proveedor', cost.provider!),
                  const SizedBox(height: 12),
                ],
                _buildDetailRow(Icons.person, 'Responsable', cost.responsible),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.receipt, 'Comprobante', cost.hasInvoice ? 'Disponible' : 'No disponible'),

                const SizedBox(height: 20),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, size: 18),
                        label: const Text('Cerrar'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
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
              color: AppTheme.darkCoffee.withOpacity(0.6),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.darkCoffee,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}