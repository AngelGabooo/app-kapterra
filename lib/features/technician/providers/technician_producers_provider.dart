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
    _producers.add(producer);
    notifyListeners();
  }

  // ✅ Agregar múltiples productores
  void addProducers(List<TechnicianProducerModel> producers) {
    _producers.addAll(producers);
    notifyListeners();
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

  // ✅ Cargar productores de ejemplo (para demo)
  void loadSampleProducers() {
    _producers.clear();
    _producers.addAll([
      TechnicianProducerModel(
        id: 'p1',
        name: 'Juan Pérez Gómez',
        location: 'Motozintla, Chiapas',
        production: 2450,
        traceability: 92,
        status: ProducerStatus.excellent,
        lastVisit: '2026-07-20',
      ),
      TechnicianProducerModel(
        id: 'p2',
        name: 'María López Hernández',
        location: 'Tapachula, Chiapas',
        production: 1800,
        traceability: 78,
        status: ProducerStatus.requiresAttention,
        lastVisit: '2026-07-15',
      ),
      TechnicianProducerModel(
        id: 'p3',
        name: 'Carlos Sánchez Ruiz',
        location: 'Comitán, Chiapas',
        production: 950,
        traceability: 45,
        status: ProducerStatus.risk,
        lastVisit: '2026-07-10',
      ),
    ]);
    notifyListeners();
  }
}