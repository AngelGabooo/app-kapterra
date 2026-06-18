import 'package:kaabcafe/features/splash/domain/entities/splash_entity.dart';

abstract class SplashRepository {
  Future<SplashEntity> getInitialData();
  Future<void> setFirstLaunch(bool value);
  Future<bool> checkAuthStatus();
}