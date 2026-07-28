// lib/features/technician/data/models/technician_certification_model.dart
import 'package:flutter/material.dart';

class TechnicianCertificationModel {
  final String id;
  final String diagnosisId;
  final String lotId;
  final String lotName;
  final String producerName;
  final String technicianName;
  final String type;
  final String description;
  final DateTime issuedDate;
  final DateTime expiryDate;
  final String status;
  final String certificationId;
  final String healthScore;
  final List<String> criteria;

  TechnicianCertificationModel({
    required this.id,
    required this.diagnosisId,
    required this.lotId,
    required this.lotName,
    required this.producerName,
    required this.technicianName,
    required this.type,
    this.description = '',
    required this.issuedDate,
    required this.expiryDate,
    this.status = 'active',
    this.certificationId = '',
    this.healthScore = 'No evaluado',
    this.criteria = const [],
  });

  factory TechnicianCertificationModel.fromJson(Map<String, dynamic> json) {
    return TechnicianCertificationModel(
      id: json['id'] ?? '',
      diagnosisId: json['diagnosisId'] ?? '',
      lotId: json['lotId'] ?? '',
      lotName: json['lotName'] ?? '',
      producerName: json['producerName'] ?? '',
      technicianName: json['technicianName'] ?? '',
      type: json['type'] ?? 'No certificado',
      description: json['description'] ?? '',
      issuedDate: DateTime.parse(json['issuedDate'] ?? DateTime.now().toIso8601String()),
      expiryDate: DateTime.parse(json['expiryDate'] ?? DateTime.now().add(const Duration(days: 365)).toIso8601String()),
      status: json['status'] ?? 'active',
      certificationId: json['certificationId'] ?? '',
      healthScore: json['healthScore'] ?? 'No evaluado',
      criteria: json['criteria'] != null ? List<String>.from(json['criteria']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'diagnosisId': diagnosisId,
      'lotId': lotId,
      'lotName': lotName,
      'producerName': producerName,
      'technicianName': technicianName,
      'type': type,
      'description': description,
      'issuedDate': issuedDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'status': status,
      'certificationId': certificationId,
      'healthScore': healthScore,
      'criteria': criteria,
    };
  }

  TechnicianCertificationModel copyWith({
    String? id,
    String? diagnosisId,
    String? lotId,
    String? lotName,
    String? producerName,
    String? technicianName,
    String? type,
    String? description,
    DateTime? issuedDate,
    DateTime? expiryDate,
    String? status,
    String? certificationId,
    String? healthScore,
    List<String>? criteria,
  }) {
    return TechnicianCertificationModel(
      id: id ?? this.id,
      diagnosisId: diagnosisId ?? this.diagnosisId,
      lotId: lotId ?? this.lotId,
      lotName: lotName ?? this.lotName,
      producerName: producerName ?? this.producerName,
      technicianName: technicianName ?? this.technicianName,
      type: type ?? this.type,
      description: description ?? this.description,
      issuedDate: issuedDate ?? this.issuedDate,
      expiryDate: expiryDate ?? this.expiryDate,
      status: status ?? this.status,
      certificationId: certificationId ?? this.certificationId,
      healthScore: healthScore ?? this.healthScore,
      criteria: criteria ?? this.criteria,
    );
  }
}