// lib/features/technician/providers/technician_reports_provider.dart

import 'package:flutter/material.dart';
import 'package:kaabcafe/features/technician/data/models/technician_visit_model.dart';
import 'package:kaabcafe/features/technician/data/models/technician_diagnosis_model.dart';

class TechnicianReportsProvider extends ChangeNotifier {
  final List<TechnicianVisitModel> _visits = [];
  final List<TechnicianDiagnosisModel> _diagnoses = [];

  List<TechnicianVisitModel> get visits => List.unmodifiable(_visits);
  List<TechnicianDiagnosisModel> get diagnoses => List.unmodifiable(_diagnoses);

  int get totalVisits => _visits.length;
  int get totalDiagnoses => _diagnoses.length;
  int get totalReports => _visits.length + _diagnoses.length;

  void addVisit(TechnicianVisitModel visit) {
    _visits.add(visit);
    notifyListeners();
  }

  void addDiagnosis(TechnicianDiagnosisModel diagnosis) {
    _diagnoses.add(diagnosis);
    notifyListeners();
  }

  List<TechnicianVisitModel> getVisitsByTechnician(String technicianId) {
    return _visits.where((v) => v.technicianId == technicianId).toList();
  }

  List<TechnicianDiagnosisModel> getDiagnosesByTechnician(String technicianId) {
    return _diagnoses.where((d) => d.technicianId == technicianId).toList();
  }

  List<TechnicianVisitModel> getVisitsByProducer(String producerId) {
    return _visits.where((v) => v.producerId == producerId).toList();
  }

  List<TechnicianDiagnosisModel> getDiagnosesByProducer(String producerId) {
    return _diagnoses.where((d) => d.producerId == producerId).toList();
  }

  List<TechnicianVisitModel> getRecentVisits({int limit = 10}) {
    final sorted = List<TechnicianVisitModel>.from(_visits)
      ..sort((a, b) => b.visitDate.compareTo(a.visitDate));
    return sorted.take(limit).toList();
  }

  List<TechnicianDiagnosisModel> getRecentDiagnoses({int limit = 10}) {
    final sorted = List<TechnicianDiagnosisModel>.from(_diagnoses)
      ..sort((a, b) => b.diagnosisDate.compareTo(a.diagnosisDate));
    return sorted.take(limit).toList();
  }

  void clear() {
    _visits.clear();
    _diagnoses.clear();
    notifyListeners();
  }
}