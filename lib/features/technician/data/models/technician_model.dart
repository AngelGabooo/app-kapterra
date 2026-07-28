// lib/features/technician/data/models/technician_model.dart
import 'package:flutter/material.dart';

enum ProducerStatus {
  excellent,
  requiresAttention,
  risk,
}

extension ProducerStatusExtension on ProducerStatus {
  String get label {
    switch (this) {
      case ProducerStatus.excellent:
        return 'Excelente';
      case ProducerStatus.requiresAttention:
        return 'Requiere seguimiento';
      case ProducerStatus.risk:
        return 'Riesgo';
    }
  }

  Color get color {
    switch (this) {
      case ProducerStatus.excellent:
        return const Color(0xFF2E7D32);
      case ProducerStatus.requiresAttention:
        return const Color(0xFFF57C00);
      case ProducerStatus.risk:
        return const Color(0xFFD32F2F);
    }
  }
}

class TechnicianProducerModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String location;
  final double production;
  final double traceability;
  final ProducerStatus status;
  final String lastVisit;
  final String? farmName;
  final String? lotName;

  TechnicianProducerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.production,
    required this.traceability,
    required this.status,
    required this.lastVisit,
    this.farmName,
    this.lotName,
  });

  TechnicianProducerModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? location,
    double? production,
    double? traceability,
    ProducerStatus? status,
    String? lastVisit,
    String? farmName,
    String? lotName,
  }) {
    return TechnicianProducerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      production: production ?? this.production,
      traceability: traceability ?? this.traceability,
      status: status ?? this.status,
      lastVisit: lastVisit ?? this.lastVisit,
      farmName: farmName ?? this.farmName,
      lotName: lotName ?? this.lotName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'production': production,
      'traceability': traceability,
      'status': status.index,
      'lastVisit': lastVisit,
      'farmName': farmName,
      'lotName': lotName,
    };
  }

  factory TechnicianProducerModel.fromJson(Map<String, dynamic> json) {
    return TechnicianProducerModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      location: json['location'],
      production: json['production']?.toDouble() ?? 0,
      traceability: json['traceability']?.toDouble() ?? 0,
      status: ProducerStatus.values[json['status'] ?? 0],
      lastVisit: json['lastVisit'] ?? DateTime.now().toIso8601String().split('T').first,
      farmName: json['farmName'],
      lotName: json['lotName'],
    );
  }
}

class TechnicianVisitModel {
  final String id;
  final String producerName;
  final String location;
  final String time;
  final String objective;
  final bool isUrgent;

  TechnicianVisitModel({
    required this.id,
    required this.producerName,
    required this.location,
    required this.time,
    required this.objective,
    this.isUrgent = false,
  });
}

class TechnicianAlertModel {
  final String id;
  final String title;
  final String description;
  final bool isCritical;
  final DateTime date;

  TechnicianAlertModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCritical,
    required this.date,
  });
}