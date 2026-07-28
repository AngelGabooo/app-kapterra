// lib/core/providers/farm_provider.dart

import 'package:flutter/material.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';
import 'package:kaabcafe/features/farms/data/models/lot_model.dart';
import 'package:kaabcafe/features/buyer/data/models/producer_summary_model.dart';

class FarmProvider extends ChangeNotifier {
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

  // ✅ Agregar finca con productor
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

  // ✅ Agregar finca al productor (usando el email del productor)
  void addFarmForProducer(FarmDetailsModel newFarm, String producerEmail) {
    _farms.add(newFarm);
    _farmProducerMap[newFarm.id] = producerEmail;
    debugPrint('✅ Finca "${newFarm.name}" agregada para productor: $producerEmail');
    notifyListeners();
    debugPrintState();
  }

  // ✅ Asociar una finca existente a un productor
  void associateFarmWithProducer(String farmId, String producerId) {
    // Verificar si la finca existe
    final farmExists = _farms.any((f) => f.id == farmId);
    if (!farmExists) {
      debugPrint('⚠️ La finca $farmId no existe en FarmProvider');
      return;
    }

    // Verificar si ya está asociada
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

    // Actualizar el contador de lotes en la finca
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