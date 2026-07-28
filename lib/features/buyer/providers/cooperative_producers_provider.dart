// lib/features/buyer/providers/cooperative_producers_provider.dart

import 'package:flutter/material.dart';
import 'package:kaabcafe/features/buyer/data/models/producer_summary_model.dart';
import 'package:kaabcafe/core/providers/cooperative_contact_provider.dart';
import 'package:kaabcafe/features/dashboard/data/models/cooperative_contact_request_model.dart';
import 'package:kaabcafe/core/providers/farm_provider.dart';

class CooperativeProducersProvider extends ChangeNotifier {
  final List<ProducerSummaryModel> _producers = [];
  CooperativeContactProvider? _contactProvider;
  FarmProvider? _farmProvider;

  List<ProducerSummaryModel> get producers => List.unmodifiable(_producers);
  int get count => _producers.length;
  int get activeCount => _producers.where((p) => p.status == 'Activo').length;
  int get inactiveCount => _producers.where((p) => p.status == 'Inactivo').length;
  int get pendingCount => _producers.where((p) => p.status == 'Pendiente').length;
  double get totalProduction => _producers.fold(0, (sum, p) => sum + p.totalProduction);
  double get averageProduction => count > 0 ? totalProduction / count : 0;

  void init(CooperativeContactProvider contactProvider) {
    _contactProvider = contactProvider;
    _loadProducersFromRequests();
  }

  // ✅ Inicializar con FarmProvider para sincronizar datos
  void initWithFarmProvider(FarmProvider farmProvider) {
    _farmProvider = farmProvider;
    _syncAllProducersWithFarms();
    debugPrint('✅ CooperativeProducersProvider conectado con FarmProvider');
  }

  // ✅ Sincronizar todos los productores con sus fincas y lotes
  void _syncAllProducersWithFarms() {
    if (_farmProvider == null) {
      debugPrint('⚠️ FarmProvider no disponible para sincronizar');
      return;
    }

    debugPrint('🔄 Sincronizando ${_producers.length} productores con FarmProvider...');

    for (int i = 0; i < _producers.length; i++) {
      final producer = _producers[i];
      _syncProducerWithFarmsInternal(i, producer);
    }
    notifyListeners();
    _farmProvider!.debugPrintState();
    debugPrint('✅ Todos los productores sincronizados');
  }

  // ✅ Sincronizar un productor específico (con creación automática si no existe)
  void syncProducerWithFarms(String producerId) {
    if (_farmProvider == null) {
      debugPrint('⚠️ FarmProvider no disponible para sincronizar');
      return;
    }

    // ✅ VERIFICAR SI EL PRODUCTOR EXISTE EN LA LISTA
    int index = _producers.indexWhere((p) => p.id == producerId);

    if (index == -1) {
      debugPrint('⚠️ Productor no encontrado: $producerId, creándolo automáticamente...');

      // ✅ CREAR UN PRODUCTOR POR DEFECTO CON EL EMAIL COMO ID
      final defaultProducer = ProducerSummaryModel(
        id: producerId,
        name: 'Productor $producerId', // Nombre temporal
        email: producerId, // Usar el email como ID
        phone: '',
        status: 'Activo',
        farmsCount: 0,
        lotsCount: 0,
        totalProduction: 0,
        averageQuality: 0,
        location: 'Ubicación no especificada',
      );
      _producers.add(defaultProducer);
      index = _producers.length - 1;
      debugPrint('✅ Productor creado automáticamente: $producerId');
    }

    final producer = _producers[index];
    _syncProducerWithFarmsInternal(index, producer);
    notifyListeners();
    _farmProvider!.debugPrintState();
    debugPrint('✅ Productor ${producer.name} sincronizado');
  }

  void _syncProducerWithFarmsInternal(int index, ProducerSummaryModel producer) {
    try {
      final summary = _farmProvider!.getProducerSummary(
        producer.id,
        producer.name,
        producer.email,
        producer.phone,
      );

      _producers[index] = producer.copyWith(
        farmsCount: summary.farmsCount,
        lotsCount: summary.lotsCount,
        totalProduction: summary.totalProduction,
        farms: summary.farms,
        lots: summary.lots,
        location: summary.location ?? producer.location,
      );

      debugPrint('  ✅ ${producer.name}: ${summary.farmsCount} fincas, ${summary.lotsCount} lotes');
    } catch (e) {
      debugPrint('  ❌ Error sincronizando ${producer.name}: $e');
    }
  }

  void _loadProducersFromRequests() {
    if (_contactProvider == null) return;
    final pendingRequests = _contactProvider!.pendingRequests;
    for (final request in pendingRequests) {
      _addProducerFromRequest(request);
    }
  }

