// lib/features/costs/data/models/cost_model.dart
import 'package:flutter/material.dart';

enum CostCategory {
  labor,
  fertilizer,
  pestControl,
  transportation,
  fuel,
  maintenance,
  other,
}

extension CostCategoryExtension on CostCategory {
  String get title {
    switch (this) {
      case CostCategory.labor:
        return 'Mano de obra';
      case CostCategory.fertilizer:
        return 'Fertilizantes';
      case CostCategory.pestControl:
        return 'Control de plagas';
      case CostCategory.transportation:
        return 'Transporte';
      case CostCategory.fuel:
        return 'Combustible';
      case CostCategory.maintenance:
        return 'Mantenimiento';
      case CostCategory.other:
        return 'Otros';
    }
  }

  IconData get icon {
    switch (this) {
      case CostCategory.labor:
        return Icons.people;
      case CostCategory.fertilizer:
        return Icons.spa;
      case CostCategory.pestControl:
        return Icons.bug_report;
      case CostCategory.transportation:
        return Icons.local_shipping;
      case CostCategory.fuel:
        return Icons.local_gas_station;
      case CostCategory.maintenance:
        return Icons.build;
      case CostCategory.other:
        return Icons.category;
    }
  }

  Color get color {
    switch (this) {
      case CostCategory.labor:
        return const Color(0xFF1976D2);
      case CostCategory.fertilizer:
        return const Color(0xFF2E7D32);
      case CostCategory.pestControl:
        return const Color(0xFFF57C00);
      case CostCategory.transportation:
        return const Color(0xFFD4A017);
      case CostCategory.fuel:
        return const Color(0xFF9C27B0);
      case CostCategory.maintenance:
        return const Color(0xFF607D8B);
      case CostCategory.other:
        return const Color(0xFF757575);
    }
  }
}

class CostModel {
  final String id;
  final String concept;
  final CostCategory category;
  final double amount;
  final DateTime date;
  final String lotId;
  final String lotName;
  final String? provider;
  final String? invoiceUrl;
  final String? description;
  final String responsible;
  final bool hasInvoice;

  CostModel({
    required this.id,
    required this.concept,
    required this.category,
    required this.amount,
    required this.date,
    required this.lotId,
    required this.lotName,
    this.provider,
    this.invoiceUrl,
    this.description,
    required this.responsible,
    this.hasInvoice = false,
  });

  String get formattedAmount => '\$${amount.toStringAsFixed(2)} MXN';
}