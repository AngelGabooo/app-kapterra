// lib/features/activities/domain/usecases/get_activities_usecase.dart
import 'package:kaabcafe/features/activities/data/repositories/activity_repository.dart';
import 'package:kaabcafe/features/activities/domain/entities/activity_entity.dart';

class GetActivitiesUseCase {
  final ActivityRepository repository;

  const GetActivitiesUseCase(this.repository);

  /// Ejecutar el caso de uso
  Future<List<ActivityEntity>> execute({
    String? lotId,
    String? farmId,
    ActivityTypeEntity? type,
    ActivityStatusEntity? status,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return repository.getActivities(
      lotId: lotId,
      farmId: farmId,
      type: type,
      status: status,
      startDate: startDate,
      endDate: endDate,
    );
  }
}

class GetActivityByIdUseCase {
  final ActivityRepository repository;

  const GetActivityByIdUseCase(this.repository);

  Future<ActivityEntity?> execute(String id) {
    return repository.getActivityById(id);
  }
}

class GetActivitiesByLotUseCase {
  final ActivityRepository repository;

  const GetActivitiesByLotUseCase(this.repository);

  Future<List<ActivityEntity>> execute(String lotId) {
    return repository.getActivitiesByLotId(lotId);
  }
}

class GetActivitiesByFarmUseCase {
  final ActivityRepository repository;

  const GetActivitiesByFarmUseCase(this.repository);

  Future<List<ActivityEntity>> execute(String farmId) {
    return repository.getActivitiesByFarmId(farmId);
  }
}

class GetActivitiesByTypeUseCase {
  final ActivityRepository repository;

  const GetActivitiesByTypeUseCase(this.repository);

  Future<List<ActivityEntity>> execute(ActivityTypeEntity type) {
    return repository.getActivitiesByType(type);
  }
}

class GetActivitiesByStatusUseCase {
  final ActivityRepository repository;

  const GetActivitiesByStatusUseCase(this.repository);

  Future<List<ActivityEntity>> execute(ActivityStatusEntity status) {
    return repository.getActivitiesByStatus(status);
  }
}

class GetActivitiesByDateRangeUseCase {
  final ActivityRepository repository;

  const GetActivitiesByDateRangeUseCase(this.repository);

  Future<List<ActivityEntity>> execute(DateTime startDate, DateTime endDate) {
    return repository.getActivitiesByDateRange(startDate, endDate);
  }
}

class CreateActivityUseCase {
  final ActivityRepository repository;

  const CreateActivityUseCase(this.repository);

  Future<ActivityEntity> execute(ActivityEntity activity) {
    return repository.createActivity(activity);
  }
}

class UpdateActivityUseCase {
  final ActivityRepository repository;

  const UpdateActivityUseCase(this.repository);

  Future<ActivityEntity> execute(ActivityEntity activity) {
    return repository.updateActivity(activity);
  }
}

class DeleteActivityUseCase {
  final ActivityRepository repository;

  const DeleteActivityUseCase(this.repository);

  Future<void> execute(String id) {
    return repository.deleteActivity(id);
  }
}

class GetActivitySummaryUseCase {
  final ActivityRepository repository;

  const GetActivitySummaryUseCase(this.repository);

  Future<ActivitySummaryEntity> execute({
    String? farmId,
    String? lotId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return repository.getActivitySummary(
      farmId: farmId,
      lotId: lotId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}