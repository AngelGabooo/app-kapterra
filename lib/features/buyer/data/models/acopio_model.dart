import 'package:flutter/material.dart';

enum AcopioStatus {
  pending,
  inReview,
  classified,
  stored,
  sold,
}

extension AcopioStatusExtension on AcopioStatus {
  String get label {
    switch (this) {
      case AcopioStatus.pending:
        return 'Pendiente';
      case AcopioStatus.inReview:
        return 'En revisión';
      case AcopioStatus.classified:
        return 'Clasificado';
      case AcopioStatus.stored:
        return 'Almacenado';
      case AcopioStatus.sold:
        return 'Vendido';
    }
  }

  Color get color {
    switch (this) {
      case AcopioStatus.pending:
        return const Color(0xFFF57C00);
      case AcopioStatus.inReview:
        return const Color(0xFF1976D2);
      case AcopioStatus.classified:
        return const Color(0xFFD4A017);
      case AcopioStatus.stored:
        return const Color(0xFF2E7D32);
      case AcopioStatus.sold:
        return const Color(0xFF66BB6A);
    }
  }

  IconData get icon {
    switch (this) {
      case AcopioStatus.pending:
        return Icons.hourglass_empty;
      case AcopioStatus.inReview:
        return Icons.visibility;
      case AcopioStatus.classified:
        return Icons.label;
      case AcopioStatus.stored:
        return Icons.inventory;
      case AcopioStatus.sold:
        return Icons.shopping_cart;
    }
  }
}

class AcopioModel {
  final String id;
  final String producerName;
  final String lotName;
  final DateTime date;
  final double grossWeight;
  final double netWeight;
  final double humidity;
  final String classification;
  final AcopioStatus status;
  final String warehouse;
  final String shelf;

  AcopioModel({
    required this.id,
    required this.producerName,
    required this.lotName,
    required this.date,
    required this.grossWeight,
    required this.netWeight,
    required this.humidity,
    required this.classification,
    required this.status,
    required this.warehouse,
    required this.shelf,
  });
}