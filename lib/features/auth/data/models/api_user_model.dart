// lib/features/auth/data/models/api_user_model.dart
class ApiUserModel {
  final int id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? rol;
  final DateTime? fechaCreacion;

  ApiUserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.rol,
    this.fechaCreacion,
  });

  factory ApiUserModel.fromJson(Map<String, dynamic> json) {
    return ApiUserModel(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? json['fullname'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? json['telefono'] ?? '',
      rol: json['rol'],
      fechaCreacion: json['fecha_creacion'] != null
          ? DateTime.tryParse(json['fecha_creacion'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'rol': rol,
    };
  }
}