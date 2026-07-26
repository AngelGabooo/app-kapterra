// lib/features/technician/data/models/technician_visit_model.dart

class TechnicianVisitModel {
  final String id;
  final String technicianId;
  final String technicianName;
  final String producerId;
  final String producerName;
  final String farmId;
  final String farmName;
  final String lotId;
  final String lotName;
  final String location;
  final DateTime visitDate;
  final String objective;
  final String observations;
  final List<String> recommendations;
  final List<String> evidenceUrls;
  final String status;
  final bool isUrgent;
  final DateTime createdAt;

  TechnicianVisitModel({
    required this.id,
    required this.technicianId,
    required this.technicianName,
    required this.producerId,
    required this.producerName,
    required this.farmId,
    required this.farmName,
    required this.lotId,
    required this.lotName,
    required this.location,
    required this.visitDate,
    required this.objective,
    this.observations = '',
    this.recommendations = const [],
    this.evidenceUrls = const [],
    this.status = 'completed',
    this.isUrgent = false,
    required this.createdAt,
  });
}