import 'package:flutter/material.dart';
import 'package:kaabcafe/features/farms/data/models/farm_details_model.dart';
import 'package:kaabcafe/features/farms/data/models/lot_model.dart';

class FarmProvider extends ChangeNotifier {
  final List<FarmDetailsModel> _farms = [];
  // Mapa de lotes por ID de finca
  final Map<String, List<LotModel>> _lotsByFarm = {};

  List<FarmDetailsModel> get farms => List.unmodifiable(_farms);

  List<LotModel> getLotsForFarm(String farmId) => _lotsByFarm[farmId] ?? [];

  void addFarm(FarmDetailsModel newFarm) {
    _farms.add(newFarm);
    notifyListeners();
  }

  void addLotToFarm(String farmId, LotModel newLot) {
    // 1. Agregar el lote a la lista de esa finca
    if (_lotsByFarm[farmId] == null) _lotsByFarm[farmId] = [];
    _lotsByFarm[farmId]!.add(newLot);

    // 2. Incrementar el contador en el modelo de la finca
    final index = _farms.indexWhere((f) => f.id == farmId);
    if (index != -1) {
      _farms[index] = _farms[index].copyWith(lots: _lotsByFarm[farmId]!.length);
    }
    notifyListeners();
  }

  void deleteLotFromFarm(String farmId, String lotId) {
    if (_lotsByFarm[farmId] != null) {
      // 1. Eliminar el lote
      _lotsByFarm[farmId]!.removeWhere((lot) => lot.id == lotId);

      // 2. Actualizar el contador en el modelo de la finca
      final index = _farms.indexWhere((f) => f.id == farmId);
      if (index != -1) {
        _farms[index] = _farms[index].copyWith(lots: _lotsByFarm[farmId]!.length);
      }
      notifyListeners();
    }
  }
}