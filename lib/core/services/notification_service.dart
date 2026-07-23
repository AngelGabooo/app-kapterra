// lib/core/services/notification_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/appointment_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  /// Inicializar el servicio de notificaciones
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // Inicializar timezone
      tz.initializeTimeZones();

      // Configuración para Android
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

      // Configuración para iOS
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        settings,
        onDidReceiveNotificationResponse: _onNotificationTap,
      );

      // Crear canal de notificaciones en Android
      await _createNotificationChannel();

      _isInitialized = true;
      debugPrint('✅ Servicio de notificaciones inicializado correctamente');
    } catch (e) {
      debugPrint('❌ Error al inicializar notificaciones: $e');
    }
  }

  /// Crear canal de notificaciones (Android 8+)
  Future<void> _createNotificationChannel() async {
    const androidPlatformChannelSpecifics = AndroidNotificationChannel(
      'appointment_channel',
      'Citas de Kaab Terra',
      description: 'Notificaciones de citas agendadas',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    await _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(
      androidPlatformChannelSpecifics,
    );
  }

  /// Manejar el tap en una notificación
  void _onNotificationTap(NotificationResponse response) {
    debugPrint('🔔 Notificación tocada: ${response.payload}');
    // TODO: Navegar a la pantalla de detalles de la cita
  }

  /// Enviar notificación de nueva cita al productor
  Future<void> sendAppointmentNotification(AppointmentModel appointment) async {
    if (!_isInitialized) {
      await init();
    }

    try {
      const androidDetails = AndroidNotificationDetails(
        'appointment_channel',
        'Citas de Kaab Terra',
        channelDescription: 'Notificaciones de citas agendadas',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch % 100000,
        '📅 Nueva cita agendada',
        '${appointment.clientName} ha solicitado una cita para: ${appointment.reason}',
        details,
        payload: appointment.id,
      );

      debugPrint('✅ Notificación de cita enviada');
    } catch (e) {
      debugPrint('❌ Error enviando notificación: $e');
    }
  }

  /// Enviar notificación de confirmación al cliente
  Future<void> sendAppointmentConfirmation(AppointmentModel appointment) async {
    if (!_isInitialized) {
      await init();
    }

    try {
      const androidDetails = AndroidNotificationDetails(
        'appointment_channel',
        'Citas de Kaab Terra',
        channelDescription: 'Notificaciones de citas agendadas',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch % 100000 + 1,
        '✅ Cita confirmada',
        'Tu cita con ${appointment.producerName} ha sido confirmada para ${_formatDate(appointment.date)}',
        details,
        payload: appointment.id,
      );

      debugPrint('✅ Notificación de confirmación enviada');
    } catch (e) {
      debugPrint('❌ Error enviando confirmación: $e');
    }
  }

  /// Programar recordatorio
  Future<void> sendReminderNotification(AppointmentModel appointment) async {
    if (!_isInitialized) {
      await init();
    }

    try {
      final scheduledTime = appointment.date.subtract(const Duration(hours: 1));

      if (scheduledTime.isAfter(DateTime.now())) {
        const androidDetails = AndroidNotificationDetails(
          'reminder_channel',
          'Recordatorios',
          channelDescription: 'Recordatorios de citas',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        );

        const iosDetails = DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

        const details = NotificationDetails(
          android: androidDetails,
          iOS: iosDetails,
        );

        final tzLocation = tz.getLocation('America/Mexico_City');
        final scheduledTz = tz.TZDateTime.from(scheduledTime, tzLocation);

        await _notifications.zonedSchedule(
          appointment.id.hashCode,
          '⏰ Recordatorio de cita',
          'Tienes una cita con ${appointment.producerName} en 1 hora.',
          scheduledTz,
          details,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          payload: appointment.id,
        );

        debugPrint('✅ Recordatorio programado para: $scheduledTime');
      }
    } catch (e) {
      debugPrint('❌ Error programando recordatorio: $e');
    }
  }

  /// Cancelar todas las notificaciones
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
    debugPrint('🔕 Todas las notificaciones canceladas');
  }

  /// Formatear fecha
  String _formatDate(DateTime date) {
    final months = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
    final days = ['domingo', 'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado'];
    return '${days[date.weekday]} ${date.day} de ${months[date.month - 1]} a las ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}