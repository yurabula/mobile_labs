import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/data/repositories/UserRepositoryInterface.dart';
import 'package:flutter_application_1/models/UserModel.dart';

class AuthService extends ChangeNotifier {
  final UserRepositoryInterface _userRepository;

  bool _isLoading = false;
  bool _isAuthenticated = false;
  UserModel? _currentUser;
  String? _errorMessage;

  AuthService(this._userRepository) {
    _checkAuth();
  }

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;

  Future<void> _checkAuth() async {
    _isLoading = true;
    notifyListeners();

    _isAuthenticated = await _userRepository.isUserLoggedIn();
    if (_isAuthenticated) {
      _currentUser = await _userRepository.getUser();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _userRepository.login(email, password);
      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Невірний email або пароль';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Помилка авторизації: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(UserModel user) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _userRepository.saveUser(user);
      _currentUser = user;
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Помилка реєстрації: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _userRepository.logout();
    _isAuthenticated = false;
    _currentUser = null;

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateUser(UserModel user) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _userRepository.updateUser(user);
      if (result) {
        _currentUser = user;
      }
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _errorMessage = 'Помилка оновлення даних: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _userRepository.deleteUser();
      if (result) {
        _currentUser = null;
        _isAuthenticated = false;
      }
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _errorMessage = 'Помилка видалення акаунту: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
