import 'package:flutter/material.dart';

enum AlertPriority { high, medium, low }

class AlertModel {
  final String title;
  final String description;
  final AlertPriority priority;
  final DateTime date;
  final IconData icon;

  AlertModel({
    required this.title,
    required this.description,
    required this.priority,
    required this.date,
    required this.icon,
  });

  Color get priorityColor {
    switch (priority) {
      case AlertPriority.high:
        return const Color(0xFFD32F2F);
      case AlertPriority.medium:
        return const Color(0xFFF57C00);
      case AlertPriority.low:
        return const Color(0xFF2E7D32);
    }
  }
}