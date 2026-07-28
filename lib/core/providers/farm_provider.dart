// lib/core/providers/farm_provider.dart (VERSIÓN MODIFICADA CON API)
import 'package:flutter/material.dart';
import 'package:kaabcafe/core/services/farm_service.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';
import 'package:kaabcafe/features/farms/data/models/lot_model.dart';
import 'package:kaabcafe/features/buyer/data/models/producer_summary_model.dart';
import 'package:kaabcafe/features/farms/data/models/api_farm_model.dart';
import 'package:kaabcafe/features/farms/data/models/create_farm_request.dart';

class FarmProvider extends ChangeNotifier {
  final FarmService _farmService = FarmService();

  final List<FarmDetailsModel> _farms = [];
  final Map<String, List<LotModel>> _lotsByFarm = {};
  final Map<String, String> _farmProducerMap = {}; // farmId -> producerId (email)

  List<FarmDetailsModel> get farms => List.unmodifiable(_farms);
  Map<String, List<LotModel>> get lotsByFarm => _lotsByFarm;

  // ✅ DEBUG: Verificar estado actual
  void debugPrintState() {
    debugPrint('📊 === FarmProvider State ===');
    debugPrint('📌 Total fincas: ${_farms.length}');
    debugPrint('📌 Total lotes: ${_lotsByFarm.values.fold(0, (sum, list) => sum + list.length)}');
    debugPrint('📌 Mapa productor-finca: $_farmProducerMap');
    for (final farm in _farms) {
      debugPrint('  🏠 Finca: ${farm.name} (${farm.id}) - Productor: ${_farmProducerMap[farm.id]}');
      final lots = _lotsByFarm[farm.id] ?? [];
      debugPrint('     📦 Lotes: ${lots.map((l) => l.name).join(', ')}');
    }
    debugPrint('📊 === End FarmProvider State ===');
  }

  List<LotModel> getLotsForFarm(String farmId) => _lotsByFarm[farmId] ?? [];

  // ✅ Obtener fincas por productor
  List<FarmDetailsModel> getFarmsByProducer(String producerId) {
    final farmIds = _farmProducerMap.entries
        .where((entry) => entry.value == producerId)
        .map((entry) => entry.key)
        .toList();

    final result = _farms.where((farm) => farmIds.contains(farm.id)).toList();
    debugPrint('🔍 getFarmsByProducer($producerId): ${result.length} fincas encontradas');
    return result;
  }

  // ✅ Obtener todos los lotes de un productor
  List<LotModel> getLotsByProducer(String producerId) {
    final farms = getFarmsByProducer(producerId);
    final List<LotModel> allLots = [];
    for (final farm in farms) {
      allLots.addAll(getLotsForFarm(farm.id));
    }
    debugPrint('🔍 getLotsByProducer($producerId): ${allLots.length} lotes encontrados');
    return allLots;
  }

  // ✅ Obtener resumen de fincas y lotes para un productor
  ProducerSummaryModel getProducerSummary(String producerId, String producerName, String producerEmail, String producerPhone) {
    final farms = getFarmsByProducer(producerId);
    final allLots = getLotsByProducer(producerId);

    final farmSummaries = farms.map((farm) => ProducerFarmSummary(
      id: farm.id,
      name: farm.name,
      hectares: farm.hectares,
      lotsCount: getLotsForFarm(farm.id).length,
      location: farm.location,
      mainVariety: farm.mainVariety,
      status: farm.statusText,
    )).toList();

    final lotSummaries = allLots.map((lot) {
      final farm = farms.firstWhere(
            (f) => f.id == _getFarmIdForLot(lot.id),
        orElse: () => farms.isNotEmpty ? farms.first : FarmDetailsModel(
          id: '',
          name: 'Finca desconocida',
          location: '',
          hectares: 0,
          lots: 0,
          productivity: 0,
          status: FarmHealthStatus.healthy,
          imageUrl: '',
          latitude: 0,
          longitude: 0,
        ),
      );
      return ProducerLotSummary(
        id: lot.id,
        name: lot.name,
        variety: lot.variety,
        area: lot.area,
        estimatedProduction: lot.estimatedProduction,
        status: lot.statusText,
        farmName: farm.name,
        farmId: farm.id,
      );
    }).toList();

    final totalProduction = allLots.fold(0.0, (sum, lot) => sum + lot.estimatedProduction);

    return ProducerSummaryModel(
      id: producerId,
      name: producerName,
      email: producerEmail,
      phone: producerPhone,
      status: 'Activo',
      farmsCount: farms.length,
      lotsCount: allLots.length,
      totalProduction: totalProduction,
      averageQuality: 85.0,
      location: farms.isNotEmpty ? farms.first.location : null,
      farms: farmSummaries,
      lots: lotSummaries,
    );
  }

