import '../entities/User.dart';

abstract class UserRepository {
  Future<void> register(User user);
  Future<User?> login(String email, String password);
  Future<User?> getUser();
  Future<void> updateUser(User user);
  Future<void> deleteUser();
}
