import 'package:flutter/material.dart';

class ActivityModel {
  final String title;
  final String description;
  final DateTime date;
  final IconData icon;

  ActivityModel({
    required this.title,
    required this.description,
    required this.date,
    required this.icon,
  });
}