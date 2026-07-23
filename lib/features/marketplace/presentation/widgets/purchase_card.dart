// lib/features/marketplace/presentation/screens/widgets/purchase_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import '../screens/purchases_screen.dart';

class PurchaseCard extends StatelessWidget {
  final PurchaseModel purchase;
  final bool isDark;
  final VoidCallback onTap;

  const PurchaseCard({
    super.key,
    required this.purchase,
    required this.isDark,
    required this.onTap,
  });

  Color get _statusColor {
    switch (purchase.status) {
      case 'En proceso':
        return const Color(0xFFF57C00);
      case 'Entregado':
        return const Color(0xFF2E7D32);
      case 'Cancelado':
        return const Color(0xFFD32F2F);
      default:
        return Colors.grey;
    }
  }

  IconData get _statusIcon {
    switch (purchase.status) {
      case 'En proceso':
        return Icons.pending;
      case 'Entregado':
        return Icons.check_circle;
      case 'Cancelado':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark ? AppTheme.coffeeDeep : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
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
          children: [
            // Header: Lote y estado
            Row(
              children: [
                // Imagen / icono
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryGreen.withOpacity(0.3),
                        AppTheme.secondaryGreen.withOpacity(0.2),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.coffee,
                      size: 24,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        purchase.lotName,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        purchase.producerName,
                        style: TextStyle(
                          fontSize: 12,
                          color: textColor.withOpacity(0.6),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 12,
                            color: textColor.withOpacity(0.4),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            purchase.location,
                            style: TextStyle(
                              fontSize: 11,
                              color: textColor.withOpacity(0.5),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Estado
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _statusIcon,
                        size: 12,
                        color: _statusColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        purchase.status,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Detalles de la compra
            Row(
              children: [
                _buildDetailItem(
                  icon: Icons.attach_money,
                  label: 'Total',
                  value: '\$${purchase.total.toStringAsFixed(2)}',
                  textColor: textColor,
                ),
                const SizedBox(width: 16),
                _buildDetailItem(
                  icon: Icons.inventory,
                  label: 'Cantidad',
                  value: '${purchase.quantity.toStringAsFixed(0)} kg',
                  textColor: textColor,
                ),
                const SizedBox(width: 16),
                _buildDetailItem(
                  icon: Icons.calendar_today,
                  label: 'Fecha',
                  value: DateFormat('dd MMM yyyy').format(purchase.purchaseDate),
                  textColor: textColor,
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Tracking (si existe)
            if (purchase.trackingNumber != null)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (isDark ? AppTheme.coffeeDark : AppTheme.lightBeige).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_shipping,
                      size: 16,
                      color: AppTheme.primaryGreen,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Número de seguimiento: ',
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor.withOpacity(0.5),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        purchase.trackingNumber!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.copy,
                        size: 14,
                        color: AppTheme.primaryGreen,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 12),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                        color: AppTheme.primaryGreen.withOpacity(0.3),
                      ),
                    ),
                    child: const Text('Ver detalles'),
                  ),
                ),
                const SizedBox(width: 8),
                if (purchase.status == 'En proceso')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Rastrear'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required Color textColor,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: textColor.withOpacity(0.4)),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  color: textColor.withOpacity(0.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}