import 'package:flutter/material.dart';

enum UserType {
  producer,
  technician,
  cooperative,
  buyer,
}

extension UserTypeExtension on UserType {
  String get title {
    switch (this) {
      case UserType.producer:
        return 'Productor';
      case UserType.technician:
        return 'Técnico Agrícola';
      case UserType.cooperative:
        return 'Cooperativa';
      case UserType.buyer:
        return 'Comprador';
    }
  }

  String get description {
    switch (this) {
      case UserType.producer:
        return 'Registra fincas, actividades, costos y genera trazabilidad para tus lotes.';
      case UserType.technician:
        return 'Monitorea productores, emite recomendaciones y da seguimiento técnico.';
      case UserType.cooperative:
        return 'Administra productores, consolida producción y genera reportes institucionales.';
      case UserType.buyer:
        return 'Encuentra lotes trazables y conecta directamente con productores.';
    }
  }

  IconData get icon {
    switch (this) {
      case UserType.producer:
        return Icons.agriculture;
      case UserType.technician:
        return Icons.science;
      case UserType.cooperative:
        return Icons.apartment;
      case UserType.buyer:
        return Icons.shopping_bag;
    }
  }
}

class UserTypeModel {
  final UserType type;
  bool isSelected;

  UserTypeModel({
    required this.type,
    this.isSelected = false,
  });

  UserTypeModel copyWith({
    UserType? type,
    bool? isSelected,
  }) {
    return UserTypeModel(
      type: type ?? this.type,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}