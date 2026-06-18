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