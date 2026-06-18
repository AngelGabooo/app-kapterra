class ForgotPasswordModel {
  final String email;
  final bool isSuccess;
  final String? message;

  ForgotPasswordModel({
    required this.email,
    this.isSuccess = false,
    this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'isSuccess': isSuccess,
      'message': message,
    };
  }

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordModel(
      email: json['email'] ?? '',
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'],
    );
  }

  ForgotPasswordModel copyWith({
    String? email,
    bool? isSuccess,
    String? message,
  }) {
    return ForgotPasswordModel(
      email: email ?? this.email,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
    );
  }
}