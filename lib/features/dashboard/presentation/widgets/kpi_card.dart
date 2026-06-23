import 'package:flutter/material.dart';
import 'package:kaabcafe/features/dashboard/data/models/kpi_model.dart';

class KPICard extends StatelessWidget {
  final KPIModel kpi;
  final double? height;
  final bool useNeonAccent;

  const KPICard({
    super.key,
    required this.kpi,
    this.height,
    this.useNeonAccent = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: height,
      width: double.infinity,
      // 🚀 Reducimos el padding vertical a 8 para liberar espacio interno crítico
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: useNeonAccent
            ? const Color(0xFFFF6B00).withOpacity(isDark ? 0.08 : 0.05)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: useNeonAccent
              ? const Color(0xFFFF6B00).withOpacity(0.3)
              : theme.colorScheme.onSurface.withOpacity(isDark ? 0.05 : 0.07),
          width: useNeonAccent ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center, // Mantiene centrado el contenido verticalmente
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                kpi.icon,
                size: 16, // Ligeramente más compacto para mayor control de espacio
                color: useNeonAccent ? const Color(0xFFFF6B00) : theme.colorScheme.primary,
              ),
              if (kpi.change != 0)
                Flexible(
                  child: Text(
                    '${kpi.change > 0 ? '↑' : '↓'}${kpi.change.abs().toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: kpi.change > 0 ? Colors.green : Colors.red,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),

          if (height != null && height! > 100) ...[
            const Spacer(),
          ] else ...[
            const SizedBox(height: 4),
          ],

          // 🚀 Envolvemos el bloque de textos en Flexible para blindar el layout ante overflows de fuentes
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  kpi.title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurface.withOpacity(useNeonAccent ? 0.6 : 0.4),
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  kpi.value,
                  style: TextStyle(
                    fontSize: height != null && height! > 100 ? 24 : 16,
                    fontWeight: FontWeight.w900,
                    color: useNeonAccent ? const Color(0xFFFF6B00) : theme.colorScheme.onSurface,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}