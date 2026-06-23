import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/providers/farm_provider.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';
import 'package:kaabcafe/features/farms/data/models/lot_model.dart';

class FarmDetailScreen extends StatelessWidget {
  final FarmDetailsModel farm;

  const FarmDetailScreen({super.key, required this.farm});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final farmProvider = Provider.of<FarmProvider>(context);

    final updatedFarm = farmProvider.farms.firstWhere(
          (f) => f.id == farm.id,
      orElse: () => farm,
    );

    final List<LotModel> lots = farmProvider.getLotsForFarm(updatedFarm.id);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Dinámico
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        leading: IconButton(
          onPressed: () => context.go(RouteNames.myFarms),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(updatedFarm.name),
        actions: [
          IconButton(
            onPressed: () => context.push(RouteNames.editFarm, extra: updatedFarm),
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouteNames.createLot, extra: updatedFarm),
        backgroundColor: colorScheme.primary,
        icon: Icon(Icons.add_circle_outline, color: colorScheme.onPrimary),
        label: Text('Crear Lote', style: TextStyle(color: colorScheme.onPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              color: colorScheme.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.location_on, 'Ubicación', updatedFarm.location, theme),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.landscape, 'Hectáreas', '${updatedFarm.hectares} ha', theme),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.view_module, 'Lotes', '${updatedFarm.lots} lotes', theme),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Lotes de la finca',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
            const SizedBox(height: 16),

            if (lots.isEmpty)
              _buildEmptyLots(context, theme)
            else
              ...lots.map((lot) => _buildLotCard(context, lot, updatedFarm, theme)),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withOpacity(0.7))),
        const SizedBox(width: 8),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
      ],
    );
  }

  Widget _buildEmptyLots(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(color: theme.colorScheme.surfaceVariant, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Icon(Icons.view_module, size: 64, color: theme.colorScheme.onSurface.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text('No hay lotes registrados', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.push(RouteNames.createLot, extra: farm),
            icon: const Icon(Icons.add),
            label: const Text('Crear Lote'),
          ),
        ],
      ),
    );
  }

  Widget _buildLotCard(BuildContext context, LotModel lot, FarmDetailsModel farm, ThemeData theme) {
    return Dismissible(
      key: Key(lot.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Eliminar Lote'),
            content: const Text('¿Estás seguro de eliminar este lote?'),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<FarmProvider>(context, listen: false).deleteLotFromFarm(farm.id, lot.id);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        color: theme.colorScheme.surface,
        child: InkWell(
          onTap: () => context.push(RouteNames.lotDetail, extra: {'lot': lot, 'farm': farm}),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(color: lot.statusColor, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(lot.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface))),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Variedad: ${lot.variety} | Área: ${lot.area} ha', style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withOpacity(0.7))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}