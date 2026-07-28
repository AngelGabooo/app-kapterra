// lib/features/dashboard/data/models/producer_technician_model.dart
class ProducerTechnicianModel {
  final String producerId;
  final String producerName;
  final String technicianId;
  final String technicianName;
  final String technicianPhone;
  final String technicianEmail;
  final String status; // assigned, pending, rejected
  final DateTime assignedDate;
  final String? cooperativeId;

  ProducerTechnicianModel({
    required this.producerId,
    required this.producerName,
    required this.technicianId,
    required this.technicianName,
    required this.technicianPhone,
    required this.technicianEmail,
    required this.status,
    required this.assignedDate,
    this.cooperativeId,
  });

  factory ProducerTechnicianModel.fromJson(Map<String, dynamic> json) {
    return ProducerTechnicianModel(
      producerId: json['producerId'] ?? '',
      producerName: json['producerName'] ?? '',
      technicianId: json['technicianId'] ?? '',
      technicianName: json['technicianName'] ?? '',
      technicianPhone: json['technicianPhone'] ?? '',
      technicianEmail: json['technicianEmail'] ?? '',
      status: json['status'] ?? 'assigned',
      assignedDate: DateTime.parse(json['assignedDate'] ?? DateTime.now().toIso8601String()),
      cooperativeId: json['cooperativeId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'producerId': producerId,
      'producerName': producerName,
      'technicianId': technicianId,
      'technicianName': technicianName,
      'technicianPhone': technicianPhone,
      'technicianEmail': technicianEmail,
      'status': status,
      'assignedDate': assignedDate.toIso8601String(),
      'cooperativeId': cooperativeId,
    };
  }

  // ✅ MÉTODO COPYWITH
  ProducerTechnicianModel copyWith({
    String? producerId,
    String? producerName,
    String? technicianId,
    String? technicianName,
    String? technicianPhone,
    String? technicianEmail,
    String? status,
    DateTime? assignedDate,
    String? cooperativeId,
  }) {
    return ProducerTechnicianModel(
      producerId: producerId ?? this.producerId,
      producerName: producerName ?? this.producerName,
      technicianId: technicianId ?? this.technicianId,
      technicianName: technicianName ?? this.technicianName,
      technicianPhone: technicianPhone ?? this.technicianPhone,
      technicianEmail: technicianEmail ?? this.technicianEmail,
      status: status ?? this.status,
      assignedDate: assignedDate ?? this.assignedDate,
      cooperativeId: cooperativeId ?? this.cooperativeId,
    );
  }
}