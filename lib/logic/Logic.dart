import 'package:flutter_application_1/services/AuthService.dart';

class LoginLogic {
  static Future<String?> getSavedUsername() async {
    return await AuthService.getSavedUsername();
  }

  static Future<bool> isLoggedIn() async {
    return await AuthService.isLoggedIn();
  }

  static Future<bool> loginWithSavedCredentials() async {
    return await AuthService.loginWithSavedCredentials();
  }

  static Future<void> saveCredentials(String username, String password) async {
    await AuthService.saveCredentials(username, password);
  }

  static Future<bool> validateCredentials(
    String username,
    String password,
  ) async {
    return await AuthService.validateCredentials(username, password);
  }

  static Future<void> setLoggedIn(bool value) async {
    await AuthService.setLoggedIn(value);
  }
}
