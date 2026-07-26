// lib/features/buyer/providers/technicians_provider.dart

import 'package:flutter/material.dart';
import 'package:kaabcafe/features/buyer/data/models/technician_model.dart';

class TechniciansProvider extends ChangeNotifier {
  final List<TechnicianModel> _technicians = [];

  List<TechnicianModel> get technicians => List.unmodifiable(_technicians);
  int get count => _technicians.length;
  int get activeCount => _technicians.where((t) => t.status == 'Activo').length;

  // ✅ Agregar técnico
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

  // ✅ Cargar técnicos de ejemplo CON TODOS LOS CAMPOS
  void loadSampleTechnicians() {
    _technicians.clear();
    _technicians.addAll([
      TechnicianModel(
        id: 't1',
        fullName: 'Ing. María González',
        email: 'maria.gonzalez@email.com',
        phone: '+52 123 456 7890',
        specialty: 'Agronomía',
        status: 'Activo',
        registeredAt: DateTime.now().subtract(const Duration(days: 45)),
        assignedProducers: ['1', '2'],
        farmsCount: 5,
        activeClients: 2,
        averageRating: 4.8,
        location: 'Motozintla, Chiapas',
        // ✅ NUEVOS CAMPOS
        totalVisits: 24,
        pendingVisits: 3,
        recommendations: 12,
        certifications: 5,
        performance: 85,
      ),
      TechnicianModel(
        id: 't2',
        fullName: 'Ing. Carlos Ramírez',
        email: 'carlos.ramirez@email.com',
        phone: '+52 987 654 3210',
        specialty: 'Fitopatología',
        status: 'Activo',
        registeredAt: DateTime.now().subtract(const Duration(days: 30)),
        assignedProducers: ['3'],
        farmsCount: 3,
        activeClients: 1,
        averageRating: 4.5,
        location: 'Tapachula, Chiapas',
        // ✅ NUEVOS CAMPOS
        totalVisits: 18,
        pendingVisits: 5,
        recommendations: 8,
        certifications: 3,
        performance: 72,
      ),
      TechnicianModel(
        id: 't3',
        fullName: 'Ing. Ana Martínez',
        email: 'ana.martinez@email.com',
        phone: '+52 555 123 4567',
        specialty: 'Suelos',
        status: 'Pendiente',
        registeredAt: DateTime.now().subtract(const Duration(days: 5)),
        assignedProducers: [],
        farmsCount: 0,
        activeClients: 0,
        averageRating: 0,
        location: 'Comitán, Chiapas',
        // ✅ NUEVOS CAMPOS
        totalVisits: 0,
        pendingVisits: 0,
        recommendations: 0,
        certifications: 0,
        performance: 0,
      ),
    ]);
    notifyListeners();
  }
}