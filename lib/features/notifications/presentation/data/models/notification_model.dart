import 'package:flutter/material.dart';

enum NotificationPriority {
  critical,
  high,
  medium,
  low,
  positive,
}

enum NotificationCategory {
  all,
  critical,
  aiRecommendation,
  production,
  costs,
  traceability,
  system,
}

extension NotificationPriorityExtension on NotificationPriority {
  Color get color {
    switch (this) {
      case NotificationPriority.critical:
        return const Color(0xFFD32F2F);
      case NotificationPriority.high:
        return const Color(0xFFF57C00);
      case NotificationPriority.medium:
        return const Color(0xFFD4A017);
      case NotificationPriority.low:
        return const Color(0xFF1976D2);
      case NotificationPriority.positive:
        return const Color(0xFF2E7D32);
    }
  }

  String get label {
    switch (this) {
      case NotificationPriority.critical:
        return 'Crítica';
      case NotificationPriority.high:
        return 'Alta';
      case NotificationPriority.medium:
        return 'Media';
      case NotificationPriority.low:
        return 'Baja';
      case NotificationPriority.positive:
        return 'Positiva';
    }
  }
}

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final NotificationPriority priority;
  final NotificationCategory category;
  final IconData icon;
  final bool isRead;
  final String? actionLabel;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.priority,
    required this.category,
    required this.icon,
    this.isRead = false,
    this.actionLabel,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    NotificationPriority? priority,
    NotificationCategory? category,
    IconData? icon,
    bool? isRead,
    String? actionLabel,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      isRead: isRead ?? this.isRead,
      actionLabel: actionLabel ?? this.actionLabel,
    );
  }
}