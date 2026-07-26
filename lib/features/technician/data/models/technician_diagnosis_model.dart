// lib/features/technician/data/models/technician_diagnosis_model.dart

import 'package:flutter/material.dart';

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
  final String? certification;
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