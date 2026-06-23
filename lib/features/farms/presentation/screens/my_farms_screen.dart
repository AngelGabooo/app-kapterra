import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/providers/farm_provider.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';
import 'package:kaabcafe/features/farms/presentation/widgets/farm_kpi_card.dart';
import 'package:kaabcafe/features/farms/presentation/widgets/farm_map_preview.dart';
import 'package:kaabcafe/features/farms/presentation/widgets/farm_card.dart';
import 'package:kaabcafe/features/farms/presentation/widgets/empty_farms_widget.dart';
import '../../../farm/data/models/farm_model.dart';

class MyFarmsScreen extends StatefulWidget {
  const MyFarmsScreen({super.key});

  @override
  State<MyFarmsScreen> createState() => _MyFarmsScreenState();
}

class _MyFarmsScreenState extends State<MyFarmsScreen> {
  void _registerNewFarm() async {
    final FarmModel? result = await context.push<FarmModel>(RouteNames.registerFarm);
    if (result != null && mounted) {
      Provider.of<FarmProvider>(context, listen: false).addFarm(FarmDetailsModel(
        id: DateTime.now().toString(),
        name: result.name,
        location: 'Ubicación registrada',
        hectares: 0,
        lots: 0,
        productivity: 0,
        status: FarmHealthStatus.healthy,
        imageUrl: 'assets/img/default_farm.png',
        latitude: result.latitude ?? 0.0,
        longitude: result.longitude ?? 0.0,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final farms = Provider.of<FarmProvider>(context).farms;

    final totalLots = farms.fold(0, (sum, f) => sum + f.lots);
    final totalProduction = farms.fold(0.0, (sum, f) => sum + (f.productivity * f.hectares));
    final avgProductivity = farms.isEmpty ? 0.0 : farms.fold(0.0, (sum, f) => sum + f.productivity) / farms.length;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.go(RouteNames.dashboard),
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: theme.colorScheme.onSurface,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mis Fincas', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface)),
                        Text('Administra tus unidades de producción.', style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withOpacity(0.5))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    LayoutBuilder(builder: (context, constraints) {
                      final totalWidth = constraints.maxWidth - 12;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: totalWidth * 0.55, child: FarmKPICard(title: 'Unidades', value: '${farms.length}', icon: Icons.landscape_rounded, height: 135, valueSize: 22, titleSize: 9, useNeonAccent: true)),
                          const SizedBox(width: 12),
                          SizedBox(width: totalWidth * 0.45, child: Column(children: [
                            FarmKPICard(title: 'Lotes activos', value: '$totalLots', icon: Icons.grid_view_rounded, height: 88),
                            const SizedBox(height: 12),
                            FarmKPICard(title: 'Rendimiento Medio', value: '${avgProductivity.toStringAsFixed(0)} kg/ha', icon: Icons.trending_up_rounded, height: 88),
                          ])),
                        ],
                      );
                    }),
                    const SizedBox(height: 12),
                    FarmKPICard(title: 'Producción Total estimada', value: '${totalProduction.toStringAsFixed(0)} kg', icon: Icons.eco_rounded, height: 88),
                    const SizedBox(height: 24),
                    farms.isEmpty
                        ? EmptyFarmsWidget(onRegister: _registerNewFarm)
                        : Column(children: farms.map((f) => FarmCard(farm: f)).toList()),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _registerNewFarm,
        backgroundColor: const Color(0xFFFF6B00),
        label: const Text('Nueva Finca', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}