// lib/features/buyer/providers/cooperative_producers_provider.dart

import 'package:flutter/material.dart';
import 'package:kaabcafe/features/buyer/data/models/producer_summary_model.dart';

class CooperativeProducersProvider extends ChangeNotifier {
  final List<ProducerSummaryModel> _producers = [];

  List<ProducerSummaryModel> get producers => List.unmodifiable(_producers);
  int get count => _producers.length;
  int get activeCount => _producers.where((p) => p.status == 'Activo').length;
  int get inactiveCount => _producers.where((p) => p.status == 'Inactivo').length;

  double get totalProduction => _producers.fold(0, (sum, p) => sum + p.totalProduction);
  double get averageProduction => count > 0 ? totalProduction / count : 0;

  // ✅ Agregar productor
  void addProducer(ProducerSummaryModel producer) {
    _producers.add(producer);
    notifyListeners();
  }

  // ✅ Eliminar productor
  void removeProducer(String id) {
    _producers.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  // ✅ Actualizar productor
  void updateProducer(ProducerSummaryModel producer) {
    final index = _producers.indexWhere((p) => p.id == producer.id);
    if (index != -1) {
      _producers[index] = producer;
      notifyListeners();
    }
  }

  // ✅ Obtener productor por ID
  ProducerSummaryModel? getProducerById(String id) {
    try {
      return _producers.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // ✅ Buscar productores
  List<ProducerSummaryModel> searchProducers(String query) {
    if (query.isEmpty) return _producers;
    return _producers.where((p) {
      final lowerQuery = query.toLowerCase();
      return p.name.toLowerCase().contains(lowerQuery) ||
          p.email.toLowerCase().contains(lowerQuery) ||
          p.phone.contains(query);
    }).toList();
  }

  // ✅ Filtrar productores por estado
  List<ProducerSummaryModel> filterProducers(String status) {
    if (status == 'Todos' || status == 'Todos los productores') return _producers;
    return _producers.where((p) => p.status == status).toList();
  }

  // ✅ Cargar productores de ejemplo (para demo)
  void loadSampleProducers() {
    _producers.clear();
    _producers.addAll([
      ProducerSummaryModel(
        id: '1',
        name: 'Juan Pérez Gómez',
        email: 'juan.perez@email.com',
        phone: '+52 123 456 7890',
        status: 'Activo',
        farmsCount: 3,
        lotsCount: 8,
        totalProduction: 2450,
        averageQuality: 85.5,
        location: 'Motozintla, Chiapas',
      ),
      ProducerSummaryModel(
        id: '2',
        name: 'María López Hernández',
        email: 'maria.lopez@email.com',
        phone: '+52 987 654 3210',
        status: 'Activo',
        farmsCount: 2,
        lotsCount: 5,
        totalProduction: 1800,
        averageQuality: 92.0,
        location: 'Tapachula, Chiapas',
      ),
      ProducerSummaryModel(
        id: '3',
        name: 'Carlos Sánchez Ruiz',
        email: 'carlos.sanchez@email.com',
        phone: '+52 555 123 4567',
        status: 'Pendiente',
        farmsCount: 0,
        lotsCount: 0,
        totalProduction: 0,
        averageQuality: 0,
        location: 'Comitán, Chiapas',
      ),
    ]);
    notifyListeners();
  }
}