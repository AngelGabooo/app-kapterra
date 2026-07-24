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

  // ✅ CAMPOS ADICIONALES PARA EDITAR LOTE
  final String? description;
  final int? altitude;
  final int? age;
  final int? density;
  final List<String>? imageUrls;

  LotModel({
    required this.id,
    required this.name,
    required this.variety,
    required this.estimatedProduction,
    required this.area,
    required this.status,
    required this.treesCount,
    this.description,
    this.altitude,
    this.age,
    this.density,
    this.imageUrls,
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

  // ✅ copyWith ACTUALIZADO con todos los campos
  LotModel copyWith({
    String? id,
    String? name,
    String? variety,
    double? estimatedProduction,
    double? area,
    LotStatus? status,
    int? treesCount,
    String? description,
    int? altitude,
    int? age,
    int? density,
    List<String>? imageUrls,
  }) {
    return LotModel(
      id: id ?? this.id,
      name: name ?? this.name,
      variety: variety ?? this.variety,
      estimatedProduction: estimatedProduction ?? this.estimatedProduction,
      area: area ?? this.area,
      status: status ?? this.status,
      treesCount: treesCount ?? this.treesCount,
      description: description ?? this.description,
      altitude: altitude ?? this.altitude,
      age: age ?? this.age,
      density: density ?? this.density,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }

  // ✅ toJson ACTUALIZADO
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'variety': variety,
      'estimatedProduction': estimatedProduction,
      'area': area,
      'status': status.index,
      'treesCount': treesCount,
      'description': description,
      'altitude': altitude,
      'age': age,
      'density': density,
      'imageUrls': imageUrls,
    };
  }

  // ✅ fromJson ACTUALIZADO
  factory LotModel.fromJson(Map<String, dynamic> json) {
    return LotModel(
      id: json['id'],
      name: json['name'],
      variety: json['variety'],
      estimatedProduction: json['estimatedProduction']?.toDouble() ?? 0.0,
      area: json['area']?.toDouble() ?? 0.0,
      status: LotStatus.values[json['status'] ?? 0],
      treesCount: json['treesCount'] ?? 0,
      description: json['description'],
      altitude: json['altitude'],
      age: json['age'],
      density: json['density'],
      imageUrls: json['imageUrls'] != null
          ? List<String>.from(json['imageUrls'])
          : null,
    );
  }
}