import 'package:flutter_bloc/flutter_bloc.dart';Add commentMore actions
import 'package:lab1/services/auth_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, loading, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;

  AuthState(this.status, {this.errorMessage});
}

class AuthCubit extends Cubit<AuthState> {

  AuthCubit() : super(AuthState(AuthStatus.unknown));

  Future<void> checkLoginStatus() async {
    emit(AuthState(AuthStatus.loading));
    final loggedIn = await AuthService.isUserLoggedIn();
    if (loggedIn) {
      emit(AuthState(AuthStatus.authenticated));
    } else {
      emit(AuthState(AuthStatus.unauthenticated));
    }
  }

  Future<void> login(String username, String password) async {
    emit(AuthState(AuthStatus.loading));
    final success = await AuthService.validateCredentials(username, password);
    if (success) {
      await AuthService.saveCredentials(username, password);
      await AuthService.setLoggedIn(true);
      emit(AuthState(AuthStatus.authenticated));
    } else {
      emit(AuthState(AuthStatus.error, errorMessage: 'Invalid credentials'));
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    emit(AuthState(AuthStatus.unauthenticated));
  }
}