import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';
import '../../../../core/widgets/neumorphic_widgets.dart';

const Color _kCreamLight = Color(0xFFFBF3E6);
const Color _kCreamLightAlt = Color(0xFFF6ECDA);

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

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: NeumorphicBox(
        borderRadius: 28,
        intensity: 6,
        color: isDark ? null : _kCreamLight,
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen con esquinas redondeadas arriba
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
                  // Nombre y etiqueta de estado
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
                          color: farm.statusColor.withOpacity(isDark ? 0.18 : 0.12),
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
                  // Ubicación geográfica
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
                  // Chips técnicos en versión neumórfica hundida
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTechnicalChip(Icons.filter_hdr_rounded, '${farm.hectares} ha', theme, isDark),
                      _buildTechnicalChip(Icons.grid_view_rounded, '${farm.lots} lotes', theme, isDark),
                      _buildTechnicalChip(Icons.speed_rounded, '${farm.productivity} kg/ha', theme, isDark),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Barra de rendimiento tipo groove con degradado
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
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            '${(farm.productivityPercentage * 100).toInt()}%',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: farm.statusColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      NeumorphicBox.inset(
                        borderRadius: 8,
                        intensity: 3,
                        color: isDark ? null : _kCreamLightAlt,
                        child: SizedBox(
                          height: 8,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Stack(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: constraints.maxWidth * farm.productivityPercentage.clamp(0.0, 1.0),
                                    height: 8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: farm.statusColor,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Dock de acciones rápidas — cada botón es un chip neumórfico presionable
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(Icons.fullscreen_rounded, 'Detalle', () => context.push(RouteNames.farmDetail, extra: farm), theme, isDark),
                      if (onEdit != null) _buildActionButton(Icons.edit_note_rounded, 'Editar', onEdit!, theme, isDark),
                      if (onIndicators != null) _buildActionButton(Icons.bar_chart_rounded, 'Métricas', onIndicators!, theme, isDark),
                      if (onTraceability != null) _buildActionButton(Icons.center_focus_weak_rounded, 'Historial', onTraceability!, theme, isDark),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnicalChip(IconData icon, String text, ThemeData theme, bool isDark) {
    return NeumorphicBox.inset(
      borderRadius: 12,
      intensity: 2,
      color: isDark ? null : _kCreamLightAlt,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onPressed, ThemeData theme, bool isDark) {
    return GestureDetector(
      onTap: onPressed,
      child: NeumorphicBox(
        borderRadius: 14,
        intensity: 2,
        color: isDark ? null : _kCreamLightAlt,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary.withOpacity(0.85)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface.withOpacity(0.6))),
          ],
        ),
      ),
    );
  }
}