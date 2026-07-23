// lib/features/marketplace/presentation/screens/purchases_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/marketplace/data/models/lot_model.dart';
import '../widgets/purchase_card.dart';

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({super.key});

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  int _currentIndex = 2;
  String _searchQuery = '';
  String _selectedFilter = 'Todos';

  final List<String> _filterOptions = [
    'Todos',
    'En proceso',
    'Entregado',
    'Cancelado',
  ];

  // ✅ Lista de compras vacía inicialmente
  final List<PurchaseModel> _purchases = [];

  bool get hasData => _purchases.isNotEmpty;

  List<PurchaseModel> get _filteredPurchases {
    var filtered = _purchases;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) =>
      p.lotName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.producerName.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    if (_selectedFilter != 'Todos') {
      filtered = filtered.where((p) => p.status == _selectedFilter).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark ? AppTheme.coffeeDeep : Colors.white;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.coffeeDark : AppTheme.lightBeige,
      body: SafeArea(
        child: Column(
          children: [
            // ── Barra superior ──────────────────────────────────
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
                          'Mis Compras',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Historial de compras realizadas',
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
                    onPressed: () {},
                    icon: Icon(Icons.filter_list, color: textColor),
                  ),
                ],
              ),
            ),

            // ── Buscador ──────────────────────────────────────────
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
                    hintText: 'Buscar por lote o productor...',
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

            const SizedBox(height: 12),

            // ── Filtros rápidos ──────────────────────────────────
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
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedFilter = filter),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? AppTheme.coffeeMedium : AppTheme.primaryGreen)
                              : cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : textColor.withOpacity(0.1),
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
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // ── Contenido ──────────────────────────────────────────
            Expanded(
              child: hasData
                  ? _buildContentWithData(isDark, textColor)
                  : _buildEmptyState(isDark, textColor),
            ),
          ],
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
                Icons.shopping_bag_outlined,
                size: 50,
                color: (isDark ? AppTheme.coffeeGoldLight : AppTheme.primaryGreen).withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Aún no has realizado compras',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Explora el catálogo de cafés con trazabilidad\nverificada y encuentra tu próximo lote.',
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

  Widget _buildContentWithData(bool isDark, Color textColor) {
    final filtered = _filteredPurchases;

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: textColor.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay compras con estos filtros',
              style: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.4),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: filtered.map((purchase) {
          return PurchaseCard(
            purchase: purchase,
            isDark: isDark,
            onTap: () {
              // TODO: Navegar al detalle de la compra
            },
          );
        }).toList(),
      ),
    );
  }
}

// ✅ Modelo de compra
class PurchaseModel {
  final String id;
  final String lotName;
  final String producerName;
  final String location;
  final double price;
  final double quantity;
  final double total;
  final DateTime purchaseDate;
  final String status; // 'En proceso', 'Entregado', 'Cancelado'
  final String? deliveryDate;
  final String? trackingNumber;
  final String imageUrl;
  final bool isVerified;

  PurchaseModel({
    required this.id,
    required this.lotName,
    required this.producerName,
    required this.location,
    required this.price,
    required this.quantity,
    required this.total,
    required this.purchaseDate,
    required this.status,
    this.deliveryDate,
    this.trackingNumber,
    required this.imageUrl,
    this.isVerified = true,
  });
}