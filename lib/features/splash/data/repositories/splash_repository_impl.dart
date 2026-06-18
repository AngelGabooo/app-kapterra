import 'package:kaabcafe/features/splash/domain/entities/splash_entity.dart';
import 'package:kaabcafe/features/splash/domain/repositories/splash_repository.dart';
import 'package:kaabcafe/features/splash/data/datasources/splash_local_datasource.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashRepositoryImpl implements SplashRepository {
  final SplashLocalDataSource localDataSource;

  SplashRepositoryImpl({required this.localDataSource});

  @override
  Future<SplashEntity> getInitialData() async {
    final isFirstLaunch = await localDataSource.isFirstLaunch();
    final isLoggedIn = await localDataSource.hasAuthToken();
    final packageInfo = await PackageInfo.fromPlatform();

    return SplashEntity(
      isFirstLaunch: isFirstLaunch,
      isLoggedIn: isLoggedIn,
      version: packageInfo.version,
    );
  }

  @override
  Future<void> setFirstLaunch(bool value) async {
    await localDataSource.setFirstLaunch(value);
  }

  @override
  Future<bool> checkAuthStatus() async {
    return await localDataSource.hasAuthToken();
  }
}