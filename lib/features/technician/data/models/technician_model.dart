import 'package:flutter/material.dart';

enum ProducerStatus {
  excellent,
  requiresAttention,
  risk,
}

extension ProducerStatusExtension on ProducerStatus {
  String get label {
    switch (this) {
      case ProducerStatus.excellent:
        return 'Excelente';
      case ProducerStatus.requiresAttention:
        return 'Requiere seguimiento';
      case ProducerStatus.risk:
        return 'Riesgo';
    }
  }

  Color get color {
    switch (this) {
      case ProducerStatus.excellent:
        return const Color(0xFF2E7D32);
      case ProducerStatus.requiresAttention:
        return const Color(0xFFF57C00);
      case ProducerStatus.risk:
        return const Color(0xFFD32F2F);
    }
  }
}

class TechnicianProducerModel {
  final String id;
  final String name;
  final String location;
  final double production;
  final double traceability;
  final ProducerStatus status;
  final String lastVisit;

  TechnicianProducerModel({
    required this.id,
    required this.name,
    required this.location,
    required this.production,
    required this.traceability,
    required this.status,
    required this.lastVisit,
  });
}

class TechnicianVisitModel {
  final String id;
  final String producerName;
  final String location;
  final String time;
  final String objective;
  final bool isUrgent;

  TechnicianVisitModel({
    required this.id,
    required this.producerName,
    required this.location,
    required this.time,
    required this.objective,
    this.isUrgent = false,
  });
}

class TechnicianAlertModel {
  final String id;
  final String title;
  final String description;
  final bool isCritical;
  final DateTime date;

  TechnicianAlertModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCritical,
    required this.date,
  });
}