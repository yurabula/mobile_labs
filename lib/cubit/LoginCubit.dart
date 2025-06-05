import 'package:flutter_bloc/flutter_bloc.dart';Add commentMore actions
import 'package:lab1/cubit/states/login_state.dart';
import 'package:lab1/services/auth_service.dart';
import 'package:lab1/services/connection_service.dart';

class LoginCubit extends Cubit<LoginState> {
  final ConnectivityService _connectivityService;

  LoginCubit(this._connectivityService) : super(LoginInitial());

  Future<void> login(String email, String password, bool rememberMe) async {
    emit(LoginLoading());

    final status = await _connectivityService.getCurrentStatus();
    if (status == ConnectionStatus.offline) {
      emit(LoginFailure('No Internet connection.'));
      return;
    }

    // AuthService.validateCredentials повертає Future<bool>
    final success = await AuthService.validateCredentials(email, password);
    if (success) {
      if (rememberMe) {
        await AuthService.saveCredentials(email, password);
        await AuthService.setLoggedIn(true);
      }
      emit(LoginSuccess());        // <-- без аргументів
    } else {
      emit(LoginFailure('Invalid credentials'));
    }
  }

  Future<void> checkAutoLogin() async {
    final loggedIn = await AuthService.isUserLoggedIn();
    if (!loggedIn) return;

    final success = await AuthService.loginWithSavedCredentials();
    if (success) {
      emit(LoginSuccess());        // <-- без аргументів
    }
  }
}