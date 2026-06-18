import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';
import 'package:kaabcafe/features/farms/data/models/lot_model.dart';

class FarmDetailScreen extends StatelessWidget {
  final FarmDetailsModel farm;

  const FarmDetailScreen({super.key, required this.farm});

  @override
  Widget build(BuildContext context) {
    // Verificación de seguridad
    if (farm == null) {
      return Scaffold(
        backgroundColor: AppTheme.lightBeige,
        appBar: AppBar(
          backgroundColor: AppTheme.primaryGreen,
          foregroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => context.go(RouteNames.myFarms), // ✅ Usar go en lugar de pop
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('Error'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text('Error al cargar la finca'),
            ],
          ),
        ),
      );
    }

    // Datos de ejemplo para los lotes
    final List<LotModel> lots = [
      LotModel(
        id: '1',
        name: 'Lote Norte',
        variety: 'Bourbon',
        estimatedProduction: 500,
        area: 2.5,
        status: LotStatus.healthy,
        treesCount: 5000,
      ),
      LotModel(
        id: '2',
        name: 'Lote Sur',
        variety: 'Geisha',
        estimatedProduction: 350,
        area: 1.8,
        status: LotStatus.healthy,
        treesCount: 3600,
      ),
      LotModel(
        id: '3',
        name: 'Lote Este',
        variety: 'Catuaí',
        estimatedProduction: 280,
        area: 1.2,
        status: LotStatus.attention,
        treesCount: 2400,
      ),
    ];

    return Scaffold(
      backgroundColor: AppTheme.lightBeige,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => context.go(RouteNames.myFarms), // ✅ Usar go en lugar de pop
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(farm.name),
        actions: [
          IconButton(
            onPressed: () {
              context.push(RouteNames.editFarm, extra: farm);
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información de la finca
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.location_on, 'Ubicación', farm.location),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.landscape, 'Hectáreas', '${farm.hectares} ha'),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.view_module, 'Lotes', '${farm.lots} lotes'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Lotes de la finca',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkCoffee,
              ),
            ),
            const SizedBox(height: 16),

            if (lots.isEmpty)
              _buildEmptyLots(context)
            else
              ...lots.map((lot) => _buildLotCard(context, lot)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryGreen),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.darkCoffee.withOpacity(0.7),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkCoffee,
          ),
        ),
      ],
    );
  }

  Widget _buildLotCard(BuildContext context, LotModel lot) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          context.push(
            RouteNames.lotDetail,
            extra: {
              'lot': lot,
              'farm': farm,
            },
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: lot.statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      lot.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkCoffee,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: lot.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      lot.statusText,
                      style: TextStyle(
                        fontSize: 12,
                        color: lot.statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Variedad: ${lot.variety}',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.darkCoffee.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Área: ${lot.area} ha | Producción: ${lot.estimatedProduction} kg',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.darkCoffee.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      context.push(
                        RouteNames.editLot,
                        extra: {
                          'lot': lot,
                          'farm': farm,
                        },
                      );
                    },
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Editar'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () {
                      context.push(
                        RouteNames.lotHistory,
                        extra: {
                          'lot': lot,
                          'farm': farm,
                        },
                      );
                    },
                    icon: const Icon(Icons.history, size: 16),
                    label: const Text('Historial'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.goldCoffee,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyLots(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.view_module,
            size: 64,
            color: AppTheme.darkCoffee.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay lotes registrados',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkCoffee,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Comienza agregando lotes a tu finca',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.darkCoffee.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.push(RouteNames.createLot, extra: farm);
            },
            icon: const Icon(Icons.add),
            label: const Text('Crear Lote'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}