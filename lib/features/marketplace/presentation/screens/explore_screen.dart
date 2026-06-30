import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/marketplace/data/models/lot_model.dart';
import 'package:kaabcafe/features/marketplace/presentation/widgets/explore_filter_chip.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _currentIndex = 1;
  String _searchQuery = '';
  String _selectedFilter = 'Todos';
  bool _showAdvancedFilters = false;
  bool _isGridView = true;

  final List<String> _filterOptions = [
    'Todos',
    'Especialidad',
    'Orgánico',
    'Comercio Justo',
    'Alta montaña',
    'Disponible',
    'Verificado',
    'Recientes',
  ];

  // ✅ Lote de ejemplo
  final List<MarketplaceLotModel> _lots = [
    MarketplaceLotModel(
      id: '1',
      name: 'Lote Geisha Premium',
      producerName: 'Juan Pérez',
      location: 'Motozintla, Chiapas',
      price: 95,
      availableQuantity: 420,
      rating: 4.8,
      imageUrl: 'assets/img/lote_geisha.png',
      isVerified: true,
      category: 'Especialidad',
      description: 'Café de altura con perfil dulce y notas florales.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark ? AppTheme.coffeeDeep : Colors.white;

    final bool hasData = _lots.isNotEmpty;

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
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.go(RouteNames.marketplace),
                      icon: Icon(Icons.arrow_back, color: textColor),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Explorar Cafés',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Lotes trazables disponibles para compra.',
                            style: TextStyle(
                              fontSize: 12,
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
                      onPressed: () {
                        setState(() {
                          _showAdvancedFilters = !_showAdvancedFilters;
                        });
                      },
                      icon: Icon(
                        _showAdvancedFilters ? Icons.filter_alt : Icons.filter_alt_outlined,
                        color: _showAdvancedFilters ? AppTheme.primaryGreen : textColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Buscador
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 44,
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
                      hintText: 'Buscar por lote, productor, región o variedad...',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: textColor.withOpacity(0.4),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20,
                        color: textColor.withOpacity(0.4),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Filtros rápidos
              SizedBox(
                height: 36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filterOptions.length,
                  itemBuilder: (context, index) {
                    final filter = _filterOptions[index];
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ExploreFilterChip(
                        label: filter,
                        isSelected: isSelected,
                        isDark: isDark,
                        onTap: () {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),

              // Filtros avanzados
              if (_showAdvancedFilters)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                          Icon(Icons.filter_list, size: 18, color: textColor),
                          const SizedBox(width: 8),
                          Text(
                            'Filtros avanzados',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildFilterSection('Región', ['Chiapas', 'Oaxaca', 'Veracruz', 'Colombia', 'Guatemala']),
                      const SizedBox(height: 12),
                      _buildFilterSection('Variedad', ['Bourbon', 'Typica', 'Catuaí', 'Geisha', 'Robusta']),
                      const SizedBox(height: 12),
                      _buildFilterSection('Certificaciones', ['Orgánico', 'Comercio Justo', 'Sostenible']),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildRangeFilter('Precio', '\$0', '\$200'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildRangeFilter('Altitud', '900', '1800'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _showAdvancedFilters = false;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('Aplicar filtros'),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 8),

              // Resumen y orden
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      '${_lots.length} lotes encontrados',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: textColor.withOpacity(0.6),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => setState(() => _isGridView = true),
                          icon: Icon(
                            Icons.grid_view,
                            size: 20,
                            color: _isGridView ? AppTheme.primaryGreen : textColor.withOpacity(0.3),
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() => _isGridView = false),
                          icon: Icon(
                            Icons.list,
                            size: 20,
                            color: !_isGridView ? AppTheme.primaryGreen : textColor.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Listado de lotes
              Expanded(
                child: hasData
                    ? _buildContentWithData(isDark, cardColor, textColor)
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
              context.go(RouteNames.marketplace);
            } else if (index == 1) {
              context.go(RouteNames.explore);
            } else if (index == 4) {
              context.go(RouteNames.profile);
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? AppTheme.coffeeDeep : Colors.white,
          selectedItemColor: isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen,
          unselectedItemColor: textColor.withOpacity(0.35),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Marketplace'),
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explorar'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Compras'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: options.map((option) {
            return FilterChip(
              label: Text(
                option,
                style: const TextStyle(fontSize: 11),
              ),
              selected: false,
              onSelected: (selected) {},
              selectedColor: AppTheme.primaryGreen.withOpacity(0.1),
              checkmarkColor: AppTheme.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRangeFilter(String label, String min, String max) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  min,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('a', style: TextStyle(fontSize: 12)),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  max,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ],
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
                Icons.search_off,
                size: 50,
                color: (isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen).withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No encontramos lotes con esos filtros',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Prueba ajustando la región, variedad o rango de precio.',
              style: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.6),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _selectedFilter = 'Todos';
                  _searchQuery = '';
                  _showAdvancedFilters = false;
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Limpiar filtros'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
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
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _isGridView
          ? GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        itemCount: _lots.length,
        itemBuilder: (context, index) {
          final lot = _lots[index];
          return GestureDetector(
            onTap: () => context.push(
              RouteNames.marketplaceLotDetail,  // ✅ Nuevo nombre
              extra: {'lot': lot},
            ),
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryGreen.withOpacity(0.3),
                          AppTheme.secondaryGreen.withOpacity(0.2),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.coffee,
                        size: 40,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lot.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          lot.producerName,
                          style: TextStyle(
                            fontSize: 10,
                            color: textColor.withOpacity(0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.star, size: 12, color: AppTheme.goldCoffee),
                            Text(
                              lot.rating.toString(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '\$${lot.price.toStringAsFixed(0)}/kg',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.goldCoffee,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: lot.isVerified ? AppTheme.primaryGreen.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                lot.isVerified ? Icons.verified : Icons.info_outline,
                                size: 10,
                                color: lot.isVerified ? AppTheme.primaryGreen : Colors.grey,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                lot.isVerified ? 'Verificado' : 'Pendiente',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: lot.isVerified ? AppTheme.primaryGreen : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      )
          : ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _lots.length,
        itemBuilder: (context, index) {
          final lot = _lots[index];
          return GestureDetector(
            onTap: () => context.push(
              RouteNames.marketplaceLotDetail,  // ✅ Nuevo nombre
              extra: {'lot': lot},
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryGreen.withOpacity(0.3),
                          AppTheme.secondaryGreen.withOpacity(0.2),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.coffee,
                        size: 30,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lot.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          lot.producerName,
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.star, size: 14, color: AppTheme.goldCoffee),
                            Text(
                              lot.rating.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '\$${lot.price.toStringAsFixed(0)}/kg',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.goldCoffee,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: lot.isVerified ? AppTheme.primaryGreen.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                lot.isVerified ? 'Verificado' : 'Pendiente',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: lot.isVerified ? AppTheme.primaryGreen : Colors.grey,
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
            ),
          );
        },
      ),
    );
  }
}