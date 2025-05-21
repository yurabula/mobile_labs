import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';

  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<bool> isLoggedIn() async {
    return isUserLoggedIn();
  }

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, value);
  }

  static Future<void> saveCredentials(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_passwordKey, password);
  }

  static Future<String?> getSavedUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  static Future<String?> getSavedPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_passwordKey);
  }

  static Future<bool> validateCredentials(
    String username,
    String password,
  ) async {
    final savedUsername = await getSavedUsername();
    final savedPassword = await getSavedPassword();

    if (savedUsername == null || savedPassword == null) {
      return false;
    }

    return username == savedUsername && password == savedPassword;
  }

  static Future<bool> loginWithSavedCredentials() async {
    final username = await getSavedUsername();
    final password = await getSavedPassword();

    if (username != null && password != null) {
      await setLoggedIn(true);
      return true;
    }

    return false;
  }

  static Future<void> logout({bool clearCredentials = false}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);

    if (clearCredentials) {
      await prefs.remove(_usernameKey);
      await prefs.remove(_passwordKey);
    }
  }
}
