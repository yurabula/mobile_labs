import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab1/services/auth_service.dart';

class AuthState {
  final bool isLoggedIn;
  final bool isLoading;

  const AuthState({required this.isLoggedIn, required this.isLoading});
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState(isLoggedIn: false, isLoading: true)) {
    _init();
  }

  Future<void> _init() async {
    final loggedIn = await AuthService.isUserLoggedIn();
    final autoLogin = loggedIn && await AuthService.loginWithSavedCredentials();
    emit(AuthState(isLoggedIn: autoLogin, isLoading: false));
  }

  void logout() {
    AuthService.logout();
    emit(const AuthState(isLoggedIn: false, isLoading: false));
  }

  void loginSuccess() {
    emit(const AuthState(isLoggedIn: true, isLoading: false));
  }
}