import 'package:flutter/material.dart';

class KPIModel {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final double change;

  KPIModel({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.change = 0,
  });
}