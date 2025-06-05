import 'package:flutter_bloc/flutter_bloc.dart';Add commentMore actions
import 'package:lab1/cubit/states/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(const RegisterState());

  void fullNameChanged(String value) {
    emit(state.copyWith(fullName: value));
    _validateForm();
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value));
    _validateForm();
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value));
    _validateForm();
  }

  void confirmPasswordChanged(String value) {
    emit(state.copyWith(confirmPassword: value));
    _validateForm();
  }

  void _validateForm() {
    final isValid = state.fullName.isNotEmpty &&
        !RegExp(r'[0-9]').hasMatch(state.fullName) &&
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(state.email) &&
        state.password.length >= 6 &&
        state.password == state.confirmPassword;

    emit(state.copyWith(isFormValid: isValid));
  }

  Future<void> submit() async {
    if (!state.isFormValid) return;

    emit(state.copyWith(isSubmitting: true));

    try {

      emit(state.copyWith(
        isSubmitting: false,
      ),);
      return;

    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Error during registration: $e',
      ),);
    }
  }
}