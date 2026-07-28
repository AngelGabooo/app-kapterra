// lib/features/technician/providers/technician_visits_provider.dart
import 'package:flutter/material.dart';
import 'package:kaabcafe/features/technician/data/models/technician_visit_model.dart';

class TechnicianVisitsProvider extends ChangeNotifier {
  final List<TechnicianVisitModel> _visits = [];

  List<TechnicianVisitModel> get visits => List.unmodifiable(_visits);
  List<TechnicianVisitModel> get completedVisits =>
      _visits.where((v) => v.status == 'completed').toList();
  List<TechnicianVisitModel> get pendingVisits =>
      _visits.where((v) => v.status == 'pending').toList();
  List<TechnicianVisitModel> get urgentVisits =>
      _visits.where((v) => v.isUrgent).toList();

  int get totalVisits => _visits.length;
  int get completedCount => completedVisits.length;
  int get pendingCount => pendingVisits.length;
  int get urgentCount => urgentVisits.length;

  void addVisit(TechnicianVisitModel visit) {
    _visits.add(visit);
    notifyListeners();
  }

  void updateVisitStatus(String id, String status) {
    final index = _visits.indexWhere((v) => v.id == id);
    if (index != -1) {
      _visits[index] = TechnicianVisitModel(
        id: _visits[index].id,
        technicianId: _visits[index].technicianId,
        technicianName: _visits[index].technicianName,
        producerId: _visits[index].producerId,
        producerName: _visits[index].producerName,
        farmId: _visits[index].farmId,
        farmName: _visits[index].farmName,
        lotId: _visits[index].lotId,
        lotName: _visits[index].lotName,
        location: _visits[index].location,
        visitDate: _visits[index].visitDate,
        objective: _visits[index].objective,
        observations: _visits[index].observations,
        recommendations: _visits[index].recommendations,
        evidenceUrls: _visits[index].evidenceUrls,
        status: status,
        isUrgent: _visits[index].isUrgent,
        createdAt: _visits[index].createdAt,
      );
      notifyListeners();
    }
  }

  void clearAll() {
    _visits.clear();
    notifyListeners();
  }
}