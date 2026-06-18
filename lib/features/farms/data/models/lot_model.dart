// lib/features/farms/data/models/lot_model.dart
import 'package:flutter/material.dart';

enum LotStatus { healthy, attention, risk }

class LotModel {
  final String id;
  final String name;
  final String variety;
  final double estimatedProduction;
  final double area;
  final LotStatus status;
  final int treesCount;

  LotModel({
    required this.id,
    required this.name,
    required this.variety,
    required this.estimatedProduction,
    required this.area,
    required this.status,
    required this.treesCount,
  });

  Color get statusColor {
    switch (status) {
      case LotStatus.healthy:
        return const Color(0xFF2E7D32);
      case LotStatus.attention:
        return const Color(0xFFF57C00);
      case LotStatus.risk:
        return const Color(0xFFD32F2F);
    }
  }

  String get statusText {
    switch (status) {
      case LotStatus.healthy:
        return 'Saludable';
      case LotStatus.attention:
        return 'Atención';
      case LotStatus.risk:
        return 'Riesgo';
    }
  }
}