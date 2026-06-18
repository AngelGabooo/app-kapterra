// lib/features/activities/domain/entities/activity_entity.dart
import 'package:equatable/equatable.dart';

enum ActivityTypeEntity {
  fertilization,
  pruning,
  pestControl,
  weedControl,
  irrigation,
  harvest,
  inspection,
  other,
}

enum ActivityStatusEntity {
  completed,
  pending,
  inProgress,
  cancelled,
}

extension ActivityTypeEntityExtension on ActivityTypeEntity {
  String get title {
    switch (this) {
      case ActivityTypeEntity.fertilization:
        return 'Fertilización';
      case ActivityTypeEntity.pruning:
        return 'Poda';
      case ActivityTypeEntity.pestControl:
        return 'Control de plagas';
      case ActivityTypeEntity.weedControl:
        return 'Control de malezas';
      case ActivityTypeEntity.irrigation:
        return 'Riego';
      case ActivityTypeEntity.harvest:
        return 'Cosecha';
      case ActivityTypeEntity.inspection:
        return 'Inspección técnica';
      case ActivityTypeEntity.other:
        return 'Otra actividad';
    }
  }

  String get iconName {
    switch (this) {
      case ActivityTypeEntity.fertilization:
        return 'spa';
      case ActivityTypeEntity.pruning:
        return 'content_cut';
      case ActivityTypeEntity.pestControl:
        return 'bug_report';
      case ActivityTypeEntity.weedControl:
        return 'grass';
      case ActivityTypeEntity.irrigation:
        return 'water_drop';
      case ActivityTypeEntity.harvest:
        return 'agriculture';
      case ActivityTypeEntity.inspection:
        return 'science';
      case ActivityTypeEntity.other:
        return 'note_add';
    }
  }
}

extension ActivityStatusEntityExtension on ActivityStatusEntity {
  String get displayName {
    switch (this) {
      case ActivityStatusEntity.completed:
        return 'Completada';
      case ActivityStatusEntity.pending:
        return 'Pendiente';
      case ActivityStatusEntity.inProgress:
        return 'En progreso';
      case ActivityStatusEntity.cancelled:
        return 'Cancelada';
    }
  }
}

class ActivityEntity extends Equatable {
  final String id;
  final String lotId;
  final String lotName;
  final String farmId;
  final String farmName;
  final ActivityTypeEntity type;
  final ActivityStatusEntity status;
  final DateTime date;
  final DateTime? scheduledDate;
  final String responsible;
  final String description;
  final double quantity;
  final String quantityUnit;
  final double cost;
  final List<String> evidenceUrls;
  final String observations;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ActivityEntity({
    required this.id,
    required this.lotId,
    required this.lotName,
    required this.farmId,
    required this.farmName,
    required this.type,
    required this.status,
    required this.date,
    this.scheduledDate,
    required this.responsible,
    required this.description,
    required this.quantity,
    required this.quantityUnit,
    required this.cost,
    required this.evidenceUrls,
    required this.observations,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  // Método para crear una copia con cambios
  ActivityEntity copyWith({
    String? id,
    String? lotId,
    String? lotName,
    String? farmId,
    String? farmName,
    ActivityTypeEntity? type,
    ActivityStatusEntity? status,
    DateTime? date,
    DateTime? scheduledDate,
    String? responsible,
    String? description,
    double? quantity,
    String? quantityUnit,
    double? cost,
    List<String>? evidenceUrls,
    String? observations,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ActivityEntity(
      id: id ?? this.id,
      lotId: lotId ?? this.lotId,
      lotName: lotName ?? this.lotName,
      farmId: farmId ?? this.farmId,
      farmName: farmName ?? this.farmName,
      type: type ?? this.type,
      status: status ?? this.status,
      date: date ?? this.date,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      responsible: responsible ?? this.responsible,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      quantityUnit: quantityUnit ?? this.quantityUnit,
      cost: cost ?? this.cost,
      evidenceUrls: evidenceUrls ?? this.evidenceUrls,
      observations: observations ?? this.observations,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id, lotId, lotName, farmId, farmName, type, status, date,
    scheduledDate, responsible, description, quantity, quantityUnit,
    cost, evidenceUrls, observations, metadata, createdAt, updatedAt,
  ];
}