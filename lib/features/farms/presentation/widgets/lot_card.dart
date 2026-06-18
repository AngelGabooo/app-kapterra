import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/farms/data/models/lot_model.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';

class LotCard extends StatelessWidget {
  final LotModel lot;
  final FarmDetailsModel farm;

  const LotCard({
    super.key,
    required this.lot,
    required this.farm,
  });

  void _goToDetail(BuildContext context) {
    context.go(
      RouteNames.lotDetail,
      extra: {
        'lot': lot,
        'farm': farm,
      },
    );
  }

  void _goToRegisterActivity(BuildContext context) {
    context.go(
      RouteNames.registerActivity,
      extra: {
        'lot': lot,
        'farm': farm,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170, // ✅ Reducido de 180 a 170
      child: Container(
        padding: const EdgeInsets.all(10), // ✅ Reducido de 12 a 10
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    lot.name,
                    style: const TextStyle(
                      fontSize: 13, // ✅ Reducido de 14 a 13
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkCoffee,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: 6, // ✅ Reducido de 8 a 6
                  height: 6,
                  decoration: BoxDecoration(
                    color: lot.statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              lot.variety,
              style: TextStyle(
                fontSize: 10, // ✅ Reducido de 11 a 10
                color: AppTheme.darkCoffee.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 6), // ✅ Reducido de 8 a 6
            Row(
              children: [
                Icon(Icons.agriculture, size: 11, color: AppTheme.primaryGreen), // ✅ Reducido de 12 a 11
                const SizedBox(width: 3),
                Flexible(
                  child: Text(
                    '${lot.estimatedProduction} kg',
                    style: TextStyle(
                      fontSize: 10, // ✅ Reducido de 11 a 10
                      fontWeight: FontWeight.w500,
                      color: AppTheme.darkCoffee,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6), // ✅ Reducido de 8 a 6
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => _goToDetail(context),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 4), // ✅ Reducido de 8 a 4
                      minimumSize: const Size(0, 28), // ✅ Altura mínima
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Ver',
                      style: TextStyle(fontSize: 11), // ✅ Tamaño fijo
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: TextButton(
                    onPressed: () => _goToRegisterActivity(context),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.goldCoffee,
                      padding: const EdgeInsets.symmetric(vertical: 4), // ✅ Reducido de 8 a 4
                      minimumSize: const Size(0, 28), // ✅ Altura mínima
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Reg',
                      style: TextStyle(fontSize: 11), // ✅ Tamaño fijo
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}