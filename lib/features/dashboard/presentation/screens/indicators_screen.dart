// lib/features/dashboard/presentation/screens/indicators_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/providers/farm_provider.dart';
import 'package:kaabcafe/core/providers/user_provider.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/aurora_background.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';
import 'package:kaabcafe/features/farms/data/models/lot_model.dart';
import 'package:kaabcafe/features/activities/presentation/providers/activities_provider.dart';
import 'package:kaabcafe/features/activities/domain/entities/activity_entity.dart';

class IndicatorsScreen extends StatefulWidget {
  const IndicatorsScreen({super.key});

  @override
  State<IndicatorsScreen> createState() => _IndicatorsScreenState();
}

class _IndicatorsScreenState extends State<IndicatorsScreen> {
  int _selectedPeriod = 0; // 0: Este mes, 1: Este año, 2: Todos
  String _selectedCategory = 'Producción';

  final List<String> _categories = [
    'Producción',
    'Calidad',
    'Financiero',
    'Sostenibilidad',
    'Gestión',
  ];

  // ============================================================
  // ✅ MÉTODOS PARA CALCULAR INDICADORES DESDE DATOS REALES
  // ============================================================

  /// Obtener todas las fincas
  List<FarmDetailsModel> _getFarms(FarmProvider farmProvider) {
    return farmProvider.farms;
  }

  /// Obtener todos los lotes de todas las fincas
  List<LotModel> _getAllLots(FarmProvider farmProvider) {
    final List<LotModel> allLots = [];
    for (final farm in farmProvider.farms) {
      allLots.addAll(farmProvider.getLotsForFarm(farm.id));
    }
    return allLots;
  }

  /// Obtener actividades con costos
  List<ActivityEntity> _getActivitiesWithCosts(ActivitiesProvider activitiesProvider) {
    return activitiesProvider.activities.where((a) => a.cost > 0).toList();
  }

  /// Calcular producción total (suma de producción estimada de todos los lotes)
  double _getTotalProduction(FarmProvider farmProvider) {
    final allLots = _getAllLots(farmProvider);
    return allLots.fold(0.0, (sum, lot) => sum + lot.estimatedProduction);
  }

  /// Calcular producción por hectárea
  double _getProductionPerHectare(FarmProvider farmProvider) {
    final allLots = _getAllLots(farmProvider);
    final totalArea = allLots.fold(0.0, (sum, lot) => sum + lot.area);
    final totalProduction = _getTotalProduction(farmProvider);
    if (totalArea == 0) return 0;
    return totalProduction / totalArea;
  }

  /// Calcular área total cosechada
  double _getTotalArea(FarmProvider farmProvider) {
    final allLots = _getAllLots(farmProvider);
    return allLots.fold(0.0, (sum, lot) => sum + lot.area);
  }

  /// Calcular número total de plantas
  int _getTotalTrees(FarmProvider farmProvider) {
    final allLots = _getAllLots(farmProvider);
    return allLots.fold(0, (sum, lot) => sum + lot.treesCount);
  }

  /// Calcular costo total (de todas las actividades)
  double _getTotalCost(ActivitiesProvider activitiesProvider) {
    final costs = _getActivitiesWithCosts(activitiesProvider);
    return costs.fold(0.0, (sum, activity) => sum + activity.cost);
  }

  /// Calcular costo por kg
  double _getCostPerKg(FarmProvider farmProvider, ActivitiesProvider activitiesProvider) {
    final totalProduction = _getTotalProduction(farmProvider);
    final totalCost = _getTotalCost(activitiesProvider);
    if (totalProduction == 0) return 0;
    return totalCost / totalProduction;
  }

  /// Calcular costo del mes actual
  double _getCurrentMonthCost(ActivitiesProvider activitiesProvider) {
    final now = DateTime.now();
    final costs = _getActivitiesWithCosts(activitiesProvider);
    return costs
        .where((a) => a.date.year == now.year && a.date.month == now.month)
        .fold(0.0, (sum, a) => sum + a.cost);
  }

  /// Calcular promedio de producción por lote
  double _getAverageProductionPerLot(FarmProvider farmProvider) {
    final allLots = _getAllLots(farmProvider);
    if (allLots.isEmpty) return 0;
    final total = allLots.fold(0.0, (sum, lot) => sum + lot.estimatedProduction);
    return total / allLots.length;
  }

