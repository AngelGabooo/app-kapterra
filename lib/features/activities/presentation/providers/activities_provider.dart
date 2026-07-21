// lib/features/activities/presentation/providers/activities_provider.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/features/activities/data/repositories/activity_repository.dart';
import 'package:kaabcafe/features/activities/domain/entities/activity_entity.dart';
import 'package:kaabcafe/features/activities/domain/usecases/get_activities_usecase.dart';

// ✅ Implementación mock del repositorio - COMPLETAMENTE VACÍO
class MockActivityRepository implements ActivityRepository {
  // ✅ Lista vacía
  final List<ActivityEntity> _mockActivities = [];

  MockActivityRepository() {
    // ❌ NO cargar datos de ejemplo
    // ✅ Inicia con lista vacía
    debugPrint('📦 MockActivityRepository inicializado con 0 actividades');
  }

  @override
  Future<List<ActivityEntity>> getActivities({
    String? lotId,
    String? farmId,
    ActivityTypeEntity? type,
    ActivityStatusEntity? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 300));

    var result = List<ActivityEntity>.from(_mockActivities);

    if (lotId != null) {
      result = result.where((a) => a.lotId == lotId).toList();
    }
    if (farmId != null) {
      result = result.where((a) => a.farmId == farmId).toList();
    }
    if (type != null) {
      result = result.where((a) => a.type == type).toList();
    }
    if (status != null) {
      result = result.where((a) => a.status == status).toList();
    }
    if (startDate != null) {
      result = result.where((a) => a.date.isAfter(startDate)).toList();
    }
    if (endDate != null) {
      result = result.where((a) => a.date.isBefore(endDate)).toList();
    }

    debugPrint('📊 getActivities retorna ${result.length} actividades');
    return result;
  }

  @override
  Future<ActivityEntity?> getActivityById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockActivities.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ActivityEntity>> getActivitiesByLotId(String lotId) async {
    return getActivities(lotId: lotId);
  }

  @override
  Future<List<ActivityEntity>> getActivitiesByFarmId(String farmId) async {
    return getActivities(farmId: farmId);
  }

  @override
  Future<List<ActivityEntity>> getActivitiesByType(ActivityTypeEntity type) async {
    return getActivities(type: type);
  }

  @override
  Future<List<ActivityEntity>> getActivitiesByStatus(ActivityStatusEntity status) async {
    return getActivities(status: status);
  }

  @override
  Future<List<ActivityEntity>> getActivitiesByDateRange(
      DateTime startDate,
      DateTime endDate,
      ) async {
    return getActivities(startDate: startDate, endDate: endDate);
  }

  @override
  Future<ActivityEntity> createActivity(ActivityEntity activity) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockActivities.add(activity);
    debugPrint('✅ Actividad creada: ${activity.id} - Total: ${_mockActivities.length}');
    return activity;
  }

  @override
  Future<ActivityEntity> updateActivity(ActivityEntity activity) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockActivities.indexWhere((a) => a.id == activity.id);
    if (index != -1) {
      _mockActivities[index] = activity;
      debugPrint('🔄 Actividad actualizada: ${activity.id}');
    }
    return activity;
  }

  @override
  Future<void> deleteActivity(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockActivities.removeWhere((a) => a.id == id);
    debugPrint('🗑️ Actividad eliminada: $id - Total: ${_mockActivities.length}');
  }

  @override
  Future<ActivitySummaryEntity> getActivitySummary({
    String? farmId,
    String? lotId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final activities = await getActivities(
      farmId: farmId,
      lotId: lotId,
      startDate: startDate,
      endDate: endDate,
    );

    return ActivitySummaryEntity(
      totalActivities: activities.length,
      completedActivities: activities.where((a) => a.status == ActivityStatusEntity.completed).length,
      pendingActivities: activities.where((a) => a.status == ActivityStatusEntity.pending).length,
      inProgressActivities: activities.where((a) => a.status == ActivityStatusEntity.inProgress).length,
      cancelledActivities: activities.where((a) => a.status == ActivityStatusEntity.cancelled).length,
      totalCost: activities.fold(0, (sum, a) => sum + a.cost),
      activitiesByType: {},
      activitiesByLot: {},
    );
  }
}

// Provider para gestionar el estado de las actividades
class ActivitiesProvider extends ChangeNotifier {
  final GetActivitiesUseCase _getActivitiesUseCase;
  final GetActivitySummaryUseCase _getActivitySummaryUseCase;
  final CreateActivityUseCase _createActivityUseCase;
  final UpdateActivityUseCase _updateActivityUseCase;
  final DeleteActivityUseCase _deleteActivityUseCase;

