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
  });

  // 🚀 MÉTODO COPYWITH CORREGIDO
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
}