// lib/features/marketplace/presentation/screens/marketplace_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/marketplace/data/models/lot_model.dart';
import 'package:kaabcafe/features/marketplace/data/models/producer_model.dart';
import 'package:kaabcafe/features/marketplace/presentation/widgets/marketplace_kpi_card.dart';
import 'package:kaabcafe/features/marketplace/presentation/widgets/lot_card.dart';
import 'package:kaabcafe/features/marketplace/presentation/widgets/producer_card.dart';
import 'package:kaabcafe/features/marketplace/presentation/widgets/category_chip.dart';
import 'package:kaabcafe/features/marketplace/presentation/widgets/recommendation_card.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  int _currentIndex = 0;
  String _searchQuery = '';

  // ✅ Datos vacíos
  final List<MarketplaceLotModel> _featuredLots = [];
  final List<MarketplaceProducerModel> _featuredProducers = [];
  final List<Map<String, dynamic>> _collections = [];
  final List<MarketplaceLotModel> _newLots = [];

  final List<String> _categories = [
    'Especialidad',
    'Orgánico',
    'Comercio Justo',
    'Premiados',
    'Sostenible',
    'Por Región',
  ];

  final bool hasData = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark ? AppTheme.coffeeDeep : Colors.white;

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
                    // Logo
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: isDark ? AppTheme.coffeeMedium : AppTheme.primaryGreen,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/img/logo_kaab_terra.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.agriculture,
                              size: 24,
                              color: Colors.white,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.coffeeDeep : Colors.white,
                          borderRadius: BorderRadius.circular(20),
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
                            hintText: 'Buscar café, productor o región...',
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
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
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
            // ✅ Navegación con 4 items (sin Favoritos)
            if (index == 0) {
              context.go(RouteNames.marketplace);
            } else if (index == 1) {
              context.go(RouteNames.explore);
            } else if (index == 2) {
              context.go(RouteNames.purchases);
            } else if (index == 3) {
              context.go(RouteNames.buyerProfile);
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
                Icons.store_outlined,
                size: 50,
                color: (isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen).withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No hay lotes disponibles',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Regresa más tarde para descubrir nuevos cafés\nde productores certificados.',
              style: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.6),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.go(RouteNames.explore),
              icon: const Icon(Icons.explore),
              label: const Text('Explorar Catálogo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppTheme.coffeeMedium : AppTheme.primaryGreen,
                foregroundColor: Colors.white,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner principal
          Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [AppTheme.coffeeMedium, AppTheme.coffeeWarm]
                    : [AppTheme.primaryGreen, AppTheme.secondaryGreen],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Icon(
                    Icons.agriculture,
                    size: 120,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Descubre cafés con trazabilidad verificada',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Conecta directamente con productores certificados.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.go(RouteNames.explore),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: isDark ? AppTheme.coffeeMedium : AppTheme.primaryGreen,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Explorar Cafés'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Categorías
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return CategoryChip(
                  label: _categories[index],
                  isDark: isDark,
                  onTap: () {},
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Lotes destacados (vacío)
          const Text(
            'Lotes Destacados',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.inventory_outlined, color: textColor.withOpacity(0.2)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No hay lotes destacados disponibles',
                    style: TextStyle(
                      fontSize: 13,
                      color: textColor.withOpacity(0.4),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Productores destacados (vacío)
          const Text(
            'Productores Destacados',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.people_outline, color: textColor.withOpacity(0.2)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Sin productores destacados',
                    style: TextStyle(
                      fontSize: 13,
                      color: textColor.withOpacity(0.4),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Mapa de origen
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mapa de Origen',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        (isDark ? AppTheme.coffeeMedium : AppTheme.primaryGreen).withOpacity(0.2),
                        (isDark ? AppTheme.coffeeWarm : AppTheme.secondaryGreen).withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map_outlined, size: 30, color: textColor.withOpacity(0.2)),
                        const SizedBox(height: 8),
                        Text(
                          'Sin regiones productoras disponibles',
                          style: TextStyle(
                            fontSize: 12,
                            color: textColor.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Recomendaciones IA
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [AppTheme.coffeeDeep.withOpacity(0.8), AppTheme.coffeeDark.withOpacity(0.5)]
                    : [AppTheme.goldCoffee.withOpacity(0.05), AppTheme.primaryGreen.withOpacity(0.02)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: (isDark ? AppTheme.coffeeGoldLight : AppTheme.goldCoffee).withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.psychology, color: isDark ? AppTheme.coffeeGoldLight : AppTheme.goldCoffee),
                    const SizedBox(width: 8),
                    Text(
                      'Recomendado para ti',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Cafés de altura con perfil dulce y notas florales.',
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.coffee, color: textColor.withOpacity(0.2)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Sin recomendaciones disponibles',
                          style: TextStyle(
                            fontSize: 13,
                            color: textColor.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Colecciones
          const Text(
            'Colecciones',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.collections_bookmark, color: textColor.withOpacity(0.2)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No hay colecciones disponibles',
                    style: TextStyle(
                      fontSize: 13,
                      color: textColor.withOpacity(0.4),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // KPIs
          Row(
            children: [
              MarketplaceKPICard(
                title: 'Lotes Disponibles',
                value: '0',
                icon: Icons.inventory,
                color: isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen,
                isDark: isDark,
              ),
              const SizedBox(width: 12),
              MarketplaceKPICard(
                title: 'Productores',
                value: '0',
                icon: Icons.people,
                color: isDark ? AppTheme.coffeeGoldLight : AppTheme.secondaryGreen,
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              MarketplaceKPICard(
                title: 'Regiones',
                value: '0',
                icon: Icons.location_on,
                color: isDark ? AppTheme.coffeeGoldLight : AppTheme.goldCoffee,
                isDark: isDark,
              ),
              const SizedBox(width: 12),
              MarketplaceKPICard(
                title: 'Lotes Verificados',
                value: '0',
                icon: Icons.verified,
                color: isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen,
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}