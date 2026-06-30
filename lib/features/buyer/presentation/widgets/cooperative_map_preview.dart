import 'package:flutter/material.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';

class CooperativeMapPreview extends StatelessWidget {
  final bool isDark;
  final bool hasData;

  const CooperativeMapPreview({
    super.key,
    required this.isDark,
    required this.hasData,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Mapa simulado
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    isDark ? AppTheme.coffeeMedium.withOpacity(0.3) : AppTheme.primaryGreen.withOpacity(0.2),
                    isDark ? AppTheme.coffeeWarm.withOpacity(0.2) : AppTheme.secondaryGreen.withOpacity(0.1),
                  ],
                ),
              ),
              child: hasData ? _buildMapWithData() : _buildEmptyMap(isDark, textColor),
            ),
            // Leyenda
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildLegendDot(Colors.green, 'Normal'),
                    const SizedBox(width: 8),
                    _buildLegendDot(Colors.orange, 'Atención'),
                    const SizedBox(width: 8),
                    _buildLegendDot(Colors.red, 'Riesgo'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapWithData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildMarker('🟢', 'Motozintla', 32),
            _buildMarker('🟠', 'Tapachula', 18),
            _buildMarker('🔴', 'Ocosingo', 5),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMarker('🏢', 'Centro de acopio', 3),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyMap(bool isDark, Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.map_outlined,
            size: 40,
            color: textColor.withOpacity(0.2),
          ),
          const SizedBox(height: 8),
          Text(
            'Sin productores registrados',
            style: TextStyle(
              fontSize: 13,
              color: textColor.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'El mapa se actualizará automáticamente',
            style: TextStyle(
              fontSize: 11,
              color: textColor.withOpacity(0.25),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarker(String emoji, String label, int count) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 2),
        Text(
          '$count',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkCoffee,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            color: AppTheme.darkCoffee.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 8,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}