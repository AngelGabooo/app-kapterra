// lib/features/technician/providers/technician_producers_provider.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/features/technician/data/models/technician_model.dart';

class TechnicianProducersProvider extends ChangeNotifier {
  final List<TechnicianProducerModel> _producers = [];

  List<TechnicianProducerModel> get producers => List.unmodifiable(_producers);
  int get count => _producers.length;
  int get excellentCount => _producers.where((p) => p.status == ProducerStatus.excellent).length;
  int get attentionCount => _producers.where((p) => p.status == ProducerStatus.requiresAttention).length;
  int get riskCount => _producers.where((p) => p.status == ProducerStatus.risk).length;

  // ✅ Agregar productor asignado
  void addProducer(TechnicianProducerModel producer) {
    // Verificar si ya existe para evitar duplicados
    final exists = _producers.any((p) => p.id == producer.id);
    if (!exists) {
      _producers.add(producer);
      notifyListeners();
      debugPrint('✅ Productor agregado al técnico: ${producer.name} (Fincas: ${producer.farmsCount}, Lotes: ${producer.lotsCount})');
    } else {
      // Si existe, actualizar sus datos
      updateProducer(producer);
    }
  }

  // ✅ Agregar múltiples productores
  void addProducers(List<TechnicianProducerModel> producers) {
    for (final producer in producers) {
      final exists = _producers.any((p) => p.id == producer.id);
      if (!exists) {
        _producers.add(producer);
      } else {
        // Actualizar existente
        final index = _producers.indexWhere((p) => p.id == producer.id);
        if (index != -1) {
          _producers[index] = _producers[index].copyWith(
            farmsCount: producer.farmsCount,
            lotsCount: producer.lotsCount,
            totalProduction: producer.totalProduction,
            averageQuality: producer.averageQuality,
            location: producer.location,
            farmName: producer.farmName,
            lotName: producer.lotName,
          );
        }
      }
    }
    notifyListeners();
    debugPrint('✅ ${producers.length} productores agregados/actualizados al técnico');
  }

  // ✅ Eliminar productor
  void removeProducer(String id) {
    _producers.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  // ✅ Actualizar productor
  void updateProducer(TechnicianProducerModel producer) {
    final index = _producers.indexWhere((p) => p.id == producer.id);
    if (index != -1) {
      _producers[index] = producer;
      notifyListeners();
      debugPrint('✅ Productor actualizado: ${producer.name}');
    }
  }

  // ✅ Buscar productores
  List<TechnicianProducerModel> searchProducers(String query) {
    if (query.isEmpty) return _producers;
    return _producers.where((p) =>
    p.name.toLowerCase().contains(query.toLowerCase()) ||
        p.location.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // ✅ Filtrar por estado
  List<TechnicianProducerModel> filterByStatus(ProducerStatus? status) {
    if (status == null) return _producers;
    return _producers.where((p) => p.status == status).toList();
  }

  // ✅ Obtener productor por ID
  TechnicianProducerModel? getProducerById(String id) {
    try {
      return _producers.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // ✅ Cargar productores desde la cooperativa (recibidos por asignación)
  void loadProducersFromCooperative(List<TechnicianProducerModel> producers) {
    _producers.clear();
    _producers.addAll(producers);
    notifyListeners();
  }

  // ✅ Sincronizar productor con datos actualizados
  void syncProducer(String producerId, {
    int? farmsCount,
    int? lotsCount,
    double? totalProduction,
    double? averageQuality,
    String? location,
    String? farmName,
    String? lotName,
  }) {
    final index = _producers.indexWhere((p) => p.id == producerId);
    if (index != -1) {
      _producers[index] = _producers[index].copyWith(
        farmsCount: farmsCount ?? _producers[index].farmsCount,
        lotsCount: lotsCount ?? _producers[index].lotsCount,
        totalProduction: totalProduction ?? _producers[index].totalProduction,
        averageQuality: averageQuality ?? _producers[index].averageQuality,
        location: location ?? _producers[index].location,
        farmName: farmName ?? _producers[index].farmName,
        lotName: lotName ?? _producers[index].lotName,
      );
      notifyListeners();
      debugPrint('✅ Productor sincronizado: ${_producers[index].name}');
    }
  }

  // ✅ Limpiar todos los productores
  void clearAll() {
    _producers.clear();
    notifyListeners();
  }
}