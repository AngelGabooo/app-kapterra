import 'package:flutter/material.dart';

class FarmActivityModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final IconData icon;

  FarmActivityModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.icon,
  });
}