  void _addProducerFromRequest(CooperativeContactRequestModel request) {
    final exists = _producers.any((p) => p.email == request.producerEmail);
    if (!exists) {
      final producer = ProducerSummaryModel(
        id: request.id,
        name: request.producerName,
        email: request.producerEmail,
        phone: request.producerPhone,
        status: 'Pendiente',
        farmsCount: 0,
        lotsCount: 0,
        totalProduction: 0,
        averageQuality: 0,
        location: request.location,
        requestId: request.id,
        cooperativeName: request.cooperativeName,
      );
      _producers.add(producer);
      debugPrint('✅ Productor agregado desde solicitud: ${producer.name}');

      // ✅ Sincronizar con fincas si está disponible
      if (_farmProvider != null) {
        syncProducerWithFarms(producer.id);
      }
      notifyListeners();
    }
  }

  void addProducer(ProducerSummaryModel producer) {
    _producers.add(producer);
    debugPrint('✅ Productor agregado manualmente: ${producer.name}');

    // ✅ Sincronizar con fincas
    if (_farmProvider != null) {
      syncProducerWithFarms(producer.id);
    }
    notifyListeners();
  }

  void removeProducer(String id) {
    _producers.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void updateProducer(ProducerSummaryModel producer) {
    final index = _producers.indexWhere((p) => p.id == producer.id);
    if (index != -1) {
      _producers[index] = producer;
      // ✅ Sincronizar con fincas
      if (_farmProvider != null) {
        syncProducerWithFarms(producer.id);
      }
      notifyListeners();
    }
  }

  void acceptProducer(String producerId) {
    final index = _producers.indexWhere((p) => p.id == producerId);
    if (index != -1) {
      final producer = _producers[index];
      if (producer.status == 'Pendiente') {
        _producers[index] = producer.copyWith(status: 'Activo');
        // ✅ Sincronizar con fincas
        if (_farmProvider != null) {
          syncProducerWithFarms(producerId);
        }
        notifyListeners();
      }
    }
  }

  void rejectProducer(String producerId) {
    _producers.removeWhere((p) => p.id == producerId);
    notifyListeners();
  }

  ProducerSummaryModel? getProducerById(String id) {
    try {
      return _producers.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // ✅ Obtener productor por email
  ProducerSummaryModel? getProducerByEmail(String email) {
    try {
      return _producers.firstWhere((p) => p.email == email);
    } catch (e) {
      return null;
    }
  }

  List<ProducerSummaryModel> searchProducers(String query) {
    if (query.isEmpty) return _producers;
    return _producers.where((p) {
      final lowerQuery = query.toLowerCase();
      return p.name.toLowerCase().contains(lowerQuery) ||
          p.email.toLowerCase().contains(lowerQuery) ||
          p.phone.contains(query);
    }).toList();
  }

  List<ProducerSummaryModel> filterProducers(String status) {
    if (status == 'Todos' || status == 'Todos los productores') return _producers;
    return _producers.where((p) => p.status == status).toList();
  }

  // ✅ Método para actualizar datos desde FarmProvider
  void refreshProducerData(String producerId) {
    syncProducerWithFarms(producerId);
  }

  void refreshAllProducers() {
    _syncAllProducersWithFarms();
  }

  // ✅ Método para crear o actualizar un productor desde el email
  void ensureProducerExists(String email, {String? name, String? phone}) {
    final existing = getProducerByEmail(email);
    if (existing == null) {
      final newProducer = ProducerSummaryModel(
        id: email, // Usar el email como ID
        name: name ?? 'Productor $email',
        email: email,
        phone: phone ?? '',
        status: 'Activo',
        farmsCount: 0,
        lotsCount: 0,
        totalProduction: 0,
        averageQuality: 0,
        location: 'Ubicación no especificada',
      );
      _producers.add(newProducer);
      debugPrint('✅ Productor creado desde email: $email');

      // ✅ Sincronizar con fincas
      if (_farmProvider != null) {
        syncProducerWithFarms(email);
      }
      notifyListeners();
    } else {
      // Actualizar nombre y teléfono si es necesario
      if (name != null && name.isNotEmpty && existing.name != name) {
        final index = _producers.indexWhere((p) => p.id == existing.id);
        if (index != -1) {
          _producers[index] = existing.copyWith(name: name);
          notifyListeners();
        }
      }
      if (phone != null && phone.isNotEmpty && existing.phone != phone) {
        final index = _producers.indexWhere((p) => p.id == existing.id);
        if (index != -1) {
          _producers[index] = existing.copyWith(phone: phone);
          notifyListeners();
        }
      }
      debugPrint('✅ Productor ya existe: $email');
    }
  }

  void clearAll() {
    _producers.clear();
    notifyListeners();
  }
}