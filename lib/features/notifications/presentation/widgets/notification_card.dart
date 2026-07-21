// lib/features/notifications/presentation/widgets/notification_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import '../data/models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onMarkAsRead;
  final bool isDark;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onMarkAsRead,
    this.isDark = false,
  });

  String _getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(notification.date);

    if (difference.inMinutes < 1) {
      return 'Ahora mismo';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} h';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} d';
    } else {
      return DateFormat('dd MMM').format(notification.date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;
    final cardColor = isDark
        ? AppTheme.coffeeDeep.withOpacity(0.7)
        : Colors.white.withOpacity(0.9);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: notification.priority.color.withOpacity(0.3),
                width: notification.isRead ? 1 : 2,
              ),
              boxShadow: isDark ? const [] : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icono
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: notification.priority.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    notification.icon,
                    size: 24,
                    color: notification.priority.color,
                  ),
                ),
                const SizedBox(width: 12),
                // Contenido
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: notification.isRead
                                    ? FontWeight.w500
                                    : FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: notification.priority.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: notification.priority.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              notification.priority.label,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: notification.priority.color,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _getTimeAgo(),
                            style: TextStyle(
                              fontSize: 11,
                              color: textColor.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Botón marcar como leída
                if (!notification.isRead)
                  IconButton(
                    onPressed: onMarkAsRead,
                    icon: Icon(Icons.done_all, size: 18, color: AppTheme.primaryGreen),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}