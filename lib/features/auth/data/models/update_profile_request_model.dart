// lib/features/auth/data/models/update_profile_request_model.dart
class UpdateProfileRequestModel {
  final String email;
  final String rol;
  final String fullName;
  final String phoneNumber;

  UpdateProfileRequestModel({
    required this.email,
    required this.rol,
    required this.fullName,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'rol': rol,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
    };
  }
}