import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/features/buyer/data/models/acopio_model.dart';

class AcopioCard extends StatelessWidget {
  final AcopioModel acopio;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback? onEdit;

  const AcopioCard({
    super.key,
    required this.acopio,
    required this.isDark,
    required this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark ? AppTheme.coffeeDeep : Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Productor y fecha
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.primaryGreen, AppTheme.secondaryGreen],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          acopio.producerName.split(' ').map((e) => e[0]).take(2).join().toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            acopio.producerName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '☕ ${acopio.lotName} • ${DateFormat('dd MMM yyyy').format(acopio.date)}',
                            style: TextStyle(
                              fontSize: 11,
                              color: textColor.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: acopio.status.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            acopio.status.icon,
                            size: 10,
                            color: acopio.status.color,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            acopio.status.label,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: acopio.status.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Información rápida
                Row(
                  children: [
                    _buildInfoItem('⚖️', '${acopio.netWeight.toStringAsFixed(0)} kg', textColor),
                    const SizedBox(width: 16),
                    _buildInfoItem('💧', '${acopio.humidity.toStringAsFixed(1)}%', textColor),
                    const SizedBox(width: 16),
                    _buildInfoItem('⭐', acopio.classification, textColor),
                  ],
                ),
                const SizedBox(height: 12),
                // Ubicación
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 12,
                      color: textColor.withOpacity(0.3),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${acopio.warehouse} • ${acopio.shelf}',
                      style: TextStyle(
                        fontSize: 10,
                        color: textColor.withOpacity(0.4),
                      ),
                    ),
                    const Spacer(),
                    if (acopio.status == AcopioStatus.pending || acopio.status == AcopioStatus.inReview)
                      TextButton(
                        onPressed: onEdit,
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.primaryGreen,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Clasificar',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                    TextButton(
                      onPressed: onTap,
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.goldCoffee,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Ver detalle',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String emoji, String value, Color textColor) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ],
    );
  }
}