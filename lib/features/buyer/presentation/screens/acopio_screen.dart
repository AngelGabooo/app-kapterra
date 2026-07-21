// lib/features/buyer/presentation/screens/acopio_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/buyer/data/models/acopio_model.dart';
import 'package:kaabcafe/features/buyer/presentation/widgets/acopio_card.dart';
import 'package:kaabcafe/features/buyer/presentation/widgets/acopio_form_dialog.dart';
import 'package:kaabcafe/features/buyer/presentation/widgets/cooperative_kpi_card.dart';

class AcopioScreen extends StatefulWidget {
  const AcopioScreen({super.key});

  @override
  State<AcopioScreen> createState() => _AcopioScreenState();
}

class _AcopioScreenState extends State<AcopioScreen> {
  int _currentIndex = 2;
  String _searchQuery = '';
  String _selectedFilter = 'Todos';

  final List<String> _filters = [
    'Todos',
    'Pendiente de revisión',
    'Clasificado',
    'Almacenado',
    'Especialidad',
    'Orgánico',
    'Hoy',
  ];

  // ✅ Lista vacía inicialmente
  List<AcopioModel> _acopios = [];

  @override
  void initState() {
    super.initState();
    // ❌ Eliminamos la carga de datos de ejemplo
    // _loadSampleData();
  }

  // ❌ Eliminamos este método completamente
  // void _loadSampleData() {
  //   // Sin datos de ejemplo
  // }

  void _registerAcopio() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AcopioFormDialog(
        onSave: (acopio) {
          setState(() {
            _acopios.insert(0, acopio); // Agregar al inicio
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Acopio registrado correctamente'),
              backgroundColor: AppTheme.primaryGreen,
            ),
          );
        },
      ),
    );
  }

  void _viewAcopioDetail(AcopioModel acopio) {
    // TODO: Navegar a detalle del acopio
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ver detalle de: ${acopio.producerName}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _editAcopio(AcopioModel acopio) {
    // TODO: Editar acopio
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editar acopio de: ${acopio.producerName}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // ✅ Calcular estadísticas (siempre retornan 0 cuando está vacío)
  int get _totalEntregas => _acopios.length;
  double get _totalCafeRecibido => _acopios.fold(0, (sum, a) => sum + a.netWeight);
  int get _totalEspecialidad => _acopios.where((a) => a.classification == 'Especialidad').length;
  double get _inventarioDisponible => _acopios.where((a) => a.status == AcopioStatus.stored).fold(0, (sum, a) => sum + a.netWeight);

  List<AcopioModel> get _filteredAcopios {
    var filtered = _acopios;

    // Filtro por búsqueda
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((a) =>
      a.producerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          a.lotName.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // Filtro por categoría
    if (_selectedFilter != 'Todos') {
      if (_selectedFilter == 'Pendiente de revisión') {
        filtered = filtered.where((a) => a.status == AcopioStatus.pending || a.status == AcopioStatus.inReview).toList();
      } else if (_selectedFilter == 'Clasificado') {
        filtered = filtered.where((a) => a.status == AcopioStatus.classified).toList();
      } else if (_selectedFilter == 'Almacenado') {
        filtered = filtered.where((a) => a.status == AcopioStatus.stored).toList();
      } else if (_selectedFilter == 'Especialidad') {
        filtered = filtered.where((a) => a.classification == 'Especialidad').toList();
      } else if (_selectedFilter == 'Orgánico') {
        filtered = filtered.where((a) => a.classification.contains('Orgánico')).toList();
      } else if (_selectedFilter == 'Hoy') {
        filtered = filtered.where((a) =>
        a.date.day == DateTime.now().day &&
            a.date.month == DateTime.now().month &&
            a.date.year == DateTime.now().year
        ).toList();
      }
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark ? AppTheme.coffeeDeep : Colors.white;

    final bool hasData = _acopios.isNotEmpty;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.coffeeDark : AppTheme.lightBeige,
      body: SafeArea(
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
                          'Acopio',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Recepción y clasificación del café.',
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
                    icon: Icon(Icons.analytics, color: textColor),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.filter_list, color: textColor),
                  ),
                ],
              ),
            ),

            // Contenido
            Expanded(
              child: hasData
                  ? _buildContentWithData(isDark, cardColor, textColor)
                  : _buildEmptyState(isDark, textColor),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _registerAcopio,
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Acopio'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
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
            } else if (index == 4) {
              context.go(RouteNames.profile);
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? AppTheme.coffeeDeep : Colors.white,
          selectedItemColor: isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen,
          unselectedItemColor: textColor.withOpacity(0.35),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Inicio'),
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
                Icons.inventory_outlined,
                size: 50,
                color: (isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen).withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No se han registrado entregas de café',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Comienza registrando el primer acopio recibido por la cooperativa.',
              style: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.6),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _registerAcopio,
              icon: const Icon(Icons.add),
              label: const Text('Registrar Acopio'),
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

  Widget _buildContentWithData(bool isDark, Color cardColor, Color textColor) {
    final filteredAcopios = _filteredAcopios;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // KPIs
          Row(
            children: [
              _buildKPI('📦', '$_totalEntregas', 'Entregas', isDark),
              const SizedBox(width: 12),
              _buildKPI('⚖️', '${_totalCafeRecibido.toStringAsFixed(0)} kg', 'Recibido', isDark),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildKPI('🏆', '$_totalEspecialidad', 'Especialidad', isDark),
              const SizedBox(width: 12),
              _buildKPI('🏢', '${_inventarioDisponible.toStringAsFixed(0)} kg', 'Inventario', isDark),
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
                hintText: 'Buscar por productor, lote o folio...',
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

          const SizedBox(height: 16),

          // Inventario
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [AppTheme.coffeeDeep, AppTheme.coffeeDark]
                    : [Colors.white, AppTheme.lightBeige],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.2)
                      : Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      '📦 Inventario disponible',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_inventarioDisponible.toStringAsFixed(0)} kg',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Almacenado',
                            style: TextStyle(
                              fontSize: 11,
                              color: textColor.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_inventarioDisponible.toStringAsFixed(0)} kg',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'En revisión',
                            style: TextStyle(
                              fontSize: 11,
                              color: textColor.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_acopios.where((a) => a.status == AcopioStatus.inReview).fold(0.0, (sum, a) => sum + a.netWeight).toStringAsFixed(0)} kg',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.goldCoffee,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Pendiente',
                            style: TextStyle(
                              fontSize: 11,
                              color: textColor.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_acopios.where((a) => a.status == AcopioStatus.pending).fold(0.0, (sum, a) => sum + a.netWeight).toStringAsFixed(0)} kg',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _inventarioDisponible > 0 ? 0.65 : 0,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Lista de acopios
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Registros de acopio',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 16),
                if (filteredAcopios.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: (isDark ? AppTheme.coffeeDark : AppTheme.lightBeige).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.inventory_outlined, color: textColor.withOpacity(0.2)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'No hay registros con estos filtros',
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
                  Column(
                    children: filteredAcopios.map((acopio) => AcopioCard(
                      acopio: acopio,
                      isDark: isDark,
                      onTap: () => _viewAcopioDetail(acopio),
                      onEdit: acopio.status == AcopioStatus.pending || acopio.status == AcopioStatus.inReview
                          ? () => _editAcopio(acopio)
                          : null,
                    )).toList(),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildKPI(String emoji, String value, String label, bool isDark) {
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
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              label,
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