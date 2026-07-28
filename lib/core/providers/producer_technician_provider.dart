// lib/core/providers/producer_technician_provider.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/features/dashboard/data/models/producer_technician_model.dart';

class ProducerTechnicianProvider extends ChangeNotifier {
  final List<ProducerTechnicianModel> _assignments = [];

  List<ProducerTechnicianModel> get assignments =>
      List.unmodifiable(_assignments);

  /// Obtener el técnico asignado a un productor
  ProducerTechnicianModel? getTechnicianForProducer(String producerId) {
    try {
      return _assignments.firstWhere(
            (a) => a.producerId == producerId && a.status == 'assigned',
      );
    } catch (e) {
      return null;
    }
  }

  /// Obtener todos los productores asignados a un técnico
  List<ProducerTechnicianModel> getProducersForTechnician(String technicianId) {
    return _assignments
        .where((a) => a.technicianId == technicianId && a.status == 'assigned')
        .toList();
  }

  /// Asignar un técnico a un productor
  void assignTechnician(ProducerTechnicianModel assignment) {
    // Verificar si ya existe una asignación
    final existingIndex = _assignments.indexWhere(
          (a) => a.producerId == assignment.producerId && a.status == 'assigned',
    );

    if (existingIndex != -1) {
      // Reemplazar la asignación existente
      _assignments[existingIndex] = assignment;
    } else {
      _assignments.add(assignment);
    }
    notifyListeners();
    debugPrint('✅ Técnico ${assignment.technicianName} asignado a ${assignment.producerName}');
  }

  /// Actualizar el estado de una asignación
  void updateAssignmentStatus(String producerId, String status) {
    final index = _assignments.indexWhere((a) => a.producerId == producerId);
    if (index != -1) {
      _assignments[index] = _assignments[index].copyWith(status: status);
      notifyListeners();
      debugPrint('✅ Estado de asignación actualizado para $producerId: $status');
    }
  }

  /// Obtener el teléfono del técnico para un productor
  String? getTechnicianPhoneForProducer(String producerId) {
    final assignment = getTechnicianForProducer(producerId);
    return assignment?.technicianPhone;
  }

  /// Obtener el nombre del técnico para un productor
  String? getTechnicianNameForProducer(String producerId) {
    final assignment = getTechnicianForProducer(producerId);
    return assignment?.technicianName;
  }

  /// Verificar si un productor tiene técnico asignado
  bool hasTechnicianAssigned(String producerId) {
    return getTechnicianForProducer(producerId) != null;
  }

  /// Obtener todos los técnicos asignados (únicos)
  List<String> getAllAssignedTechnicianIds() {
    return _assignments
        .where((a) => a.status == 'assigned')
        .map((a) => a.technicianId)
        .toSet()
        .toList();
  }

  /// Limpiar todas las asignaciones
  void clearAll() {
    _assignments.clear();
    notifyListeners();
  }
}