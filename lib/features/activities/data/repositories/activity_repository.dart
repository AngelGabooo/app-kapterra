// lib/features/activities/data/repositories/activity_repository.dart
import 'package:kaabcafe/features/activities/domain/entities/activity_entity.dart';

abstract class ActivityRepository {
  /// Obtener todas las actividades
  Future<List<ActivityEntity>> getActivities({
    String? lotId,
    String? farmId,
    ActivityTypeEntity? type,
    ActivityStatusEntity? status,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Obtener una actividad por ID
  Future<ActivityEntity?> getActivityById(String id);

  /// Obtener actividades por lote
  Future<List<ActivityEntity>> getActivitiesByLotId(String lotId);

  /// Obtener actividades por finca
  Future<List<ActivityEntity>> getActivitiesByFarmId(String farmId);

  /// Obtener actividades por tipo
  Future<List<ActivityEntity>> getActivitiesByType(ActivityTypeEntity type);

  /// Obtener actividades por estado
  Future<List<ActivityEntity>> getActivitiesByStatus(ActivityStatusEntity status);

  /// Obtener actividades por rango de fechas
  Future<List<ActivityEntity>> getActivitiesByDateRange(
      DateTime startDate,
      DateTime endDate,
      );

  /// Crear una nueva actividad
  Future<ActivityEntity> createActivity(ActivityEntity activity);

  /// Actualizar una actividad existente
  Future<ActivityEntity> updateActivity(ActivityEntity activity);

  /// Eliminar una actividad
  Future<void> deleteActivity(String id);

  /// Obtener resumen de KPIs
  Future<ActivitySummaryEntity> getActivitySummary({
    String? farmId,
    String? lotId,
    DateTime? startDate,
    DateTime? endDate,
  });
}

// Modelo para el resumen de actividades
class ActivitySummaryEntity {
  final int totalActivities;
  final int completedActivities;
  final int pendingActivities;
  final int inProgressActivities;
  final int cancelledActivities;
  final double totalCost;
  final Map<ActivityTypeEntity, int> activitiesByType;
  final Map<String, int> activitiesByLot;

  const ActivitySummaryEntity({
    required this.totalActivities,
    required this.completedActivities,
    required this.pendingActivities,
    required this.inProgressActivities,
    required this.cancelledActivities,
    required this.totalCost,
    required this.activitiesByType,
    required this.activitiesByLot,
  });
}