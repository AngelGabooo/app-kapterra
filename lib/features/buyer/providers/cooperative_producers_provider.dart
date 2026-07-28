// lib/features/buyer/providers/cooperative_producers_provider.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/features/buyer/data/models/producer_summary_model.dart';
import 'package:kaabcafe/core/providers/cooperative_contact_provider.dart';
import 'package:kaabcafe/features/dashboard/data/models/cooperative_contact_request_model.dart';

class CooperativeProducersProvider extends ChangeNotifier {
  final List<ProducerSummaryModel> _producers = [];
  CooperativeContactProvider? _contactProvider;

  List<ProducerSummaryModel> get producers => List.unmodifiable(_producers);
  int get count => _producers.length;
  int get activeCount => _producers.where((p) => p.status == 'Activo').length;
  int get inactiveCount => _producers.where((p) => p.status == 'Inactivo').length;
  int get pendingCount => _producers.where((p) => p.status == 'Pendiente').length;

  double get totalProduction => _producers.fold(0, (sum, p) => sum + p.totalProduction);
  double get averageProduction => count > 0 ? totalProduction / count : 0;

  // ✅ Inicializar con el provider de contactos
  void init(CooperativeContactProvider contactProvider) {
    _contactProvider = contactProvider;
    // Cargar productores desde las solicitudes pendientes
    _loadProducersFromRequests();
  }

  // ✅ Cargar productores desde las solicitudes de contacto
  void _loadProducersFromRequests() {
    if (_contactProvider == null) return;
    final pendingRequests = _contactProvider!.pendingRequests;
    for (final request in pendingRequests) {
      _addProducerFromRequest(request);
    }
  }

  // ✅ Convertir una solicitud en un productor
  void _addProducerFromRequest(CooperativeContactRequestModel request) {
    // Verificar si ya existe
    final exists = _producers.any((p) => p.email == request.producerEmail);
    if (!exists) {
      final producer = ProducerSummaryModel(
        id: request.id,
        name: request.producerName,
        email: request.producerEmail,
        phone: request.producerPhone,
        status: 'Pendiente', // Estado pendiente hasta que la cooperativa lo acepte
        farmsCount: 0,
        lotsCount: 0,
        totalProduction: 0,
        averageQuality: 0,
        location: request.location,
        requestId: request.id, // Guardamos el ID de la solicitud
        cooperativeName: request.cooperativeName,
      );
      _producers.add(producer);
      notifyListeners();
    }
  }

  // ✅ Agregar productor manualmente
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

  // ✅ Aceptar un productor pendiente (cambiar estado a Activo)
  void acceptProducer(String producerId) {
    final index = _producers.indexWhere((p) => p.id == producerId);
    if (index != -1) {
      final producer = _producers[index];
      if (producer.status == 'Pendiente') {
        _producers[index] = producer.copyWith(
          status: 'Activo',
        );
        notifyListeners();
      }
    }
  }

  // ✅ Rechazar un productor pendiente (eliminarlo)
  void rejectProducer(String producerId) {
    _producers.removeWhere((p) => p.id == producerId);
    notifyListeners();
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

// ✅ Cargar productores de ejemplo - ELIMINADO, ahora viene de las solicitudes
// Ya no se cargan datos de ejemplo
}