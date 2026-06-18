import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';

class FarmCard extends StatelessWidget {
  final FarmDetailsModel farm;
  final VoidCallback? onEdit;
  final VoidCallback? onIndicators;
  final VoidCallback? onTraceability;

  const FarmCard({
    super.key,
    required this.farm,
    this.onEdit,
    this.onIndicators,
    this.onTraceability,
  });

  void _goToDetail() {
    // ✅ Navegar al detalle de la finca
    // Usar context de la manera correcta
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen de portada (clickeable para navegar al detalle)
          GestureDetector(
            onTap: () => context.go(RouteNames.farmDetail, extra: farm),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.asset(
                farm.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryGreen.withOpacity(0.3),
                          AppTheme.secondaryGreen.withOpacity(0.2),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(Icons.landscape, size: 40, color: AppTheme.primaryGreen),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre y estado (clickeable)
                GestureDetector(
                  onTap: () => context.go(RouteNames.farmDetail, extra: farm),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          farm.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkCoffee,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: farm.statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: farm.statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              farm.statusText,
                              style: TextStyle(
                                fontSize: 11,
                                color: farm.statusColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // Ubicación (clickeable)
                GestureDetector(
                  onTap: () => context.go(RouteNames.farmDetail, extra: farm),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: AppTheme.goldCoffee),
                      const SizedBox(width: 4),
                      Text(
                        farm.location,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.darkCoffee.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Información rápida (clickeable)
                GestureDetector(
                  onTap: () => context.go(RouteNames.farmDetail, extra: farm),
                  child: Row(
                    children: [
                      _buildInfoItem(Icons.landscape, '${farm.hectares} ha'),
                      const SizedBox(width: 16),
                      _buildInfoItem(Icons.view_module, '${farm.lots} lotes'),
                      const SizedBox(width: 16),
                      _buildInfoItem(Icons.trending_up, '${farm.productivity} kg/ha'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Barra de productividad (clickeable)
                GestureDetector(
                  onTap: () => context.go(RouteNames.farmDetail, extra: farm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Productividad',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.darkCoffee.withOpacity(0.5),
                            ),
                          ),
                          Text(
                            '${(farm.productivityPercentage * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: farm.statusColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: farm.productivityPercentage,
                          backgroundColor: Colors.grey.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(farm.statusColor),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Acciones
                Row(
                  children: [
                    _buildActionButton(
                      Icons.visibility,
                      'Ver detalle',
                          () => context.go(RouteNames.farmDetail, extra: farm),
                    ),
                    if (onEdit != null)
                      _buildActionButton(Icons.edit, 'Editar', onEdit!),
                    if (onIndicators != null)
                      _buildActionButton(Icons.analytics, 'Indicadores', onIndicators!),
                    if (onTraceability != null)
                      _buildActionButton(Icons.qr_code, 'Trazabilidad', onTraceability!),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppTheme.primaryGreen),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppTheme.darkCoffee,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onPressed) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppTheme.primaryGreen),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: AppTheme.primaryGreen.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}