  String _getFarmIdForLot(String lotId) {
    for (final entry in _lotsByFarm.entries) {
      if (entry.value.any((lot) => lot.id == lotId)) {
        return entry.key;
      }
    }
    return '';
  }

  // ============================================================
  // ✅ MÉTODOS CON API
  // ============================================================

  // ✅ Crear finca en la API y guardar localmente
  Future<FarmDetailsModel> createFarmWithApi({
    required FarmDetailsModel farm,
    required String producerEmail,
  }) async {
    try {
      // 1. Crear la solicitud
      final request = CreateFarmRequest(
        name: farm.name,
        location: farm.location,
        hectares: farm.hectares,
        lots: farm.lots,
        productivity: farm.productivity,
        status: farm.status.toString().split('.').last,
        imageUrl: farm.imageUrl,
        latitude: farm.latitude,
        longitude: farm.longitude,
        altitude: farm.altitude,
        establishmentYear: farm.establishmentYear,
        mainVariety: farm.mainVariety,
        productionSystem: farm.productionSystem,
        certifications: farm.certifications,
        producerEmail: producerEmail,
      );

      // 2. Llamar a la API
      final apiFarm = await _farmService.createFarm(request);
      debugPrint('✅ Finca creada en API con ID: ${apiFarm.id}');

      // 3. Convertir a modelo local
      final newFarm = _convertApiFarmToLocal(apiFarm);

      // 4. Guardar localmente
      _farms.add(newFarm);
      _farmProducerMap[newFarm.id] = producerEmail;
      notifyListeners();
      debugPrintState();

      return newFarm;
    } catch (e) {
      debugPrint('❌ Error al crear finca: $e');
      rethrow;
    }
  }

  // ✅ Cargar fincas desde la API
  Future<void> loadFarmsFromApi(String producerEmail) async {
    try {
      debugPrint('📤 Cargando fincas de: $producerEmail');
      final apiFarms = await _farmService.getFarmsByProducer(producerEmail);

      // Limpiar fincas existentes del productor
      _farms.removeWhere((farm) => _farmProducerMap[farm.id] == producerEmail);

      // Agregar las fincas de la API
      for (final apiFarm in apiFarms) {
        final farm = _convertApiFarmToLocal(apiFarm);
        _farms.add(farm);
        _farmProducerMap[farm.id] = producerEmail;
        debugPrint('✅ Finca cargada: ${farm.name} (${farm.id})');
      }

      notifyListeners();
      debugPrintState();
    } catch (e) {
      debugPrint('❌ Error al cargar fincas: $e');
    }
  }

  // ✅ Actualizar finca en la API
  Future<FarmDetailsModel> updateFarmWithApi({
    required FarmDetailsModel farm,
    required String producerEmail,
  }) async {
    try {
      final request = CreateFarmRequest(
        name: farm.name,
        location: farm.location,
        hectares: farm.hectares,
        lots: farm.lots,
        productivity: farm.productivity,
        status: farm.status.toString().split('.').last,
        imageUrl: farm.imageUrl,
        latitude: farm.latitude,
        longitude: farm.longitude,
        altitude: farm.altitude,
        establishmentYear: farm.establishmentYear,
        mainVariety: farm.mainVariety,
        productionSystem: farm.productionSystem,
        certifications: farm.certifications,
        producerEmail: producerEmail,
      );

      final apiFarm = await _farmService.updateFarm(
        int.parse(farm.id),
        request,
      );

      final updatedFarm = _convertApiFarmToLocal(apiFarm);

      // Actualizar localmente
      final index = _farms.indexWhere((f) => f.id == farm.id);
      if (index != -1) {
        _farms[index] = updatedFarm;
        notifyListeners();
      }

      return updatedFarm;
    } catch (e) {
      debugPrint('❌ Error al actualizar finca: $e');
      rethrow;
    }
  }

  // ✅ Eliminar finca en la API
  Future<void> deleteFarmWithApi(String farmId) async {
    try {
      await _farmService.deleteFarm(int.parse(farmId));

      // Eliminar localmente
      _farms.removeWhere((farm) => farm.id == farmId);
      _farmProducerMap.remove(farmId);
      _lotsByFarm.remove(farmId);

      notifyListeners();
      debugPrint('✅ Finca eliminada: $farmId');
    } catch (e) {
      debugPrint('❌ Error al eliminar finca: $e');
      rethrow;
    }
  }

  // ============================================================
  // ✅ MÉTODOS DE CONVERSIÓN
  // ============================================================

