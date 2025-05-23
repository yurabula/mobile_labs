import 'package:flutter_application_1/data/local/LocalStorageInterface.dart';
import 'package:flutter_application_1/data/repositories/UserRepositoryInterface.dart';
import 'package:flutter_application_1/models/UserModel.dart';
import 'package:uuid/uuid.dart';

class UserRepository implements UserRepositoryInterface {
  final LocalStorageInterface _localStorage;
  final String _userKey = 'current_user';
  final String _isLoggedInKey = 'is_logged_in';

  UserRepository(this._localStorage);

  @override
  Future<UserModel?> getUser() async {
    final userData = await _localStorage.getMap(_userKey);
    if (userData != null) {
      return UserModel.fromJson(userData);
    }
    return null;
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await _localStorage.saveMap(_userKey, user.toJson());
    await _localStorage.saveBool(_isLoggedInKey, true);
  }

  @override
  Future<bool> updateUser(UserModel user) async {
    final currentUser = await getUser();
    if (currentUser == null) return false;

    await _localStorage.saveMap(_userKey, user.toJson());
    return true;
  }

  @override
  Future<bool> deleteUser() async {
    final result = await _localStorage.remove(_userKey);
    await _localStorage.saveBool(_isLoggedInKey, false);
    return result;
  }

  @override
  Future<bool> isUserLoggedIn() async {
    return await _localStorage.getBool(_isLoggedInKey) ?? false;
  }

  @override
  Future<void> logout() async {
    await _localStorage.saveBool(_isLoggedInKey, false);
  }

  @override
  Future<UserModel?> login(String email, String password) async {
    final user = await getUser();
    if (user != null && user.email == email && user.password == password) {
      await _localStorage.saveBool(_isLoggedInKey, true);
      return user;
    }
    return null;
  }

  Future<bool> register(UserModel user) async {
    final userWithId = user.copyWith(id: const Uuid().v4());
    await saveUser(userWithId);
    return true;
  }
}
