// lib/features/auth/data/models/login_response_model.dart
import 'api_user_model.dart';

class LoginResponseModel {
  final String accessToken;
  final String tokenType;
  final ApiUserModel user;

  LoginResponseModel({
    required this.accessToken,
    required this.tokenType,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['access_token'] ?? '',
      tokenType: json['token_type'] ?? 'bearer',
      user: ApiUserModel.fromJson(json['user'] ?? {}),
    );
  }
}