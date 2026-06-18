// lib/features/activities/data/models/activity_model.dart
import 'package:flutter/material.dart';

enum ActivityType {
  fertilization,
  pruning,
  pestControl,
  weedControl,
  irrigation,
  harvest,
  inspection,
  other,
}

enum ActivityStatus {
  completed,
  pending,
  inProgress,
  cancelled,
}

extension ActivityTypeExtension on ActivityType {
  String get title {
    switch (this) {
      case ActivityType.fertilization:
        return 'Fertilización';
      case ActivityType.pruning:
        return 'Poda';
      case ActivityType.pestControl:
        return 'Control de plagas';
      case ActivityType.weedControl:
        return 'Control de malezas';
      case ActivityType.irrigation:
        return 'Riego';
      case ActivityType.harvest:
        return 'Cosecha';
      case ActivityType.inspection:
        return 'Inspección técnica';
      case ActivityType.other:
        return 'Otra actividad';
    }
  }

  IconData get icon {
    switch (this) {
      case ActivityType.fertilization:
        return Icons.spa;
      case ActivityType.pruning:
        return Icons.content_cut;
      case ActivityType.pestControl:
        return Icons.bug_report;
      case ActivityType.weedControl:
        return Icons.grass;
      case ActivityType.irrigation:
        return Icons.water_drop;
      case ActivityType.harvest:
        return Icons.agriculture;
      case ActivityType.inspection:
        return Icons.science;
      case ActivityType.other:
        return Icons.note_add;
    }
  }

  // ✅ Agregar color para cada tipo
  Color get color {
    switch (this) {
      case ActivityType.fertilization:
        return const Color(0xFF2E7D32);
      case ActivityType.pruning:
        return const Color(0xFFD4A017);
      case ActivityType.pestControl:
        return const Color(0xFFF57C00);
      case ActivityType.weedControl:
        return const Color(0xFF66BB6A);
      case ActivityType.irrigation:
        return const Color(0xFF1976D2);
      case ActivityType.harvest:
        return const Color(0xFF8D6E63);
      case ActivityType.inspection:
        return const Color(0xFF9C27B0);
      case ActivityType.other:
        return const Color(0xFF757575);
    }
  }
}

extension ActivityStatusExtension on ActivityStatus {
  String get displayName {
    switch (this) {
      case ActivityStatus.completed:
        return 'Completada';
      case ActivityStatus.pending:
        return 'Pendiente';
      case ActivityStatus.inProgress:
        return 'En progreso';
      case ActivityStatus.cancelled:
        return 'Cancelada';
    }
  }

  IconData get icon {
    switch (this) {
      case ActivityStatus.completed:
        return Icons.check_circle;
      case ActivityStatus.pending:
        return Icons.pending;
      case ActivityStatus.inProgress:
        return Icons.hourglass_empty;
      case ActivityStatus.cancelled:
        return Icons.cancel;
    }
  }

  Color get color {
    switch (this) {
      case ActivityStatus.completed:
        return const Color(0xFF2E7D32);
      case ActivityStatus.pending:
        return const Color(0xFFF57C00);
      case ActivityStatus.inProgress:
        return const Color(0xFF1976D2);
      case ActivityStatus.cancelled:
        return const Color(0xFFD32F2F);
    }
  }
}

class ActivityModel {
  final String id;
  final ActivityType type;
  final ActivityStatus status;
  final DateTime date;
  final String responsible;
  final String description;
  final double quantity;
  final String quantityUnit;
  final double cost;
  final List<String> evidenceUrls;
  final String observations;

  ActivityModel({
    required this.id,
    required this.type,
    this.status = ActivityStatus.completed,
    required this.date,
    required this.responsible,
    required this.description,
    required this.quantity,
    required this.quantityUnit,
    required this.cost,
    required this.evidenceUrls,
    required this.observations,
  });
}