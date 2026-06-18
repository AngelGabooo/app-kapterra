import 'package:flutter/material.dart';

enum EventType {
  activity,
  cost,
  production,
  alert,
  aiRecommendation,
  traceability,
  certification,
  milestone,
}

extension EventTypeExtension on EventType {
  String get title {
    switch (this) {
      case EventType.activity:
        return 'Actividad Agrícola';
      case EventType.cost:
        return 'Registro de costo';
      case EventType.production:
        return 'Producción';
      case EventType.alert:
        return 'Alerta';
      case EventType.aiRecommendation:
        return 'Recomendación IA';
      case EventType.traceability:
        return 'Trazabilidad';
      case EventType.certification:
        return 'Certificación';
      case EventType.milestone:
        return 'Hito importante';
    }
  }

  Color get color {
    switch (this) {
      case EventType.activity:
        return const Color(0xFF2E7D32);
      case EventType.cost:
        return const Color(0xFFD4A017);
      case EventType.production:
        return const Color(0xFF2E7D32);
      case EventType.alert:
        return const Color(0xFFD32F2F);
      case EventType.aiRecommendation:
        return const Color(0xFF1976D2);
      case EventType.traceability:
        return const Color(0xFFD4A017);
      case EventType.certification:
        return const Color(0xFF2E7D32);
      case EventType.milestone:
        return const Color(0xFFD4A017);
    }
  }

  IconData get icon {
    switch (this) {
      case EventType.activity:
        return Icons.agriculture;
      case EventType.cost:
        return Icons.attach_money;
      case EventType.production:
        return Icons.eco;
      case EventType.alert:
        return Icons.warning;
      case EventType.aiRecommendation:
        return Icons.psychology;
      case EventType.traceability:
        return Icons.qr_code;
      case EventType.certification:
        return Icons.verified;
      case EventType.milestone:
        return Icons.emoji_events;
    }
  }
}

class HistoryEventModel {
  final String id;
  final EventType type;
  final String title;
  final String description;
  final DateTime date;
  final String responsible;
  final List<String> attachments;
  final Map<String, dynamic>? metadata;
  final double? amount;
  final String? producer;
  final String? confidence;

  HistoryEventModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.date,
    required this.responsible,
    this.attachments = const [],
    this.metadata,
    this.amount,
    this.producer,
    this.confidence,
  });
}