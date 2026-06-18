class SetupProfileModel {
  String fullName;
  String phoneNumber;
  String email;
  String municipality;
  String region;
  String yearsExperience;
  String hectares;
  String coffeeVariety;
  bool belongsToCooperative;
  String? profileImagePath;

  SetupProfileModel({
    this.fullName = '',
    this.phoneNumber = '',
    this.email = '',
    this.municipality = '',
    this.region = '',
    this.yearsExperience = '',
    this.hectares = '',  // ✅ Corregido: hectares (no hectareas)
    this.coffeeVariety = '',
    this.belongsToCooperative = false,
    this.profileImagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'municipality': municipality,
      'region': region,
      'yearsExperience': yearsExperience,
      'hectares': hectares,
      'coffeeVariety': coffeeVariety,
      'belongsToCooperative': belongsToCooperative,
      'profileImagePath': profileImagePath,
    };
  }

  SetupProfileModel copyWith({
    String? fullName,
    String? phoneNumber,
    String? email,
    String? municipality,
    String? region,
    String? yearsExperience,
    String? hectares,
    String? coffeeVariety,
    bool? belongsToCooperative,
    String? profileImagePath,
  }) {
    return SetupProfileModel(
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      municipality: municipality ?? this.municipality,
      region: region ?? this.region,
      yearsExperience: yearsExperience ?? this.yearsExperience,
      hectares: hectares ?? this.hectares,
      coffeeVariety: coffeeVariety ?? this.coffeeVariety,
      belongsToCooperative: belongsToCooperative ?? this.belongsToCooperative,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }
}