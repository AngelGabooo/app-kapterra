class RegisterModel {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
  final bool acceptTerms;

  RegisterModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.acceptTerms = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'acceptTerms': acceptTerms,
    };
  }

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      password: json['password'] ?? '',
      acceptTerms: json['acceptTerms'] ?? false,
    );
  }

  RegisterModel copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? password,
    bool? acceptTerms,
  }) {
    return RegisterModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      acceptTerms: acceptTerms ?? this.acceptTerms,
    );
  }
}