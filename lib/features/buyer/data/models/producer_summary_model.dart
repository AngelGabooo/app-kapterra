// lib/features/buyer/data/models/producer_summary_model.dart

import 'package:flutter/material.dart';

class ProducerSummaryModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String status; // 'Activo', 'Inactivo', 'Pendiente'
  final int farmsCount;
  final int lotsCount;
  final double totalProduction;
  final double averageQuality;
  final String? location;
  final double? latitude;
  final double? longitude;
  final String? photoUrl;

  // ✅ NUEVOS CAMPOS PARA DETALLE DEL PRODUCTOR
  final List<ProducerLotSummary>? lots;
  final List<ProducerFarmSummary>? farms;

  ProducerSummaryModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.status = 'Activo',
    this.farmsCount = 0,
    this.lotsCount = 0,
    this.totalProduction = 0,
    this.averageQuality = 0,
    this.location,
    this.latitude,
    this.longitude,
    this.photoUrl,
    this.lots,
    this.farms,
  });

  ProducerSummaryModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? status,
    int? farmsCount,
    int? lotsCount,
    double? totalProduction,
    double? averageQuality,
    String? location,
    double? latitude,
    double? longitude,
    String? photoUrl,
    List<ProducerLotSummary>? lots,
    List<ProducerFarmSummary>? farms,
  }) {
    return ProducerSummaryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      farmsCount: farmsCount ?? this.farmsCount,
      lotsCount: lotsCount ?? this.lotsCount,
      totalProduction: totalProduction ?? this.totalProduction,
      averageQuality: averageQuality ?? this.averageQuality,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      photoUrl: photoUrl ?? this.photoUrl,
      lots: lots ?? this.lots,
      farms: farms ?? this.farms,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'status': status,
      'farmsCount': farmsCount,
      'lotsCount': lotsCount,
      'totalProduction': totalProduction,
      'averageQuality': averageQuality,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'photoUrl': photoUrl,
      'lots': lots?.map((l) => l.toJson()).toList(),
      'farms': farms?.map((f) => f.toJson()).toList(),
    };
  }

  factory ProducerSummaryModel.fromJson(Map<String, dynamic> json) {
    return ProducerSummaryModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      status: json['status'] ?? 'Activo',
      farmsCount: json['farmsCount'] ?? 0,
      lotsCount: json['lotsCount'] ?? 0,
      totalProduction: json['totalProduction']?.toDouble() ?? 0,
      averageQuality: json['averageQuality']?.toDouble() ?? 0,
      location: json['location'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      photoUrl: json['photoUrl'],
      lots: json['lots'] != null
          ? List<ProducerLotSummary>.from(
          json['lots'].map((l) => ProducerLotSummary.fromJson(l)))
          : null,
      farms: json['farms'] != null
          ? List<ProducerFarmSummary>.from(
          json['farms'].map((f) => ProducerFarmSummary.fromJson(f)))
          : null,
    );
  }
}

// ✅ MODELO DE LOTE PARA PRODUCTOR
class ProducerLotSummary {
  final String id;
  final String name;
  final String variety;
  final double area;
  final double estimatedProduction;
  final String status; // 'Saludable', 'Atención', 'Riesgo'
  final String? farmName;

  ProducerLotSummary({
    required this.id,
    required this.name,
    required this.variety,
    required this.area,
    required this.estimatedProduction,
    required this.status,
    this.farmName,
  });

  Color get statusColor {
    switch (status) {
      case 'Saludable': return const Color(0xFF2E7D32);
      case 'Atención': return const Color(0xFFF57C00);
      case 'Riesgo': return const Color(0xFFD32F2F);
      default: return Colors.grey;
    }
  }

  IconData get statusIcon {
    switch (status) {
      case 'Saludable': return Icons.health_and_safety;
      case 'Atención': return Icons.warning_amber;
      case 'Riesgo': return Icons.dangerous;
      default: return Icons.help_outline;
    }
  }

  ProducerLotSummary copyWith({
    String? id,
    String? name,
    String? variety,
    double? area,
    double? estimatedProduction,
    String? status,
    String? farmName,
  }) {
    return ProducerLotSummary(
      id: id ?? this.id,
      name: name ?? this.name,
      variety: variety ?? this.variety,
      area: area ?? this.area,
      estimatedProduction: estimatedProduction ?? this.estimatedProduction,
      status: status ?? this.status,
      farmName: farmName ?? this.farmName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'variety': variety,
      'area': area,
      'estimatedProduction': estimatedProduction,
      'status': status,
      'farmName': farmName,
    };
  }

  factory ProducerLotSummary.fromJson(Map<String, dynamic> json) {
    return ProducerLotSummary(
      id: json['id'],
      name: json['name'],
      variety: json['variety'],
      area: json['area']?.toDouble() ?? 0,
      estimatedProduction: json['estimatedProduction']?.toDouble() ?? 0,
      status: json['status'] ?? 'Saludable',
      farmName: json['farmName'],
    );
  }
}

// ✅ MODELO DE FINCA PARA PRODUCTOR
class ProducerFarmSummary {
  final String id;
  final String name;
  final double hectares;
  final int lotsCount;
  final String? location;

  ProducerFarmSummary({
    required this.id,
    required this.name,
    required this.hectares,
    required this.lotsCount,
    this.location,
  });

  ProducerFarmSummary copyWith({
    String? id,
    String? name,
    double? hectares,
    int? lotsCount,
    String? location,
  }) {
    return ProducerFarmSummary(
      id: id ?? this.id,
      name: name ?? this.name,
      hectares: hectares ?? this.hectares,
      lotsCount: lotsCount ?? this.lotsCount,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'hectares': hectares,
      'lotsCount': lotsCount,
      'location': location,
    };
  }

  factory ProducerFarmSummary.fromJson(Map<String, dynamic> json) {
    return ProducerFarmSummary(
      id: json['id'],
      name: json['name'],
      hectares: json['hectares']?.toDouble() ?? 0,
      lotsCount: json['lotsCount'] ?? 0,
      location: json['location'],
    );
  }
}