  FarmDetailsModel _convertApiFarmToLocal(ApiFarmModel apiFarm) {
    FarmHealthStatus status;
    switch (apiFarm.status.toLowerCase()) {
      case 'healthy':
        status = FarmHealthStatus.healthy;
        break;
      case 'attention':
        status = FarmHealthStatus.attention;
        break;
      case 'risk':
        status = FarmHealthStatus.risk;
        break;
      default:
        status = FarmHealthStatus.healthy;
    }

    return FarmDetailsModel(
      id: apiFarm.id.toString(),
      name: apiFarm.name,
      location: apiFarm.location,
      hectares: apiFarm.hectares,
      lots: apiFarm.lots,
      productivity: apiFarm.productivity,
      status: status,
      imageUrl: apiFarm.imageUrl,
      latitude: apiFarm.latitude,
      longitude: apiFarm.longitude,
      altitude: apiFarm.altitude,
      establishmentYear: apiFarm.establishmentYear,
      mainVariety: apiFarm.mainVariety,
      productionSystem: apiFarm.productionSystem,
      certifications: apiFarm.certifications,
    );
  }

  // ============================================================
  // ✅ MÉTODOS LOCALES (MANTENIDOS PARA COMPATIBILIDAD)
  // ============================================================

  // ✅ Agregar finca con productor (local)
  void addFarm(FarmDetailsModel newFarm, {String? producerId}) {
    _farms.add(newFarm);
    if (producerId != null && producerId.isNotEmpty) {
      _farmProducerMap[newFarm.id] = producerId;
      debugPrint('✅ Finca "${newFarm.name}" agregada para productor: $producerId');
    } else {
      debugPrint('⚠️ Finca "${newFarm.name}" agregada SIN productor asociado');
    }
    notifyListeners();
    debugPrintState();
  }

  // ✅ Agregar finca al productor (local)
  void addFarmForProducer(FarmDetailsModel newFarm, String producerEmail) {
    _farms.add(newFarm);
    _farmProducerMap[newFarm.id] = producerEmail;
    debugPrint('✅ Finca "${newFarm.name}" agregada para productor: $producerEmail');
    notifyListeners();
    debugPrintState();
  }

  // ✅ Asociar una finca existente a un productor
  void associateFarmWithProducer(String farmId, String producerId) {
    final farmExists = _farms.any((f) => f.id == farmId);
    if (!farmExists) {
      debugPrint('⚠️ La finca $farmId no existe en FarmProvider');
      return;
    }

    if (_farmProducerMap.containsKey(farmId)) {
      debugPrint('⚠️ La finca $farmId ya está asociada a: ${_farmProducerMap[farmId]}');
      return;
    }

    _farmProducerMap[farmId] = producerId;
    debugPrint('✅ Finca $farmId asociada a productor: $producerId');
    notifyListeners();
    debugPrintState();
  }

  // ✅ Agregar lote a una finca
  void addLotToFarm(String farmId, LotModel newLot) {
    if (_lotsByFarm[farmId] == null) {
      _lotsByFarm[farmId] = [];
    }
    _lotsByFarm[farmId]!.add(newLot);
    debugPrint('✅ Lote "${newLot.name}" agregado a finca: $farmId');

    final index = _farms.indexWhere((f) => f.id == farmId);
    if (index != -1) {
      _farms[index] = _farms[index].copyWith(lots: _lotsByFarm[farmId]!.length);
      debugPrint('✅ Contador de lotes actualizado para finca: ${_farms[index].name} -> ${_farms[index].lots} lotes');
    } else {
      debugPrint('⚠️ Finca no encontrada para actualizar contador: $farmId');
    }

    notifyListeners();
    debugPrintState();
  }

  void deleteLotFromFarm(String farmId, String lotId) {
    if (_lotsByFarm[farmId] != null) {
      _lotsByFarm[farmId]!.removeWhere((lot) => lot.id == lotId);
      final index = _farms.indexWhere((f) => f.id == farmId);
      if (index != -1) {
        _farms[index] = _farms[index].copyWith(lots: _lotsByFarm[farmId]!.length);
      }
      notifyListeners();
    }
  }

  // ✅ Obtener el productor de una finca
  String? getProducerForFarm(String farmId) {
    return _farmProducerMap[farmId];
  }

  // ✅ Verificar si una finca está asociada a un productor
  bool isFarmAssociatedToProducer(String farmId, String producerId) {
    return _farmProducerMap[farmId] == producerId;
  }

  // ✅ Obtener todas las fincas
  List<FarmDetailsModel> getAllFarms() {
    return List.unmodifiable(_farms);
  }

  // ✅ Obtener todos los lotes de todas las fincas
  List<LotModel> getAllLots() {
    final List<LotModel> allLots = [];
    for (final lots in _lotsByFarm.values) {
      allLots.addAll(lots);
    }
    return allLots;
  }

  void clearAll() {
    _farms.clear();
    _lotsByFarm.clear();
    _farmProducerMap.clear();
    notifyListeners();
  }
}