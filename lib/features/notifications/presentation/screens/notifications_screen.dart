import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabcafe/core/routes/route_names.dart';
import 'package:kaabcafe/core/themes/app_theme.dart';
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
  List<NotificationModel> _notifications = [];
  List<NotificationModel> _filteredNotifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    _notifications = [
      NotificationModel(
        id: '1',
        title: 'Posible riesgo de roya detectado',
        description: 'Se detectó un patrón inusual de humedad en Lote Norte. Revisa inmediatamente.',
        date: DateTime.now().subtract(const Duration(minutes: 10)),
        priority: NotificationPriority.critical,
        category: NotificationCategory.critical,
        icon: Icons.warning,
        isRead: false,
        actionLabel: 'Ver detalle',
      ),
      NotificationModel(
        id: '2',
        title: 'Recomendación de fertilización',
        description: 'La IA recomienda fertilizar el Lote Sur durante esta semana para optimizar producción.',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        priority: NotificationPriority.high,
        category: NotificationCategory.aiRecommendation,
        icon: Icons.psychology,
        isRead: false,
        actionLabel: 'Ver recomendación',
      ),
      NotificationModel(
        id: '3',
        title: 'Incremento en costos de producción',
        description: 'Los costos aumentaron un 8% respecto al mes anterior. Revisa el desglose.',
        date: DateTime.now().subtract(const Duration(days: 1)),
        priority: NotificationPriority.low,
        category: NotificationCategory.costs,
        icon: Icons.attach_money,
        isRead: true,
        actionLabel: 'Ver análisis',
      ),
      NotificationModel(
        id: '4',
        title: 'Producción por encima del promedio',
        description: 'Tu rendimiento actual supera el promedio regional en un 15%. ¡Sigue así!',
        date: DateTime.now().subtract(const Duration(days: 2)),
        priority: NotificationPriority.positive,
        category: NotificationCategory.production,
        icon: Icons.trending_up,
        isRead: true,
        actionLabel: 'Ver indicadores',
      ),
      NotificationModel(
        id: '5',
        title: 'Actualización de trazabilidad',
        description: 'Se ha generado un nuevo pasaporte digital para Lote Centro.',
        date: DateTime.now().subtract(const Duration(days: 3)),
        priority: NotificationPriority.medium,
        category: NotificationCategory.traceability,
        icon: Icons.qr_code,
        isRead: false,
        actionLabel: 'Ver pasaporte',
      ),
      NotificationModel(
        id: '6',
        title: 'Mantenimiento programado',
        description: 'La plataforma estará en mantenimiento el domingo de 2:00 AM a 4:00 AM.',
        date: DateTime.now().subtract(const Duration(days: 5)),
        priority: NotificationPriority.low,
        category: NotificationCategory.system,
        icon: Icons.build,
        isRead: true,
        actionLabel: 'Ver detalles',
      ),
    ];
    _applyFilter();
  }

  void _applyFilter() {
    setState(() {
      if (_selectedCategory == NotificationCategory.all) {
        _filteredNotifications = _notifications;
      } else {
        _filteredNotifications = _notifications
            .where((n) => n.category == _selectedCategory)
            .toList();
      }
    });
  }

  void _markAllAsRead() {
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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightBeige,
              AppTheme.primaryGreen.withOpacity(0.03),
              AppTheme.lightBeige,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Barra superior
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back),
                      color: AppTheme.darkCoffee,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Notificaciones',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkCoffee,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Mantente informado sobre tu producción.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.darkCoffee.withOpacity(0.6),
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

              // KPIs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    NotificationKpiCard(
                      title: 'Críticas',
                      value: '$_criticalCount',
                      icon: Icons.warning,
                      color: const Color(0xFFD32F2F),
                    ),
                    const SizedBox(width: 12),
                    NotificationKpiCard(
                      title: 'Pendientes',
                      value: '$_pendingCount',
                      icon: Icons.pending_actions,
                      color: const Color(0xFFF57C00),
                    ),
                    const SizedBox(width: 12),
                    NotificationKpiCard(
                      title: 'Informativas',
                      value: '$_infoCount',
                      icon: Icons.info,
                      color: const Color(0xFF1976D2),
                    ),
                    const SizedBox(width: 12),
                    NotificationKpiCard(
                      title: 'Resueltas',
                      value: '$_resolvedCount',
                      icon: Icons.check_circle,
                      color: AppTheme.primaryGreen,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Filtros
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    NotificationFilterChip(
                      category: NotificationCategory.all,
                      isSelected: _selectedCategory == NotificationCategory.all,
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

              // Lista de notificaciones
              Expanded(
                child: _filteredNotifications.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications_off,
                          size: 50,
                          color: AppTheme.primaryGreen.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'No tienes notificaciones',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkCoffee,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Todo marcha correctamente en tus fincas.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.darkCoffee.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Hoy
                    if (_todayNotifications.isNotEmpty) ...[
                      const Text(
                        'Hoy',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkCoffee,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._todayNotifications.map((n) => NotificationCard(
                        notification: n,
                        onTap: () => _onNotificationTap(n),
                        onMarkAsRead: () => _markAsRead(n.id),
                      )),
                      const SizedBox(height: 16),
                    ],
                    // Ayer
                    if (_yesterdayNotifications.isNotEmpty) ...[
                      const Text(
                        'Ayer',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkCoffee,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._yesterdayNotifications.map((n) => NotificationCard(
                        notification: n,
                        onTap: () => _onNotificationTap(n),
                        onMarkAsRead: () => _markAsRead(n.id),
                      )),
                      const SizedBox(height: 16),
                    ],
                    // Esta semana
                    if (_thisWeekNotifications.isNotEmpty) ...[
                      const Text(
                        'Esta semana',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkCoffee,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._thisWeekNotifications.map((n) => NotificationCard(
                        notification: n,
                        onTap: () => _onNotificationTap(n),
                        onMarkAsRead: () => _markAsRead(n.id),
                      )),
                      const SizedBox(height: 16),
                    ],
                    // Anteriores
                    if (_earlierNotifications.isNotEmpty) ...[
                      const Text(
                        'Anteriores',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkCoffee,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._earlierNotifications.map((n) => NotificationCard(
                        notification: n,
                        onTap: () => _onNotificationTap(n),
                        onMarkAsRead: () => _markAsRead(n.id),
                      )),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}