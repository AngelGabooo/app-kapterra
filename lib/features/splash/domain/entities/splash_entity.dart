class SplashEntity {
  final bool isFirstLaunch;
  final bool isLoggedIn;
  final String version;

  SplashEntity({
    required this.isFirstLaunch,
    required this.isLoggedIn,
    required this.version,
  });

  SplashEntity copyWith({
    bool? isFirstLaunch,
    bool? isLoggedIn,
    String? version,
  }) {
    return SplashEntity(
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      version: version ?? this.version,
    );
  }
}