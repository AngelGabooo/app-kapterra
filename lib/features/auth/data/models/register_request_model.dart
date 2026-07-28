// lib/features/auth/data/models/register_request_model.dart
class RegisterRequestModel {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
  final bool acceptTerms;
  final String? rol; // ✅ Agregar campo rol

  RegisterRequestModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.acceptTerms,
    this.rol,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'acceptTerms': acceptTerms,
      if (rol != null) 'rol': rol, // ✅ Solo incluir si no es null
    };
  }
}