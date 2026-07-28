// lib/features/technician/data/models/technician_diagnosis_model.dart
import 'package:flutter/material.dart';
import 'technician_certification_model.dart';

class TechnicianDiagnosisModel {
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
  final DateTime diagnosisDate;
  final double healthScore;
  final String status;
  final List<DiagnosisCategory> categories;
  final List<DiagnosisIssue> issues;
  final List<DiagnosisRisk> risks;
  final List<String> recommendations;
  final TechnicianCertificationModel? certification; // ✅ AHORA ES EL MODELO COMPLETO
  final List<String> evidenceUrls;
  final DateTime createdAt;

  TechnicianDiagnosisModel({
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
    required this.diagnosisDate,
    required this.healthScore,
    required this.status,
    this.categories = const [],
    this.issues = const [],
    this.risks = const [],
    this.recommendations = const [],
    this.certification,
    this.evidenceUrls = const [],
    required this.createdAt,
  });

  factory TechnicianDiagnosisModel.fromJson(Map<String, dynamic> json) {
    return TechnicianDiagnosisModel(
      id: json['id'] ?? '',
      technicianId: json['technicianId'] ?? '',
      technicianName: json['technicianName'] ?? '',
      producerId: json['producerId'] ?? '',
      producerName: json['producerName'] ?? '',
      farmId: json['farmId'] ?? '',
      farmName: json['farmName'] ?? '',
      lotId: json['lotId'] ?? '',
      lotName: json['lotName'] ?? '',
      location: json['location'] ?? '',
      diagnosisDate: DateTime.parse(json['diagnosisDate'] ?? DateTime.now().toIso8601String()),
      healthScore: (json['healthScore'] ?? 0).toDouble(),
      status: json['status'] ?? 'Sin estado',
      categories: json['categories'] != null
          ? (json['categories'] as List).map((c) => DiagnosisCategory(
        label: c['label'] ?? '',
        value: c['value'] ?? 0,
        color: Color(c['color'] ?? 0xFF2E7D32),
      )).toList()
          : [],
      issues: json['issues'] != null
          ? (json['issues'] as List).map((i) => DiagnosisIssue(
        title: i['title'] ?? '',
        level: i['level'] ?? '',
        priority: i['priority'] ?? '',
        priorityColor: Color(i['priorityColor'] ?? 0xFFFF6B35),
      )).toList()
          : [],
      risks: json['risks'] != null
          ? (json['risks'] as List).map((r) => DiagnosisRisk(
        label: r['label'] ?? '',
        level: r['level'] ?? '',
        color: Color(r['color'] ?? 0xFF2E7D32),
      )).toList()
          : [],
      recommendations: json['recommendations'] != null
          ? List<String>.from(json['recommendations'])
          : [],
      certification: json['certification'] != null
          ? TechnicianCertificationModel.fromJson(json['certification'])
          : null,
      evidenceUrls: json['evidenceUrls'] != null
          ? List<String>.from(json['evidenceUrls'])
          : [],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'technicianId': technicianId,
      'technicianName': technicianName,
      'producerId': producerId,
      'producerName': producerName,
      'farmId': farmId,
      'farmName': farmName,
      'lotId': lotId,
      'lotName': lotName,
      'location': location,
      'diagnosisDate': diagnosisDate.toIso8601String(),
      'healthScore': healthScore,
      'status': status,
      'categories': categories.map((c) => {
        'label': c.label,
        'value': c.value,
        'color': c.color.value,
      }).toList(),
      'issues': issues.map((i) => {
        'title': i.title,
        'level': i.level,
        'priority': i.priority,
        'priorityColor': i.priorityColor.value,
      }).toList(),
      'risks': risks.map((r) => {
        'label': r.label,
        'level': r.level,
        'color': r.color.value,
      }).toList(),
      'recommendations': recommendations,
      'certification': certification?.toJson(),
      'evidenceUrls': evidenceUrls,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  TechnicianDiagnosisModel copyWith({
    String? id,
    String? technicianId,
    String? technicianName,
    String? producerId,
    String? producerName,
    String? farmId,
    String? farmName,
    String? lotId,
    String? lotName,
    String? location,
    DateTime? diagnosisDate,
    double? healthScore,
    String? status,
    List<DiagnosisCategory>? categories,
    List<DiagnosisIssue>? issues,
    List<DiagnosisRisk>? risks,
    List<String>? recommendations,
    TechnicianCertificationModel? certification,
    List<String>? evidenceUrls,
    DateTime? createdAt,
  }) {
    return TechnicianDiagnosisModel(
      id: id ?? this.id,
      technicianId: technicianId ?? this.technicianId,
      technicianName: technicianName ?? this.technicianName,
      producerId: producerId ?? this.producerId,
      producerName: producerName ?? this.producerName,
      farmId: farmId ?? this.farmId,
      farmName: farmName ?? this.farmName,
      lotId: lotId ?? this.lotId,
      lotName: lotName ?? this.lotName,
      location: location ?? this.location,
      diagnosisDate: diagnosisDate ?? this.diagnosisDate,
      healthScore: healthScore ?? this.healthScore,
      status: status ?? this.status,
      categories: categories ?? this.categories,
      issues: issues ?? this.issues,
      risks: risks ?? this.risks,
      recommendations: recommendations ?? this.recommendations,
      certification: certification ?? this.certification,
      evidenceUrls: evidenceUrls ?? this.evidenceUrls,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class DiagnosisCategory {
  final String label;
  final int value;
  final Color color;

  DiagnosisCategory({
    required this.label,
    required this.value,
    required this.color,
  });
}

class DiagnosisIssue {
  final String title;
  final String level;
  final String priority;
  final Color priorityColor;

  DiagnosisIssue({
    required this.title,
    required this.level,
    required this.priority,
    required this.priorityColor,
  });
}

class DiagnosisRisk {
  final String label;
  final String level;
  final Color color;

  DiagnosisRisk({
    required this.label,
    required this.level,
    required this.color,
  });
}