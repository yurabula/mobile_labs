import 'package:flutter/cupertino.dart';Add commentMore actions
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab1/domain/entities/user.dart';
import 'package:lab1/services/auth_service.dart';

part 'states/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileLoading()) {
    loadUserData();
  }

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  Future<void> loadUserData() async {
    emit(ProfileLoading());

    try {
      final user = await AuthService.getCurrentUser();

      if (user != null) {
        nameController.text = user.name;
        emailController.text = user.email;
        emit(ProfileLoaded(user: user));
      } else {
        emit(ProfileError('No user found'));
      }
    } catch (e) {
      emit(ProfileError('Failed to load user: $e'));
    }
  }

  void toggleEdit(bool enable) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(currentState.copyWith(isEditing: enable));
    }
  }

  Future<void> updateUserData() async {
    if (state is! ProfileLoaded) return;
    final current = (state as ProfileLoaded).user;

    emit(ProfileLoading());

    try {
      final updated = User(
        email: emailController.text.trim(),
        name: nameController.text.trim(),
        password: current.password,
      );
      await AuthService.updateUser(updated);
      emit(ProfileLoaded(user: updated));
    } catch (e) {
      emit(ProfileError('Failed to update user: $e'));
    }
  }
}