  List<ActivityEntity> _activities = [];
  ActivitySummaryEntity? _summary;
  bool _isLoading = false;
  String? _error;
  String? _searchQuery;
  ActivityTypeEntity? _selectedType;
  ActivityStatusEntity? _selectedStatus;
  String? _selectedLotId;
  String? _selectedFarmId;

  ActivitiesProvider({
    required GetActivitiesUseCase getActivitiesUseCase,
    required GetActivitySummaryUseCase getActivitySummaryUseCase,
    required CreateActivityUseCase createActivityUseCase,
    required UpdateActivityUseCase updateActivityUseCase,
    required DeleteActivityUseCase deleteActivityUseCase,
  })  : _getActivitiesUseCase = getActivitiesUseCase,
        _getActivitySummaryUseCase = getActivitySummaryUseCase,
        _createActivityUseCase = createActivityUseCase,
        _updateActivityUseCase = updateActivityUseCase,
        _deleteActivityUseCase = deleteActivityUseCase {
    // ✅ Cargar actividades al iniciar
    loadActivities();
    loadSummary();
  }

  // Getters
  List<ActivityEntity> get activities => _filteredActivities;
  ActivitySummaryEntity? get summary => _summary;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get searchQuery => _searchQuery;
  ActivityTypeEntity? get selectedType => _selectedType;
  ActivityStatusEntity? get selectedStatus => _selectedStatus;

  List<ActivityEntity> get _filteredActivities {
    var result = List<ActivityEntity>.from(_activities);

    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      final query = _searchQuery!.toLowerCase();
      result = result.where((a) =>
      a.type.title.toLowerCase().contains(query) ||
          a.responsible.toLowerCase().contains(query) ||
          a.description.toLowerCase().contains(query) ||
          a.lotName.toLowerCase().contains(query)
      ).toList();
    }

    if (_selectedType != null) {
      result = result.where((a) => a.type == _selectedType).toList();
    }

    if (_selectedStatus != null) {
      result = result.where((a) => a.status == _selectedStatus).toList();
    }

    if (_selectedLotId != null) {
      result = result.where((a) => a.lotId == _selectedLotId).toList();
    }

    if (_selectedFarmId != null) {
      result = result.where((a) => a.farmId == _selectedFarmId).toList();
    }

    // Ordenar por fecha (más reciente primero)
    result.sort((a, b) => b.date.compareTo(a.date));

    return result;
  }

  // Acciones
  Future<void> loadActivities() async {
    _setLoading(true);
    _error = null;

    try {
      _activities = await _getActivitiesUseCase.execute();
      debugPrint('📊 ActivitiesProvider: ${_activities.length} actividades cargadas');
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error cargando actividades: $e');
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadSummary() async {
    try {
      _summary = await _getActivitySummaryUseCase.execute();
      debugPrint('📊 Summary: ${_summary?.totalActivities} actividades totales');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading summary: $e');
    }
  }

  Future<void> refresh() async {
    await Future.wait([
      loadActivities(),
      loadSummary(),
    ]);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedType(ActivityTypeEntity? type) {
    _selectedType = type;
    notifyListeners();
  }

  void setSelectedStatus(ActivityStatusEntity? status) {
    _selectedStatus = status;
    notifyListeners();
  }

  void setSelectedLotId(String? lotId) {
    _selectedLotId = lotId;
    notifyListeners();
  }

  void setSelectedFarmId(String? farmId) {
    _selectedFarmId = farmId;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = null;
    _selectedType = null;
    _selectedStatus = null;
    _selectedLotId = null;
    _selectedFarmId = null;
    notifyListeners();
  }

  Future<ActivityEntity?> createActivity(ActivityEntity activity) async {
    _setLoading(true);

    try {
      final newActivity = await _createActivityUseCase.execute(activity);
      await loadActivities();
      await loadSummary();
      return newActivity;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<ActivityEntity?> updateActivity(ActivityEntity activity) async {
    _setLoading(true);

    try {
      final updatedActivity = await _updateActivityUseCase.execute(activity);
      await loadActivities();
      await loadSummary();
      return updatedActivity;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteActivity(String id) async {
    _setLoading(true);

    try {
      await _deleteActivityUseCase.execute(id);
      await loadActivities();
      await loadSummary();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}

// Factory para crear el provider con las dependencias
class ActivitiesProviderFactory {
  static ActivitiesProvider create() {
    final repository = MockActivityRepository();
    debugPrint('🏭 Creando ActivitiesProvider con repositorio vacío');
    return ActivitiesProvider(
      getActivitiesUseCase: GetActivitiesUseCase(repository),
      getActivitySummaryUseCase: GetActivitySummaryUseCase(repository),
      createActivityUseCase: CreateActivityUseCase(repository),
      updateActivityUseCase: UpdateActivityUseCase(repository),
      deleteActivityUseCase: DeleteActivityUseCase(repository),
    );
  }
}