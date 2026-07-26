import 'package:flutter/material.dart';

class TechnicianModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String specialty;
  final String status;
  final DateTime registeredAt;
  final List<String> assignedProducers;
  final int farmsCount;
  final int activeClients;
  final double averageRating;
  final String? photoUrl;
  final String? location;

  // ✅ NUEVOS CAMPOS
  final int totalVisits;
  final int pendingVisits;
  final int recommendations;
  final int certifications;
  final double performance; // 0-100%

  TechnicianModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.specialty = 'General',
    this.status = 'Activo',
    required this.registeredAt,
    this.assignedProducers = const [],
    this.farmsCount = 0,
    this.activeClients = 0,
    this.averageRating = 0,
    this.photoUrl,
    this.location,
    this.totalVisits = 0,
    this.pendingVisits = 0,
    this.recommendations = 0,
    this.certifications = 0,
    this.performance = 0,
  });

  String get statusText {
    switch (status) {
      case 'Activo': return 'Activo';
      case 'Inactivo': return 'Inactivo';
      case 'Pendiente': return 'Pendiente';
      default: return 'Activo';
    }
  }

  Color get statusColor {
    switch (status) {
      case 'Activo': return const Color(0xFF2E7D32);
      case 'Inactivo': return const Color(0xFFD32F2F);
      case 'Pendiente': return const Color(0xFFF57C00);
      default: return const Color(0xFF2E7D32);
    }
  }

  TechnicianModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? specialty,
    String? status,
    DateTime? registeredAt,
    List<String>? assignedProducers,
    int? farmsCount,
    int? activeClients,
    double? averageRating,
    String? photoUrl,
    String? location,
  }) {
    return TechnicianModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      specialty: specialty ?? this.specialty,
      status: status ?? this.status,
      registeredAt: registeredAt ?? this.registeredAt,
      assignedProducers: assignedProducers ?? this.assignedProducers,
      farmsCount: farmsCount ?? this.farmsCount,
      activeClients: activeClients ?? this.activeClients,
      averageRating: averageRating ?? this.averageRating,
      photoUrl: photoUrl ?? this.photoUrl,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'specialty': specialty,
      'status': status,
      'registeredAt': registeredAt.toIso8601String(),
      'assignedProducers': assignedProducers,
      'farmsCount': farmsCount,
      'activeClients': activeClients,
      'averageRating': averageRating,
      'photoUrl': photoUrl,
      'location': location,
    };
  }

  factory TechnicianModel.fromJson(Map<String, dynamic> json) {
    return TechnicianModel(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      phone: json['phone'],
      specialty: json['specialty'] ?? 'General',
      status: json['status'] ?? 'Activo',
      registeredAt: DateTime.parse(json['registeredAt']),
      assignedProducers: List<String>.from(json['assignedProducers'] ?? []),
      farmsCount: json['farmsCount'] ?? 0,
      activeClients: json['activeClients'] ?? 0,
      averageRating: json['averageRating']?.toDouble() ?? 0,
      photoUrl: json['photoUrl'],
      location: json['location'],
    );
  }
}