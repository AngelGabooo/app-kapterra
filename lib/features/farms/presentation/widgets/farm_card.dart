import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.12 : 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen con efecto Glass en los bordes
          GestureDetector(
            onTap: () => context.push(RouteNames.farmDetail, extra: farm),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              child: Image.asset(
                farm.imageUrl,
                height: 130,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 130,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.2),
                          theme.colorScheme.secondary.withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: Center(child: Icon(Icons.landscape_rounded, size: 40, color: theme.colorScheme.primary)),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre y Etiqueta Orbital de Estado
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        farm.name,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface, letterSpacing: -0.4),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: farm.statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(radius: 3, backgroundColor: farm.statusColor),
                          const SizedBox(width: 6),
                          Text(
                            farm.statusText,
                            style: TextStyle(fontSize: 10, color: farm.statusColor, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Ubicación Geográfica
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, size: 14, color: Color(0xFFFF6B00)),
                    const SizedBox(width: 4),
                    Text(
                      farm.location,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withOpacity(0.45)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Chips Técnicos de Información Horizontal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTechnicalChip(Icons.filter_hdr_rounded, '${farm.hectares} ha', theme),
                    _buildTechnicalChip(Icons.grid_view_rounded, '${farm.lots} lotes', theme),
                    _buildTechnicalChip(Icons.speed_rounded, '${farm.productivity} kg/ha', theme),
                  ],
                ),
                const SizedBox(height: 20),
                // Barra Analítica Óptica de Rendimiento
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            'RENDIMIENTO TOTAL DE COSECHA',
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                color: theme.colorScheme.onSurface.withOpacity(0.3),
                                letterSpacing: 0.5
                            )
                        ),
                        Text('${(farm.productivityPercentage * 100).toInt()}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: farm.statusColor)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: farm.productivityPercentage,
                        backgroundColor: theme.colorScheme.onSurface.withOpacity(0.06),
                        valueColor: AlwaysStoppedAnimation<Color>(farm.statusColor),
                        minHeight: 5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Dock de Acciones Rápidas del Ítem
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.04))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(Icons.fullscreen_rounded, 'Detalle', () => context.push(RouteNames.farmDetail, extra: farm), theme),
                      if (onEdit != null) _buildActionButton(Icons.edit_note_rounded, 'Editar', onEdit!, theme),
                      if (onIndicators != null) _buildActionButton(Icons.bar_chart_rounded, 'Métricas', onIndicators!, theme),
                      if (onTraceability != null) _buildActionButton(Icons.center_focus_weak_rounded, 'Historial', onTraceability!, theme),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicalChip(IconData icon, String text, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onPressed, ThemeData theme) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: theme.colorScheme.primary.withOpacity(0.8)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface.withOpacity(0.6))),
          ],
        ),
      ),
    );
  }
}