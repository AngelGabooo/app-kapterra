import 'package:flutter/material.dart';

enum FarmStatus { healthy, attention, risk }

class FarmSummaryModel {
  final String name;
  final double hectares;
  final double production;
  final FarmStatus status;

  FarmSummaryModel({
    required this.name,
    required this.hectares,
    required this.production,
    required this.status,
  });

  Color get statusColor {
    switch (status) {
      case FarmStatus.healthy:
        return const Color(0xFF2E7D32);
      case FarmStatus.attention:
        return const Color(0xFFF57C00);
      case FarmStatus.risk:
        return const Color(0xFFD32F2F);
    }
  }

  String get statusText {
    switch (status) {
      case FarmStatus.healthy:
        return 'Saludable';
      case FarmStatus.attention:
        return 'Atención';
      case FarmStatus.risk:
        return 'Riesgo';
    }
  }
}