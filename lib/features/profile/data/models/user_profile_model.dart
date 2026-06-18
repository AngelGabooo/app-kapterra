class UserProfileModel {
  final String fullName;
  final String userType;
  final String location;
  final String memberSince;
  final int farmsCount;
  final int activeLots;
  final int activitiesCount;
  final double totalCosts;
  final double totalProduction;
  final double avgProductivity;
  final double digitalizationLevel;
  final String level;
  final String email;
  final String phone;
  final String municipality;
  final String state;
  final String yearsExperience;
  final String cooperative;

  UserProfileModel({
    required this.fullName,
    required this.userType,
    required this.location,
    required this.memberSince,
    required this.farmsCount,
    required this.activeLots,
    required this.activitiesCount,
    required this.totalCosts,
    required this.totalProduction,
    required this.avgProductivity,
    required this.digitalizationLevel,
    required this.level,
    required this.email,
    required this.phone,
    required this.municipality,
    required this.state,
    required this.yearsExperience,
    required this.cooperative,
  });
}