  /// Contar lotes por estado
  Map<LotStatus, int> _getLotsByStatus(FarmProvider farmProvider) {
    final allLots = _getAllLots(farmProvider);
    final Map<LotStatus, int> statusCount = {};
    for (final lot in allLots) {
      statusCount[lot.status] = (statusCount[lot.status] ?? 0) + 1;
    }
    return statusCount;
  }

  /// Calcular porcentaje de lotes saludables
  double _getHealthyPercentage(FarmProvider farmProvider) {
    final allLots = _getAllLots(farmProvider);
    if (allLots.isEmpty) return 0;
    final healthy = allLots.where((lot) => lot.status == LotStatus.healthy).length;
    return (healthy / allLots.length) * 100;
  }

  /// Calcular total de hectáreas por finca
  double _getFarmArea(FarmProvider farmProvider) {
    return farmProvider.farms.fold(0.0, (sum, farm) => sum + farm.hectares);
  }

  /// Calcular productividad promedio por finca
  double _getAverageFarmProductivity(FarmProvider farmProvider) {
    final farms = _getFarms(farmProvider);
    if (farms.isEmpty) return 0;
    final total = farms.fold(0.0, (sum, farm) => sum + farm.productivity);
    return total / farms.length;
  }

  /// Calcular costo por categoría (simulado desde actividades)
  Map<String, double> _getCostsByCategory(ActivitiesProvider activitiesProvider) {
    final costs = _getActivitiesWithCosts(activitiesProvider);
    final Map<String, double> categories = {};
    for (final activity in costs) {
      final category = _getCategoryFromActivity(activity.type);
      categories[category] = (categories[category] ?? 0) + activity.cost;
    }
    return categories;
  }

  String _getCategoryFromActivity(ActivityTypeEntity type) {
    switch (type) {
      case ActivityTypeEntity.fertilization:
        return 'Fertilización';
      case ActivityTypeEntity.pruning:
        return 'Mantenimiento';
      case ActivityTypeEntity.pestControl:
        return 'Sanidad';
      case ActivityTypeEntity.weedControl:
        return 'Sanidad';
      case ActivityTypeEntity.irrigation:
        return 'Riego';
      case ActivityTypeEntity.harvest:
        return 'Cosecha';
      case ActivityTypeEntity.inspection:
        return 'Monitoreo';
      case ActivityTypeEntity.other:
        return 'Otros';
    }
  }

