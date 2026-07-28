// lib/features/buyer/providers/technicians_provider.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/features/buyer/data/models/technician_model.dart';
import 'package:kaabcafe/core/providers/technician_contact_provider.dart';
import 'package:kaabcafe/features/dashboard/data/models/technician_contact_request_model.dart';

class TechniciansProvider extends ChangeNotifier {
  final List<TechnicianModel> _technicians = [];
  TechnicianContactProvider? _contactProvider;

  List<TechnicianModel> get technicians => List.unmodifiable(_technicians);
  int get count => _technicians.length;
  int get activeCount => _technicians.where((t) => t.status == 'Activo').length;
  int get pendingCount => _technicians.where((t) => t.status == 'Pendiente').length;

  // ✅ Inicializar con el provider de contactos
  void init(TechnicianContactProvider contactProvider) {
    _contactProvider = contactProvider;
    _loadTechniciansFromRequests();
  }

  // ✅ Cargar técnicos desde las solicitudes
  void _loadTechniciansFromRequests() {
    if (_contactProvider == null) return;
    final pendingRequests = _contactProvider!.pendingRequests;
    for (final request in pendingRequests) {
      _addTechnicianFromRequest(request);
    }
  }

  // ✅ Convertir una solicitud en un técnico
  void _addTechnicianFromRequest(TechnicianContactRequestModel request) {
    final exists = _technicians.any((t) => t.email == request.technicianEmail);
    if (!exists) {
      final technician = TechnicianModel(
        id: request.id,
        fullName: request.technicianName,
        email: request.technicianEmail,
        phone: request.technicianPhone,
        specialty: request.specialty,
        status: 'Pendiente',
        registeredAt: request.requestDate,
        assignedProducers: [],
        farmsCount: 0,
        activeClients: 0,
        averageRating: 0,
        location: 'Sin ubicación',
        totalVisits: 0,
        pendingVisits: 0,
        recommendations: 0,
        certifications: 0,
        performance: 0,
      );
      _technicians.add(technician);
      notifyListeners();
    }
  }

  // ✅ Agregar técnico manualmente
  void addTechnician(TechnicianModel technician) {
    _technicians.add(technician);
    notifyListeners();
  }

  // ✅ Eliminar técnico
  void removeTechnician(String id) {
    _technicians.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // ✅ Actualizar técnico
  void updateTechnician(TechnicianModel technician) {
    final index = _technicians.indexWhere((t) => t.id == technician.id);
    if (index != -1) {
      _technicians[index] = technician;
      notifyListeners();
    }
  }

  // ✅ Aceptar un técnico pendiente
  void acceptTechnician(String technicianId) {
    final index = _technicians.indexWhere((t) => t.id == technicianId);
    if (index != -1) {
      final technician = _technicians[index];
      if (technician.status == 'Pendiente') {
        _technicians[index] = technician.copyWith(
          status: 'Activo',
        );
        notifyListeners();
      }
    }
  }

  // ✅ Rechazar un técnico pendiente
  void rejectTechnician(String technicianId) {
    _technicians.removeWhere((t) => t.id == technicianId);
    notifyListeners();
  }

  // ✅ Obtener técnico por ID
  TechnicianModel? getTechnicianById(String id) {
    try {
      return _technicians.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  // ✅ Asignar productor a técnico
  void assignProducerToTechnician(String technicianId, String producerId) {
    final index = _technicians.indexWhere((t) => t.id == technicianId);
    if (index != -1) {
      final tech = _technicians[index];
      if (!tech.assignedProducers.contains(producerId)) {
        final updated = tech.copyWith(
          assignedProducers: [...tech.assignedProducers, producerId],
        );
        _technicians[index] = updated;
        notifyListeners();
      }
    }
  }

  // ✅ Remover productor de técnico
  void removeProducerFromTechnician(String technicianId, String producerId) {
    final index = _technicians.indexWhere((t) => t.id == technicianId);
    if (index != -1) {
      final tech = _technicians[index];
      final updated = tech.copyWith(
        assignedProducers: tech.assignedProducers.where((id) => id != producerId).toList(),
      );
      _technicians[index] = updated;
      notifyListeners();
    }
  }

  // ✅ Buscar técnicos
  List<TechnicianModel> searchTechnicians(String query) {
    if (query.isEmpty) return _technicians;
    return _technicians.where((t) {
      final lowerQuery = query.toLowerCase();
      return t.fullName.toLowerCase().contains(lowerQuery) ||
          t.email.toLowerCase().contains(lowerQuery) ||
          t.phone.contains(query) ||
          t.specialty.toLowerCase().contains(lowerQuery);
    }).toList();
  }

// ✅ Cargar técnicos de ejemplo - ELIMINADO, ahora viene de las solicitudes
// Ya no se cargan datos de ejemplo
}