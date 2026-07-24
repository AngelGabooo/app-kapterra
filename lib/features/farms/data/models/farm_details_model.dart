// lib/features/farms/data/models/farm_details_model.dart

import 'package:flutter/material.dart';

enum FarmHealthStatus { healthy, attention, risk }

class FarmDetailsModel {
  final String id;
  final String name;
  final String location;
  final double hectares;
  final int lots;
  final double productivity;
  final FarmHealthStatus status;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final int altitude;

  // ✅ CAMPOS ADICIONALES PARA EDITAR FINCA
  final int? establishmentYear;
  final String? mainVariety;
  final String? productionSystem;
  final List<String>? certifications;

  FarmDetailsModel({
    required this.id,
    required this.name,
    required this.location,
    required this.hectares,
    required this.lots,
    required this.productivity,
    required this.status,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    this.altitude = 0,
    this.establishmentYear,
    this.mainVariety,
    this.productionSystem,
    this.certifications,
  });

  // 🚀 MÉTODO COPYWITH ACTUALIZADO
  FarmDetailsModel copyWith({
    String? id,
    String? name,
    String? location,
    double? hectares,
    int? lots,
    double? productivity,
    FarmHealthStatus? status,
    String? imageUrl,
    double? latitude,
    double? longitude,
    int? altitude,
    int? establishmentYear,
    String? mainVariety,
    String? productionSystem,
    List<String>? certifications,
  }) {
    return FarmDetailsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      hectares: hectares ?? this.hectares,
      lots: lots ?? this.lots,
      productivity: productivity ?? this.productivity,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      establishmentYear: establishmentYear ?? this.establishmentYear,
      mainVariety: mainVariety ?? this.mainVariety,
      productionSystem: productionSystem ?? this.productionSystem,
      certifications: certifications ?? this.certifications,
    );
  }

  Color get statusColor {
    switch (status) {
      case FarmHealthStatus.healthy:
        return const Color(0xFF2E7D32);
      case FarmHealthStatus.attention:
        return const Color(0xFFF57C00);
      case FarmHealthStatus.risk:
        return const Color(0xFFD32F2F);
    }
  }

  String get statusText {
    switch (status) {
      case FarmHealthStatus.healthy:
        return 'Saludable';
      case FarmHealthStatus.attention:
        return 'Atención';
      case FarmHealthStatus.risk:
        return 'Riesgo';
    }
  }

  double get productivityPercentage {
    return (productivity / 1500).clamp(0.0, 1.0);
  }

  // ✅ Método toJson para guardar
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'hectares': hectares,
      'lots': lots,
      'productivity': productivity,
      'status': status.index,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'establishmentYear': establishmentYear,
      'mainVariety': mainVariety,
      'productionSystem': productionSystem,
      'certifications': certifications,
    };
  }

  // ✅ Método fromJson para cargar
  factory FarmDetailsModel.fromJson(Map<String, dynamic> json) {
    return FarmDetailsModel(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      hectares: json['hectares']?.toDouble() ?? 0.0,
      lots: json['lots'] ?? 0,
      productivity: json['productivity']?.toDouble() ?? 0.0,
      status: FarmHealthStatus.values[json['status'] ?? 0],
      imageUrl: json['imageUrl'] ?? 'assets/img/default_farm.png',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      altitude: json['altitude'] ?? 0,
      establishmentYear: json['establishmentYear'],
      mainVariety: json['mainVariety'],
      productionSystem: json['productionSystem'],
      certifications: json['certifications'] != null
          ? List<String>.from(json['certifications'])
          : null,
    );
  }
}