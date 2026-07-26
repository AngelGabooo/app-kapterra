// lib/features/buyer/presentation/screens/producers_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/buyer/providers/cooperative_producers_provider.dart';
import 'package:kaabcafe/features/buyer/providers/technicians_provider.dart';
import 'package:kaabcafe/features/buyer/presentation/widgets/register_producer_dialog.dart';
import 'package:kaabcafe/features/buyer/presentation/widgets/assign_technician_dialog.dart';
import 'package:kaabcafe/features/buyer/data/models/producer_summary_model.dart';

class ProducersScreen extends StatefulWidget {
  const ProducersScreen({super.key});

  @override
  State<ProducersScreen> createState() => _ProducersScreenState();
}

class _ProducersScreenState extends State<ProducersScreen> {
  int _currentIndex = 1;
  String _searchQuery = '';
  String _selectedFilter = 'Todos';
  final List<String> _filters = [
    'Todos',
    'Activos',
    'Inactivos',
    'Pendientes',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CooperativeProducersProvider>(context, listen: false);
      if (provider.producers.isEmpty) {
        provider.loadSampleProducers();
      }
    });
  }

  // ✅ OBTENER PRODUCTORES FILTRADOS
  List<ProducerSummaryModel> get _filteredProducers {
    final provider = Provider.of<CooperativeProducersProvider>(context);
    var list = provider.producers;

    if (_searchQuery.isNotEmpty) {
      list = list.where((p) =>
      p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.phone.contains(_searchQuery)
      ).toList();
    }

    if (_selectedFilter != 'Todos') {
      final statusMap = {
        'Activos': 'Activo',
        'Inactivos': 'Inactivo',
        'Pendientes': 'Pendiente',
      };
      final status = statusMap[_selectedFilter];
      if (status != null) {
        list = list.where((p) => p.status == status).toList();
      }
    }

    return list;
  }

  // ✅ MOSTRAR DIÁLOGO PARA REGISTRAR PRODUCTOR
  void _showRegisterDialog() {
    showDialog(
      context: context,
      builder: (context) => RegisterProducerDialog(
        onSave: (producer) {
          Provider.of<CooperativeProducersProvider>(context, listen: false).addProducer(producer);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Productor registrado correctamente'),
              backgroundColor: AppTheme.primaryGreen,
            ),
          );
        },
      ),
    );
  }

  // ✅ ELIMINAR PRODUCTOR
  void _confirmDeleteProducer(ProducerSummaryModel producer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text('Eliminar productor'),
        content: Text(
          '¿Estás seguro de que deseas eliminar a "${producer.name}"?\n\nEsta acción no se puede deshacer.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<CooperativeProducersProvider>(context, listen: false)
                  .removeProducer(producer.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('🗑️ Productor "${producer.name}" eliminado'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  // ✅ ASOCIAR TÉCNICO A PRODUCTOR - ACTUALIZADO
  void _showAssignTechnicianDialog(ProducerSummaryModel producer) {
    final techniciansProvider = Provider.of<TechniciansProvider>(context, listen: false);
    final availableTechnicians = techniciansProvider.technicians
        .where((t) => t.status == 'Activo')
        .toList();

    if (availableTechnicians.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ No hay técnicos disponibles. Registra un técnico primero.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AssignTechnicianDialog(
        producer: producer,
        technicians: availableTechnicians,
      ),
    ).then((selectedTechnicianId) {
      if (selectedTechnicianId != null && selectedTechnicianId is String) {
        // ✅ Asignar técnico al productor
        techniciansProvider.assignProducerToTechnician(selectedTechnicianId, producer.id);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Técnico asignado a "${producer.name}" correctamente'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark ? AppTheme.coffeeDeep : Colors.white;

    final provider = Provider.of<CooperativeProducersProvider>(context);
    final filteredProducers = _filteredProducers;
    final bool hasData = filteredProducers.isNotEmpty;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              isDark ? AppTheme.coffeeDark : AppTheme.lightBeige,
              isDark ? AppTheme.coffeeDeep.withOpacity(0.5) : AppTheme.primaryGreen.withOpacity(0.03),
              isDark ? AppTheme.coffeeDark : AppTheme.lightBeige,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Barra superior
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Productores Asociados',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Gestiona y supervisa los productores de la cooperativa.',
                            style: TextStyle(
                              fontSize: 13,
                              color: textColor.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.search, color: textColor),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.filter_list, color: textColor),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.coffeeMedium : AppTheme.primaryGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: _showRegisterDialog,
                        icon: const Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              // Contenido
              Expanded(
                child: hasData
                    ? _buildContentWithData(context, isDark, cardColor, textColor, filteredProducers, provider)
                    : _buildEmptyState(isDark, textColor),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.coffeeDeep : Colors.white,
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
            setState(() {
              _currentIndex = index;
            });
            if (index == 0) {
              context.go(RouteNames.cooperativeDashboard);
            } else if (index == 1) {
              context.go(RouteNames.producers);
            } else if (index == 2) {
              context.go(RouteNames.acopio);
            } else if (index == 3) {
              context.go(RouteNames.reports);
            } else if (index == 4) {
              context.go(RouteNames.cooperativeProfile);
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? AppTheme.coffeeDeep : Colors.white,
          selectedItemColor: isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen,
          unselectedItemColor: textColor.withOpacity(0.35),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Productores'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Acopio'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Reportes'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, Color textColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    (isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen).withOpacity(0.1),
                    (isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen).withOpacity(0.03),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.people_outline,
                size: 50,
                color: (isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen).withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Aún no existen productores asociados',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Comienza registrando el primer productor para la cooperativa.',
              style: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.6),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _showRegisterDialog,
              icon: const Icon(Icons.person_add),
              label: const Text('Registrar productor'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppTheme.coffeeMedium : AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentWithData(
      BuildContext context,
      bool isDark,
      Color cardColor,
      Color textColor,
      List<ProducerSummaryModel> producers,
      CooperativeProducersProvider provider,
      ) {
    final count = provider.count;
    final activeCount = provider.activeCount;
    final totalProduction = provider.totalProduction;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // KPIs
          Row(
            children: [
              _buildKPI('Productores', '$count', Icons.people, isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen, isDark),
              const SizedBox(width: 12),
              _buildKPI('Activos', '$activeCount', Icons.check_circle, isDark ? AppTheme.coffeeGoldLight : AppTheme.secondaryGreen, isDark),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildKPI('Producción', '${totalProduction.toStringAsFixed(0)} kg', Icons.eco, isDark ? AppTheme.coffeeGoldLight : AppTheme.goldCoffee, isDark),
              const SizedBox(width: 12),
              _buildKPI('Promedio', '${(totalProduction / (count > 0 ? count : 1)).toStringAsFixed(0)} kg', Icons.trending_up, isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen, isDark),
            ],
          ),

          const SizedBox(height: 20),

          // Buscador
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Buscar productor...',
                hintStyle: TextStyle(color: textColor.withOpacity(0.4)),
                prefixIcon: Icon(Icons.search, color: textColor.withOpacity(0.4)),
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Filtros
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = filter),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? (isDark ? AppTheme.coffeeMedium : AppTheme.primaryGreen) : cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.transparent : Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? Colors.white : textColor.withOpacity(0.6),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Lista de productores
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Productores (${producers.length})',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _showRegisterDialog,
                      child: const Text('+ Agregar'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (producers.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: (isDark ? AppTheme.coffeeDark : AppTheme.lightBeige).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.people_outline, color: textColor.withOpacity(0.2)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'No hay productores con estos filtros',
                            style: TextStyle(
                              fontSize: 13,
                              color: textColor.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...producers.map((producer) => _buildProducerCard(producer, isDark, textColor)),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // ✅ TARJETA DE PRODUCTOR INDIVIDUAL
  Widget _buildProducerCard(ProducerSummaryModel producer, bool isDark, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.coffeeDark : AppTheme.lightBeige.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          // Info del productor
          Row(
            children: [
              // Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    producer.name.isNotEmpty
                        ? producer.name.split(' ').map((e) => e[0]).take(2).join()
                        : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Información
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      producer.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      producer.email,
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor.withOpacity(0.5),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.landscape, size: 12, color: textColor.withOpacity(0.3)),
                        const SizedBox(width: 4),
                        Text(
                          '${producer.farmsCount} fincas',
                          style: TextStyle(
                            fontSize: 11,
                            color: textColor.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.eco, size: 12, color: textColor.withOpacity(0.3)),
                        const SizedBox(width: 4),
                        Text(
                          '${producer.totalProduction.toStringAsFixed(0)} kg',
                          style: TextStyle(
                            fontSize: 11,
                            color: textColor.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Estado
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: producer.status == 'Activo'
                      ? Colors.green.withOpacity(0.1)
                      : producer.status == 'Pendiente'
                      ? Colors.orange.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  producer.status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: producer.status == 'Activo'
                        ? Colors.green
                        : producer.status == 'Pendiente'
                        ? Colors.orange
                        : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // ✅ Botones de acción
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Botón Asignar técnico
              OutlinedButton.icon(
                onPressed: () => _showAssignTechnicianDialog(producer),
                icon: Icon(Icons.engineering, size: 16, color: AppTheme.primaryGreen),
                label: const Text('Técnico'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  side: BorderSide(color: AppTheme.primaryGreen.withOpacity(0.3)),
                ),
              ),
              const SizedBox(width: 8),
              // Botón Eliminar
              OutlinedButton.icon(
                onPressed: () => _confirmDeleteProducer(producer),
                icon: Icon(Icons.delete_outline, size: 16, color: Colors.red),
                label: const Text('Eliminar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  side: BorderSide(color: Colors.red.withOpacity(0.3)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKPI(String title, String value, IconData icon, Color color, bool isDark) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.coffeeDeep : Colors.white,
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
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                color: textColor.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}