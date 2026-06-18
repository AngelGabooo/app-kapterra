import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';
import 'package:kaabcafe/features/farms/presentation/widgets/farm_kpi_card.dart';
import 'package:kaabcafe/features/farms/presentation/widgets/farm_map_preview.dart';
import 'package:kaabcafe/features/farms/presentation/widgets/farm_card.dart';
import 'package:kaabcafe/features/farms/presentation/widgets/empty_farms_widget.dart';

class MyFarmsScreen extends StatefulWidget {
  const MyFarmsScreen({super.key});

  @override
  State<MyFarmsScreen> createState() => _MyFarmsScreenState();
}

class _MyFarmsScreenState extends State<MyFarmsScreen> {
  int _currentIndex = 1; // Fincas activo
  bool _isLoading = true;

  // Datos de ejemplo
  List<FarmDetailsModel> _farms = [];

  @override
  void initState() {
    super.initState();
    // Simular carga de datos
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _farms = [
          FarmDetailsModel(
            id: '1',
            name: 'Finca El Mirador',
            location: 'Motozintla, Chiapas',
            hectares: 5.2,
            lots: 4,
            productivity: 820,
            status: FarmHealthStatus.healthy,
            imageUrl: 'assets/img/finca1.png',
            latitude: 15.3643,
            longitude: -92.2489,
          ),
          FarmDetailsModel(
            id: '2',
            name: 'Finca La Esperanza',
            location: 'Tapachula, Chiapas',
            hectares: 8.0,
            lots: 6,
            productivity: 450,
            status: FarmHealthStatus.attention,
            imageUrl: 'assets/img/finca2.png',
            latitude: 14.9033,
            longitude: -92.2575,
          ),
          FarmDetailsModel(
            id: '3',
            name: 'Los Naranjos',
            location: 'Ocosingo, Chiapas',
            hectares: 3.5,
            lots: 2,
            productivity: 920,
            status: FarmHealthStatus.healthy,
            imageUrl: 'assets/img/finca3.png',
            latitude: 16.9065,
            longitude: -92.0979,
          ),
        ];
        _isLoading = false;
      });
    });
  }

  int get _totalLots => _farms.fold(0, (sum, farm) => sum + farm.lots);

  double get _totalProduction => _farms.fold(0.0, (sum, farm) => sum + (farm.productivity * farm.hectares));

  double get _avgProductivity => _farms.isEmpty ? 0.0 : _farms.fold(0.0, (sum, farm) => sum + farm.productivity) / _farms.length;

  void _goToFarmDetails(FarmDetailsModel farm) {
    // TODO: Navegar a detalles de la finca
    debugPrint('Ver detalles de: ${farm.name}');
  }

  void _editFarm(FarmDetailsModel farm) {
    debugPrint('Editar finca: ${farm.name}');
  }

  void _viewIndicators(FarmDetailsModel farm) {
    debugPrint('Ver indicadores de: ${farm.name}');
  }

  void _viewTraceability(FarmDetailsModel farm) {
    debugPrint('Ver trazabilidad de: ${farm.name}');
  }

  void _registerNewFarm() {
    context.go(RouteNames.registerFarm);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightBeige,
              AppTheme.primaryGreen.withOpacity(0.03),
              AppTheme.lightBeige,
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
                          const Text(
                            'Mis Fincas',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkCoffee,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Administra y monitorea tus unidades de producción.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.darkCoffee.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.search, color: AppTheme.darkCoffee),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.filter_list, color: AppTheme.darkCoffee),
                    ),
                  ],
                ),
              ),

              if (_isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_farms.isEmpty)
                Expanded(
                  child: EmptyFarmsWidget(onRegister: _registerNewFarm),
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // KPIs
                        Row(
                          children: [
                            FarmKPICard(
                              title: 'Fincas registradas',
                              value: '${_farms.length}',
                              icon: Icons.landscape,
                              color: AppTheme.primaryGreen,
                            ),
                            const SizedBox(width: 12),
                            FarmKPICard(
                              title: 'Lotes activos',
                              value: '$_totalLots',
                              icon: Icons.view_module,
                              color: AppTheme.goldCoffee,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            FarmKPICard(
                              title: 'Producción estimada',
                              value: '${_totalProduction.toStringAsFixed(0)} kg',
                              icon: Icons.eco,
                              color: AppTheme.secondaryGreen,
                            ),
                            const SizedBox(width: 12),
                            FarmKPICard(
                              title: 'Rendimiento promedio',
                              value: '${_avgProductivity.toStringAsFixed(0)} kg/ha',
                              icon: Icons.trending_up,
                              color: AppTheme.darkCoffee,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Mapa interactivo
                        FarmMapPreview(
                          farms: _farms,
                          onFarmTap: _goToFarmDetails,
                        ),

                        const SizedBox(height: 24),

                        // Título listado
                        const Text(
                          'Todas tus fincas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkCoffee,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Listado de fincas
                        ..._farms.map((farm) => FarmCard(
                          farm: farm,
                          onEdit: () => _editFarm(farm),
                          onIndicators: () => _viewIndicators(farm),
                          onTraceability: () => _viewTraceability(farm),
                        )),


                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: _farms.isNotEmpty
          ? FloatingActionButton(
        onPressed: _registerNewFarm,
        backgroundColor: AppTheme.primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
              context.go(RouteNames.dashboard);
            } else if (index == 1) {
              context.go(RouteNames.myFarms);
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.primaryGreen,
          unselectedItemColor: AppTheme.darkCoffee.withOpacity(0.5),
          selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
            BottomNavigationBarItem(icon: Icon(Icons.landscape), label: 'Fincas'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Indicadores'),
            BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Marketplace'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}