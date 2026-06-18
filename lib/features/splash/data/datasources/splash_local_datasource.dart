import 'package:shared_preferences/shared_preferences.dart';

class SplashLocalDataSource {
  static const String _firstLaunchKey = 'is_first_launch';
  static const String _authTokenKey = 'auth_token';

  Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  Future<bool> isFirstLaunch() async {
    final prefs = await _prefs;
    return prefs.getBool(_firstLaunchKey) ?? true;
  }

  Future<void> setFirstLaunch(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_firstLaunchKey, value);
  }

  Future<bool> hasAuthToken() async {
    final prefs = await _prefs;
    final token = prefs.getString(_authTokenKey);
    return token != null && token.isNotEmpty;
  }

  Future<String?> getAuthToken() async {
    final prefs = await _prefs;
    return prefs.getString(_authTokenKey);
  }

  Future<void> saveAuthToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString(_authTokenKey, token);
  }

  Future<void> clearAuthToken() async {
    final prefs = await _prefs;
    await prefs.remove(_authTokenKey);
  }
}