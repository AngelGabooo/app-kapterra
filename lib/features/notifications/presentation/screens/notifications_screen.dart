// lib/features/notifications/presentation/screens/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
import 'package:kaabcafe/core/widgets/aurora_background.dart';
import 'package:kaabcafe/core/widgets/neumorphic_widgets.dart';
import 'package:kaabcafe/features/notifications/presentation/widgets/notification_kpi_card.dart';
import 'package:kaabcafe/features/notifications/presentation/widgets/notification_filter_chip.dart';
import 'package:kaabcafe/features/notifications/presentation/widgets/notification_card.dart';

import '../data/models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationCategory _selectedCategory = NotificationCategory.all;

  // ✅ LISTAS VACÍAS
  List<NotificationModel> _notifications = [];
  List<NotificationModel> _filteredNotifications = [];

  @override
  void initState() {
    super.initState();
    // ❌ No cargar datos de ejemplo
    // _loadNotifications();
  }

  // ❌ Eliminar método _loadNotifications

  void _applyFilter() {
    setState(() {
      if (_selectedCategory == NotificationCategory.all) {
        _filteredNotifications = List.from(_notifications);
      } else {
        _filteredNotifications = _notifications
            .where((n) => n.category == _selectedCategory)
            .toList();
      }
    });
  }

  void _markAllAsRead() {
    if (_notifications.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay notificaciones para marcar como leídas'),
          backgroundColor: AppTheme.primaryGreen,
        ),
      );
      return;
    }

    setState(() {
      _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
      _applyFilter();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Todas las notificaciones marcadas como leídas'),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }

  void _markAsRead(String id) {
    setState(() {
      _notifications = _notifications.map((n) {
        if (n.id == id) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();
      _applyFilter();
    });
  }

  void _onNotificationTap(NotificationModel notification) {
    debugPrint('Notificación tap: ${notification.title}');
    // TODO: Navegar según el tipo de notificación
  }

  // ✅ Estadísticas siempre en 0 cuando está vacío
  int get _criticalCount => _notifications.where((n) => n.priority == NotificationPriority.critical && !n.isRead).length;
  int get _pendingCount => _notifications.where((n) => !n.isRead).length;
  int get _infoCount => _notifications.where((n) => n.priority == NotificationPriority.low && !n.isRead).length;
  int get _resolvedCount => _notifications.where((n) => n.isRead).length;

  List<NotificationModel> get _todayNotifications =>
      _filteredNotifications.where((n) => n.date.isAfter(DateTime.now().subtract(const Duration(days: 1)))).toList();

  List<NotificationModel> get _yesterdayNotifications =>
      _filteredNotifications.where((n) =>
      n.date.isAfter(DateTime.now().subtract(const Duration(days: 2))) &&
          n.date.isBefore(DateTime.now().subtract(const Duration(days: 1)))
      ).toList();

  List<NotificationModel> get _thisWeekNotifications =>
      _filteredNotifications.where((n) =>
      n.date.isAfter(DateTime.now().subtract(const Duration(days: 7))) &&
          n.date.isBefore(DateTime.now().subtract(const Duration(days: 2)))
      ).toList();

  List<NotificationModel> get _earlierNotifications =>
      _filteredNotifications.where((n) => n.date.isBefore(DateTime.now().subtract(const Duration(days: 7)))).toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.darkCoffee;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AuroraBackground(
        isDark: isDark,
        child: SafeArea(
          child: Column(
            children: [
              // ── Barra superior ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 16, 8),
                child: Row(
                  children: [
                    NeumorphicIconButton(
                      icon: Icons.arrow_back,
                      isDark: isDark,
                      onPressed: () => Navigator.of(context).pop(),
                      size: 44,
                      iconSize: 20,
                      color: textColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notificaciones',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Mantente informado sobre tu producción.',
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _markAllAsRead,
                      icon: Icon(Icons.done_all, color: AppTheme.primaryGreen),
                      tooltip: 'Marcar todas como leídas',
                    ),
                  ],
                ),
              ),

              // ── Contenido con scroll ─────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // ── KPIs ─────────────────────────────────────
                      Row(
                        children: [
                          NotificationKpiCard(
                            title: 'Críticas',
                            value: '$_criticalCount',
                            icon: Icons.warning,
                            color: const Color(0xFFD32F2F),
                            isDark: isDark,
                          ),
                          const SizedBox(width: 12),
                          NotificationKpiCard(
                            title: 'Pendientes',
                            value: '$_pendingCount',
                            icon: Icons.pending_actions,
                            color: const Color(0xFFF57C00),
                            isDark: isDark,
                          ),
                          const SizedBox(width: 12),
                          NotificationKpiCard(
                            title: 'Informativas',
                            value: '$_infoCount',
                            icon: Icons.info,
                            color: const Color(0xFF1976D2),
                            isDark: isDark,
                          ),
                          const SizedBox(width: 12),
                          NotificationKpiCard(
                            title: 'Resueltas',
                            value: '$_resolvedCount',
                            icon: Icons.check_circle,
                            color: AppTheme.primaryGreen,
                            isDark: isDark,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ── Filtros ──────────────────────────────────
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            NotificationFilterChip(
                              category: NotificationCategory.all,
                              isSelected: _selectedCategory == NotificationCategory.all,
                              isDark: isDark,
                              onTap: () {
                                setState(() {
                                  _selectedCategory = NotificationCategory.all;
                                  _applyFilter();
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            NotificationFilterChip(
                              category: NotificationCategory.critical,
                              isSelected: _selectedCategory == NotificationCategory.critical,
                              isDark: isDark,
                              onTap: () {
                                setState(() {
                                  _selectedCategory = NotificationCategory.critical;
                                  _applyFilter();
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            NotificationFilterChip(
                              category: NotificationCategory.aiRecommendation,
                              isSelected: _selectedCategory == NotificationCategory.aiRecommendation,
                              isDark: isDark,
                              onTap: () {
                                setState(() {
                                  _selectedCategory = NotificationCategory.aiRecommendation;
                                  _applyFilter();
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            NotificationFilterChip(
                              category: NotificationCategory.production,
                              isSelected: _selectedCategory == NotificationCategory.production,
                              isDark: isDark,
                              onTap: () {
                                setState(() {
                                  _selectedCategory = NotificationCategory.production;
                                  _applyFilter();
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            NotificationFilterChip(
                              category: NotificationCategory.costs,
                              isSelected: _selectedCategory == NotificationCategory.costs,
                              isDark: isDark,
                              onTap: () {
                                setState(() {
                                  _selectedCategory = NotificationCategory.costs;
                                  _applyFilter();
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            NotificationFilterChip(
                              category: NotificationCategory.traceability,
                              isSelected: _selectedCategory == NotificationCategory.traceability,
                              isDark: isDark,
                              onTap: () {
                                setState(() {
                                  _selectedCategory = NotificationCategory.traceability;
                                  _applyFilter();
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            NotificationFilterChip(
                              category: NotificationCategory.system,
                              isSelected: _selectedCategory == NotificationCategory.system,
                              isDark: isDark,
                              onTap: () {
                                setState(() {
                                  _selectedCategory = NotificationCategory.system;
                                  _applyFilter();
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── Lista de notificaciones ──────────────────
                      if (_filteredNotifications.isEmpty)
                        _buildEmptyState(isDark, textColor)
                      else
                        ..._buildNotificationSections(isDark),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off,
              size: 50,
              color: AppTheme.primaryGreen.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Sin notificaciones',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Todo marcha correctamente en tus fincas.',
            style: TextStyle(
              fontSize: 13,
              color: textColor.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNotificationSections(bool isDark) {
    final List<Widget> sections = [];

    if (_todayNotifications.isNotEmpty) {
      sections.addAll([
        const SizedBox(height: 8),
        Text(
          'Hoy',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppTheme.darkCoffee,
          ),
        ),
        const SizedBox(height: 12),
        ..._todayNotifications.map((n) => NotificationCard(
          notification: n,
          isDark: isDark,
          onTap: () => _onNotificationTap(n),
          onMarkAsRead: () => _markAsRead(n.id),
        )),
        const SizedBox(height: 16),
      ]);
    }

    if (_yesterdayNotifications.isNotEmpty) {
      sections.addAll([
        Text(
          'Ayer',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppTheme.darkCoffee,
          ),
        ),
        const SizedBox(height: 12),
        ..._yesterdayNotifications.map((n) => NotificationCard(
          notification: n,
          isDark: isDark,
          onTap: () => _onNotificationTap(n),
          onMarkAsRead: () => _markAsRead(n.id),
        )),
        const SizedBox(height: 16),
      ]);
    }

    if (_thisWeekNotifications.isNotEmpty) {
      sections.addAll([
        Text(
          'Esta semana',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppTheme.darkCoffee,
          ),
        ),
        const SizedBox(height: 12),
        ..._thisWeekNotifications.map((n) => NotificationCard(
          notification: n,
          isDark: isDark,
          onTap: () => _onNotificationTap(n),
          onMarkAsRead: () => _markAsRead(n.id),
        )),
        const SizedBox(height: 16),
      ]);
    }

    if (_earlierNotifications.isNotEmpty) {
      sections.addAll([
        Text(
          'Anteriores',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppTheme.darkCoffee,
          ),
        ),
        const SizedBox(height: 12),
        ..._earlierNotifications.map((n) => NotificationCard(
          notification: n,
          isDark: isDark,
          onTap: () => _onNotificationTap(n),
          onMarkAsRead: () => _markAsRead(n.id),
        )),
        const SizedBox(height: 16),
      ]);
    }

    // Espacio inferior
    sections.add(const SizedBox(height: 80));

    return sections;
  }
}