import 'package:flutter_application_1/models/UserModel.dart';

abstract class UserRepositoryInterface {
  Future<UserModel?> getUser();
  Future<void> saveUser(UserModel user);
  Future<bool> updateUser(UserModel user);
  Future<bool> deleteUser();
  Future<bool> isUserLoggedIn();
  Future<void> logout();
  Future<UserModel?> login(String email, String password);
}
