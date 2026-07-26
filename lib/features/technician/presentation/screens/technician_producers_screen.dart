// lib/features/technician/presentation/screens/technician_producers_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/technician/providers/technician_producers_provider.dart';
import 'package:kaabcafe/features/technician/data/models/technician_model.dart';

class TechnicianProducersScreen extends StatefulWidget {
  const TechnicianProducersScreen({super.key});

  @override
  State<TechnicianProducersScreen> createState() => _TechnicianProducersScreenState();
}

class _TechnicianProducersScreenState extends State<TechnicianProducersScreen> {
  String _searchQuery = '';
  ProducerStatus? _selectedFilter;
  int _currentIndex = 1;

  final List<String> _filterOptions = ['Todos', 'Excelente', 'Atención', 'Riesgo'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TechnicianProducersProvider>(context, listen: false);
      if (provider.producers.isEmpty) {
        provider.loadSampleProducers();
      }
    });
  }

  List<TechnicianProducerModel> get _filteredProducers {
    final provider = Provider.of<TechnicianProducersProvider>(context);
    var list = provider.producers;

    if (_searchQuery.isNotEmpty) {
      list = list.where((p) =>
      p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.location.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    if (_selectedFilter != null) {
      list = list.where((p) => p.status == _selectedFilter).toList();
    }

    return list;
  }

  // ✅ Navegar a detalle del productor
  void _showProducerDetail(TechnicianProducerModel producer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TechnicianProducerDetailSheet(
        producer: producer,
        isDark: Theme.of(context).brightness == Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark ? AppTheme.coffeeDeep : Colors.white;

    final provider = Provider.of<TechnicianProducersProvider>(context);
    final filtered = _filteredProducers;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.coffeeDark : AppTheme.lightBeige,
      appBar: AppBar(
        backgroundColor: isDark ? AppTheme.coffeeDeep : Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go(RouteNames.technicianDashboard),
          icon: Icon(Icons.arrow_back, color: textColor),
        ),
        title: Text(
          'Mis Productores',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, color: textColor),
          ),
        ],
      ),
      body: Column(
        children: [
          // ✅ KPIs
          _buildKPIs(isDark, textColor, provider),
          // ✅ Filtros
          _buildFilters(isDark, textColor, cardColor),
          // ✅ Lista de productores
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState(isDark, textColor)
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final producer = filtered[index];
                return _buildProducerCard(producer, isDark, textColor);
              },
            ),
          ),
        ],
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
              context.go(RouteNames.technicianDashboard);
            } else if (index == 1) {
              context.go(RouteNames.technicianProducers);
            } else if (index == 2) {
              context.go(RouteNames.technicianAgenda);
            } else if (index == 4) {
              context.go(RouteNames.profile);
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? AppTheme.coffeeDeep : Colors.white,
          selectedItemColor: isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen,
          unselectedItemColor: textColor.withOpacity(0.35),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Productores'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Agenda'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Diagnóstico'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }

  // ✅ KPIs
  Widget _buildKPIs(bool isDark, Color textColor, TechnicianProducersProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildKPIItem(
            isDark: isDark,
            label: 'Total',
            value: '${provider.count}',
            icon: Icons.people,
            color: AppTheme.primaryGreen,
          ),
          const SizedBox(width: 12),
          _buildKPIItem(
            isDark: isDark,
            label: 'Excelente',
            value: '${provider.excellentCount}',
            icon: Icons.emoji_events,
            color: Colors.green,
          ),
          const SizedBox(width: 12),
          _buildKPIItem(
            isDark: isDark,
            label: 'Atención',
            value: '${provider.attentionCount}',
            icon: Icons.warning,
            color: Colors.orange,
          ),
          const SizedBox(width: 12),
          _buildKPIItem(
            isDark: isDark,
            label: 'Riesgo',
            value: '${provider.riskCount}',
            icon: Icons.dangerous,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildKPIItem({
    required bool isDark,
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.coffeeDeep : Colors.white,
          borderRadius: BorderRadius.circular(12),
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
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 14, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 8,
                color: textColor.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Filtros
  Widget _buildFilters(bool isDark, Color textColor, Color cardColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _filterOptions.length,
          itemBuilder: (context, index) {
            final filter = _filterOptions[index];
            final isSelected = (index == 0 && _selectedFilter == null) ||
                (index == 1 && _selectedFilter == ProducerStatus.excellent) ||
                (index == 2 && _selectedFilter == ProducerStatus.requiresAttention) ||
                (index == 3 && _selectedFilter == ProducerStatus.risk);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (index == 0) {
                    _selectedFilter = null;
                  } else if (index == 1) {
                    _selectedFilter = ProducerStatus.excellent;
                  } else if (index == 2) {
                    _selectedFilter = ProducerStatus.requiresAttention;
                  } else if (index == 3) {
                    _selectedFilter = ProducerStatus.risk;
                  }
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryGreen : Colors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
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
    );
  }

  // ✅ Tarjeta de productor
  Widget _buildProducerCard(TechnicianProducerModel producer, bool isDark, Color textColor) {
    return GestureDetector(
      onTap: () => _showProducerDetail(producer),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
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
        child: Row(
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
                  producer.name.split(' ').map((e) => e[0]).take(2).join(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 12, color: textColor.withOpacity(0.3)),
                      const SizedBox(width: 4),
                      Text(
                        producer.location,
                        style: TextStyle(
                          fontSize: 12,
                          color: textColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildChip(Icons.eco, '${producer.production} kg', Colors.green),
                      const SizedBox(width: 6),
                      _buildChip(Icons.qr_code, '${producer.traceability}%', AppTheme.goldCoffee),
                    ],
                  ),
                ],
              ),
            ),
            // Estado
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: producer.status.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                producer.status.label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: producer.status.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: color,
            ),
          ),
        ],
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
              'No tienes productores asignados',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Cuando te asignen productores, aparecerán aquí.',
              style: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.6),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ✅ BOTTOM SHEET PARA DETALLE DEL PRODUCTOR (TÉCNICO)
// ============================================================
class _TechnicianProducerDetailSheet extends StatelessWidget {
  final TechnicianProducerModel producer;
  final bool isDark;

  const _TechnicianProducerDetailSheet({
    required this.producer,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark ? AppTheme.coffeeDeep : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.coffeeDark : AppTheme.lightBeige,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: textColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Encabezado
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          producer.name.split(' ').map((e) => e[0]).take(2).join(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            producer.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            producer.location,
                            style: TextStyle(
                              fontSize: 13,
                              color: textColor.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: producer.status.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              producer.status.label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: producer.status.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // KPIs del productor
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryGreen.withOpacity(0.1),
                        AppTheme.goldCoffee.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '${producer.production.toStringAsFixed(0)} kg',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                            Text(
                              'Producción',
                              style: TextStyle(
                                fontSize: 10,
                                color: textColor.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '${producer.traceability.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.goldCoffee,
                              ),
                            ),
                            Text(
                              'Trazabilidad',
                              style: TextStyle(
                                fontSize: 10,
                                color: textColor.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '${DateTime.now().difference(DateTime.parse(producer.lastVisit)).inDays} días',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            Text(
                              'Última visita',
                              style: TextStyle(
                                fontSize: 10,
                                color: textColor.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Acciones
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          context.push(
                            RouteNames.technicianVisitRegistration,
                            extra: {
                              'producerName': producer.name,
                              'location': producer.location,
                            },
                          );
                        },
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Registrar Visita'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          side: BorderSide(color: AppTheme.primaryGreen.withOpacity(0.3)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          context.push(
                            RouteNames.technicianCropDiagnosis,
                            extra: {
                              'producerName': producer.name,
                              'farmName': 'Finca',
                              'lotName': 'Lote',
                              'location': producer.location,
                            },
                          );
                        },
                        icon: const Icon(Icons.science, size: 18),
                        label: const Text('Diagnóstico'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.goldCoffee,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          side: BorderSide(color: AppTheme.goldCoffee.withOpacity(0.3)),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Información adicional
                Container(
                  padding: const EdgeInsets.all(16),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Información adicional',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow('📅 Última visita', producer.lastVisit, textColor),
                      _buildInfoRow('📍 Ubicación', producer.location, textColor),
                      _buildInfoRow('📊 Producción total', '${producer.production} kg', textColor),
                      _buildInfoRow('🔗 Trazabilidad', '${producer.traceability}%', textColor),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
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
                color: textColor,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}