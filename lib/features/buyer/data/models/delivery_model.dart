import 'package:flutter/material.dart';

class DeliveryModel {
  final String id;
  final String producerName;
  final double quantity;
  final String quality;
  final DateTime date;
  final IconData icon;

  DeliveryModel({
    required this.id,
    required this.producerName,
    required this.quantity,
    required this.quality,
    required this.date,
    required this.icon,
  });
}