  // ============================================================
  // ✅ BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    // ✅ Providers
    final farmProvider = Provider.of<FarmProvider>(context);
    final activitiesProvider = Provider.of<ActivitiesProvider>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AuroraBackground(
        isDark: isDark,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, isDark, textColor),
              _buildPeriodSelector(isDark, textColor),
              _buildCategoryTabs(isDark, textColor),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildIndicatorsByCategory(
                        isDark,
                        textColor,
                        farmProvider,
                        activitiesProvider,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ✅ WIDGETS DE CONSTRUCCIÓN
  // ============================================================

  Widget _buildHeader(BuildContext context, bool isDark, Color textColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _goBack(),
            icon: Icon(Icons.arrow_back, color: textColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Indicadores',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  'Métricas clave de tu producción',
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          NeumorphicIconButton(
            icon: Icons.refresh_rounded,
            isDark: isDark,
            onPressed: () {
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🔄 Indicadores actualizados'),
                  backgroundColor: AppTheme.primaryGreen,
                  duration: Duration(seconds: 1),
                ),
              );
            },
            size: 44,
            iconSize: 20,
            color: AppTheme.primaryGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(bool isDark, Color textColor) {
    final periods = ['Este Mes', 'Este Año', 'Todos'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.coffeeDeep.withOpacity(0.5)
            : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : AppTheme.darkCoffee.withOpacity(0.06),
        ),
      ),
      child: Row(
        children: List.generate(periods.length, (index) {
          final isSelected = _selectedPeriod == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedPeriod = index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryGreen
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    periods[index],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.white : textColor.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCategoryTabs(bool isDark, Color textColor) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategory == _categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategory = _categories[index]),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryGreen
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryGreen
                        : textColor.withOpacity(0.15),
                  ),
                ),
                child: Center(
                  child: Text(
                    _categories[index],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? Colors.white : textColor.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIndicatorsByCategory(
      bool isDark,
      Color textColor,
      FarmProvider farmProvider,
      ActivitiesProvider activitiesProvider,
      ) {
    switch (_selectedCategory) {
      case 'Producción':
        return _buildProductionIndicators(isDark, textColor, farmProvider);
      case 'Calidad':
        return _buildQualityIndicators(isDark, textColor, farmProvider);
      case 'Financiero':
        return _buildFinancialIndicators(isDark, textColor, farmProvider, activitiesProvider);
      case 'Sostenibilidad':
        return _buildSustainabilityIndicators(isDark, textColor, farmProvider);
      case 'Gestión':
        return _buildManagementIndicators(isDark, textColor, farmProvider);
      default:
        return const SizedBox.shrink();
    }
  }

  // ── Producción ────────────────────────────────────────────────
  Widget _buildProductionIndicators(bool isDark, Color textColor, FarmProvider farmProvider) {
    final totalProduction = _getTotalProduction(farmProvider);
    final totalArea = _getTotalArea(farmProvider);
    final totalFarms = farmProvider.farms.length;
    final allLots = _getAllLots(farmProvider);
    final totalLots = allLots.length;
    final treesPerHectare = totalArea > 0 ? _getTotalTrees(farmProvider) / totalArea : 0;
    final avgProdPerLot = _getAverageProductionPerLot(farmProvider);

    return Column(
      children: [
        _buildMainIndicator(
          isDark: isDark,
          title: 'Producción Total',
          value: '${totalProduction.toStringAsFixed(0)} kg',
          subtitle: totalFarms > 0 ? '${totalFarms} fincas activas' : 'Sin fincas registradas',
          icon: Icons.grain_rounded,
          color: Colors.green,
          progress: totalProduction > 0 ? 0.5 : 0,
          progressLabel: totalProduction > 0 ? '${(totalProduction / 5000 * 100).toStringAsFixed(0)}% de meta 5,000 kg' : 'Registra producción',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSecondaryIndicator(
                isDark: isDark,
                title: 'Rendimiento',
                value: '${_getProductionPerHectare(farmProvider).toStringAsFixed(1)} kg/ha',
                subtitle: totalArea > 0 ? '${totalArea.toStringAsFixed(1)} ha cosechadas' : 'Sin área registrada',
                icon: Icons.speed_rounded,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSecondaryIndicator(
                isDark: isDark,
                title: 'Lotes Activos',
                value: '$totalLots',
                subtitle: '${allLots.where((l) => l.status == LotStatus.healthy).length} saludables',
                icon: Icons.view_module_rounded,
                color: Colors.brown,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSecondaryIndicator(
                isDark: isDark,
                title: 'Plantas/ha',
                value: treesPerHectare > 0 ? '${treesPerHectare.toStringAsFixed(0)}' : '0',
                subtitle: 'Densidad de siembra',
                icon: Icons.grass_rounded,
                color: Colors.teal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSecondaryIndicator(
                isDark: isDark,
                title: 'Prod./Lote',
                value: '${avgProdPerLot.toStringAsFixed(0)} kg',
                subtitle: 'Promedio por lote',
                icon: Icons.agriculture_rounded,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildProductionChart(isDark, textColor, farmProvider),
      ],
    );
  }

  // ── Calidad ───────────────────────────────────────────────────
  Widget _buildQualityIndicators(bool isDark, Color textColor, FarmProvider farmProvider) {
    final allLots = _getAllLots(farmProvider);
    final healthyCount = allLots.where((l) => l.status == LotStatus.healthy).length;
    final attentionCount = allLots.where((l) => l.status == LotStatus.attention).length;
    final riskCount = allLots.where((l) => l.status == LotStatus.risk).length;
    final healthyPercentage = _getHealthyPercentage(farmProvider);
    final totalLots = allLots.length;

    // Contar variedades únicas
    final varieties = allLots.map((l) => l.variety).toSet().toList();

    return Column(
      children: [
        _buildMainIndicator(
          isDark: isDark,
          title: 'Salud del Cultivo',
          value: '${healthyPercentage.toStringAsFixed(0)}%',
          subtitle: totalLots > 0 ? '${healthyCount} lotes saludables' : 'Sin lotes registrados',
          icon: Icons.health_and_safety_rounded,
          color: Colors.green,
          progress: healthyPercentage / 100,
          progressLabel: '${healthyCount} saludables, $attentionCount atención, $riskCount riesgo',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSecondaryIndicator(
                isDark: isDark,
                title: 'Variedades',
                value: '${varieties.length}',
                subtitle: varieties.isNotEmpty ? varieties.join(', ') : 'Sin variedades',
                icon: Icons.emoji_nature_rounded,
                color: Colors.amber,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSecondaryIndicator(
                isDark: isDark,
                title: 'Estado Crítico',
                value: '$riskCount',
                subtitle: riskCount > 0 ? '⚠️ Requiere atención' : 'Sin riesgos',
                icon: Icons.warning_rounded,
                color: riskCount > 0 ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSecondaryIndicator(
                isDark: isDark,
                title: 'En Atención',
                value: '$attentionCount',
                subtitle: 'Requieren seguimiento',
                icon: Icons.timeline_rounded,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSecondaryIndicator(
                isDark: isDark,
                title: 'Total Lotes',
                value: '$totalLots',
                subtitle: 'En todas las fincas',
                icon: Icons.select_all_rounded,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildStatusDistribution(isDark, textColor, farmProvider),
      ],
    );
  }

  // ── Financiero ─────────────────────────────────────────────────
  Widget _buildFinancialIndicators(
      bool isDark,
      Color textColor,
      FarmProvider farmProvider,
      ActivitiesProvider activitiesProvider,
      ) {
    final totalCost = _getTotalCost(activitiesProvider);
    final currentMonthCost = _getCurrentMonthCost(activitiesProvider);
    final costPerKg = _getCostPerKg(farmProvider, activitiesProvider);
    final totalProduction = _getTotalProduction(farmProvider);
    final totalFarms = farmProvider.farms.length;
    final costsByCategory = _getCostsByCategory(activitiesProvider);
    final totalActivities = activitiesProvider.activities.length;

    // Calcular rentabilidad estimada (simulada con datos disponibles)
    final estimatedRevenue = totalProduction * 45; // Precio estimado $45/kg
    final profitability = totalCost > 0 ? ((estimatedRevenue - totalCost) / totalCost * 100) : 0;

    return Column(
      children: [
        _buildMainIndicator(
          isDark: isDark,
          title: 'Rentabilidad Estimada',
          value: '${profitability.toStringAsFixed(1)}%',
          subtitle: totalCost > 0 ? 'Margen sobre costos' : 'Sin costos registrados',
          icon: Icons.trending_up_rounded,
          color: profitability > 20 ? Colors.green : Colors.orange,
          progress: profitability > 0 ? (profitability / 100).clamp(0.0, 1.0) : 0,
          progressLabel: profitability > 0
              ? 'Basado en ${totalProduction.toStringAsFixed(0)} kg producidos'
              : 'Registra actividades con costos',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSecondaryIndicator(
                isDark: isDark,
                title: 'Costo Total',
                value: '\$${totalCost.toStringAsFixed(0)}',
                subtitle: '${totalActivities} actividades',
                icon: Icons.attach_money_rounded,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSecondaryIndicator(
                isDark: isDark,
                title: 'Costo/kg',
                value: '\$${costPerKg.toStringAsFixed(2)}',
                subtitle: 'Promedio por kg',
                icon: Icons.money_rounded,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSecondaryIndicator(
                isDark: isDark,
                title: 'Costo Este Mes',
                value: '\$${currentMonthCost.toStringAsFixed(0)}',
                subtitle: 'Gastos del mes',
                icon: Icons.calendar_today_rounded,
                color: Colors.purple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSecondaryIndicator(
                isDark: isDark,
                title: 'Fincas',
                value: '$totalFarms',
                subtitle: 'Unidades productivas',
                icon: Icons.landscape_rounded,
                color: Colors.brown,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildCostDistribution(isDark, textColor, costsByCategory),
      ],
    );
  }

  // ── Sostenibilidad ────────────────────────────────────────────
  Widget _buildSustainabilityIndicators(bool isDark, Color textColor, FarmProvider farmProvider) {
    final allLots = _getAllLots(farmProvider);
    final totalArea = _getTotalArea(farmProvider);
    final totalTrees = _getTotalTrees(farmProvider);
    final totalFarms = farmProvider.farms.length;
    final healthyPercentage = _getHealthyPercentage(farmProvider);

    // Árboles por hectárea (densidad)
    final treesPerHa = totalArea > 0 ? totalTrees / totalArea : 0;

    // Estimación de captura de carbono (1 árbol captura ~20kg CO2/año)
    final carbonCapture = totalTrees * 20 / 1000; // en toneladas

    return Column(
      children: [
        _buildMainIndicator(
          isDark: isDark,
          title: 'Captura de Carbono',
          value: '${carbonCapture.toStringAsFixed(1)} t CO₂',
          subtitle: '${totalTrees} árboles en producción',
          icon: Icons.eco_rounded,
          color: Colors.green,
          progress: totalTrees > 0 ? 0.6 : 0,
          progressLabel: totalTrees > 0
              ? '${(carbonCapture / 5 * 100).toStringAsFixed(0)}% de meta 5t CO₂'
              : 'Registra árboles en tus lotes',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSecondaryIndicator(
                isDark: isDark,
                title: 'Árboles totales',
                value: '$totalTrees',
                subtitle: 'En ${totalArea.toStringAsFixed(1)} ha',
                icon: Icons.nature_rounded,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSecondaryIndicator(
                isDark: isDark,
                title: 'Densidad',
                value: '${treesPerHa.toStringAsFixed(0)} árboles/ha',
                subtitle: 'Densidad de siembra',
                icon: Icons.grid_on_rounded,
                color: Colors.teal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSecondaryIndicator(
                isDark: isDark,
                title: 'Fincas',
                value: '$totalFarms',
                subtitle: 'Unidades productivas',
                icon: Icons.landscape_rounded,
                color: Colors.brown,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSecondaryIndicator(
                isDark: isDark,
                title: 'Salud del cultivo',
                value: '${healthyPercentage.toStringAsFixed(0)}%',
                subtitle: 'Lotes saludables',
                icon: Icons.shield_rounded,
                color: healthyPercentage > 70 ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Gestión ────────────────────────────────────────────────────
  Widget _buildManagementIndicators(bool isDark, Color textColor, FarmProvider farmProvider) {
    final allLots = _getAllLots(farmProvider);
    final totalFarms = farmProvider.farms.length;
    final totalLots = allLots.length;
    final healthyCount = allLots.where((l) => l.status == LotStatus.healthy).length;
    final attentionCount = allLots.where((l) => l.status == LotStatus.attention).length;
    final riskCount = allLots.where((l) => l.status == LotStatus.risk).length;

    // Actividades completadas (simulado)
    final completionRate = totalLots > 0 ? (healthyCount / totalLots * 100) : 0;

    return Column(
      children: [
        _buildMainIndicator(
          isDark: isDark,
          title: 'Estado General',
          value: '${completionRate.toStringAsFixed(0)}%',
          subtitle: 'Lotes en buen estado',
          icon: Icons.task_alt_rounded,
          color: completionRate > 70 ? Colors.green : Colors.orange,
          progress: completionRate / 100,
          progressLabel: '${healthyCount} saludables, $attentionCount atención, $riskCount riesgo',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSecondaryIndicator(
                isDark: isDark,
                title: 'Total Fincas',
                value: '$totalFarms',
                subtitle: 'Unidades de producción',
                icon: Icons.home_rounded,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSecondaryIndicator(
                isDark: isDark,
                title: 'Total Lotes',
                value: '$totalLots',
                subtitle: 'En todas las fincas',
                icon: Icons.view_module_rounded,
                color: Colors.brown,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSecondaryIndicator(
                isDark: isDark,
                title: 'Lotes Críticos',
                value: '$riskCount',
                subtitle: riskCount > 0 ? '⚠️ Requieren atención' : 'Sin riesgos',
                icon: Icons.warning_rounded,
                color: riskCount > 0 ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSecondaryIndicator(
                isDark: isDark,
                title: 'Superficie Total',
                value: '${_getTotalArea(farmProvider).toStringAsFixed(1)} ha',
                subtitle: 'En producción',
                icon: Icons.landscape_rounded,
                color: Colors.teal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Widgets de Indicadores ──────────────────────────────────

  Widget _buildMainIndicator({
    required bool isDark,
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required double progress,
    required String progressLabel,
  }) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.15),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: textColor.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            progressLabel,
            style: TextStyle(
              fontSize: 11,
              color: textColor.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryIndicator({
    required bool isDark,
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.coffeeDeep.withOpacity(0.5)
            : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : AppTheme.darkCoffee.withOpacity(0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: textColor.withOpacity(0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 9,
              color: textColor.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  // ── Gráficos ──────────────────────────────────────────────────

  Widget _buildProductionChart(bool isDark, Color textColor, FarmProvider farmProvider) {
    final allLots = _getAllLots(farmProvider);
    final List<double> productionData = allLots.map((lot) => lot.estimatedProduction).toList();
    final maxProduction = productionData.isEmpty ? 1 : productionData.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.coffeeDeep.withOpacity(0.5)
            : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : AppTheme.darkCoffee.withOpacity(0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Producción por Lote',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const Spacer(),
              Text(
                '${allLots.length} lotes',
                style: TextStyle(
                  fontSize: 11,
                  color: textColor.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (allLots.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Sin lotes registrados',
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor.withOpacity(0.5),
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: allLots.take(10).map((lot) {
                  final barHeight = maxProduction > 0 ? lot.estimatedProduction / maxProduction : 0;
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 20,
                          // ✅ CORREGIDO: 60 * height.clamp(0.05, 1.0)
                          height: 60 * barHeight.clamp(0.05, 1.0).toDouble(),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                AppTheme.primaryGreen,
                                lot.status == LotStatus.healthy
                                    ? AppTheme.primaryGreen
                                    : lot.status == LotStatus.attention
                                    ? Colors.orange
                                    : Colors.red,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lot.name.length > 4 ? '${lot.name.substring(0, 4)}...' : lot.name,
                          style: TextStyle(
                            fontSize: 8,
                            color: textColor.withOpacity(0.5),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusDistribution(bool isDark, Color textColor, FarmProvider farmProvider) {
    final statusCount = _getLotsByStatus(farmProvider);
    final totalLots = statusCount.values.fold(0, (sum, count) => sum + count);

    if (totalLots == 0) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? AppTheme.coffeeDeep.withOpacity(0.5)
              : Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : AppTheme.darkCoffee.withOpacity(0.06),
          ),
        ),
        child: Center(
          child: Text(
            'Sin lotes para mostrar distribución',
            style: TextStyle(
              fontSize: 13,
              color: textColor.withOpacity(0.5),
            ),
          ),
        ),
      );
    }

    final healthy = statusCount[LotStatus.healthy] ?? 0;
    final attention = statusCount[LotStatus.attention] ?? 0;
    final risk = statusCount[LotStatus.risk] ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.coffeeDeep.withOpacity(0.5)
            : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : AppTheme.darkCoffee.withOpacity(0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distribución de Estado',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatusBar('Saludable', healthy, totalLots, Colors.green),
              const SizedBox(width: 4),
              _buildStatusBar('Atención', attention, totalLots, Colors.orange),
              const SizedBox(width: 4),
              _buildStatusBar('Riesgo', risk, totalLots, Colors.red),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatusLegend('Saludable', healthy, Colors.green),
              _buildStatusLegend('Atención', attention, Colors.orange),
              _buildStatusLegend('Riesgo', risk, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBar(String label, int count, int total, Color color) {
    final percentage = total > 0 ? count / total : 0;
    return Expanded(
      child: Container(
        height: 8,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        width: percentage * 100,
      ),
    );
  }

  Widget _buildStatusLegend(String label, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$label ($count)',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildCostDistribution(bool isDark, Color textColor, Map<String, double> costsByCategory) {
    final total = costsByCategory.values.fold(0.0, (sum, value) => sum + value);

    if (total == 0) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? AppTheme.coffeeDeep.withOpacity(0.5)
              : Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : AppTheme.darkCoffee.withOpacity(0.06),
          ),
        ),
        child: Center(
          child: Text(
            'Sin costos registrados',
            style: TextStyle(
              fontSize: 13,
              color: textColor.withOpacity(0.5),
            ),
          ),
        ),
      );
    }

    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.red,
      Colors.brown,
    ];

    final entries = costsByCategory.entries.toList();
    final sortedEntries = entries..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.coffeeDeep.withOpacity(0.5)
            : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : AppTheme.darkCoffee.withOpacity(0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distribución de Costos',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          ...sortedEntries.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final percentage = (item.value / total * 100);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: colors[index % colors.length],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.key,
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colors[index % colors.length],
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 60,
                    child: Text(
                      '\$${item.value.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 8),
          Divider(color: textColor.withOpacity(0.1)),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  '\$${total.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _goBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      context.go(RouteNames.dashboard);
    }
  }
}