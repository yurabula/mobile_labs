import 'package:flutter/material.dart';Add commentMore actions
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab1/cubit/states/profile_logic_state.dart';
import 'package:lab1/data/repositories/user_repository_impl.dart';
import 'package:lab1/domain/entities/user.dart';
import 'package:lab1/domain/repositories/user_repository.dart';


class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository _repository;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  ProfileCubit({UserRepository? repository})
      : _repository = repository ?? UserRepositoryImpl(),
        super(ProfileInitial());

  void initialize(User user) {
    nameController.text = user.name;
    emailController.text = user.email;
    passwordController.text = user.password;
    emit(ProfileLoaded(user));
  }

  Future<void> saveChanges(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;

    emit(ProfileSaving());

    final updatedUser = User(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    try {
      await _repository.updateUser(updatedUser);
      emit(ProfileSaved(updatedUser));
    } catch (e) {
      emit(ProfileError('Failed to save changes: $e'));
    }
  }

  Future<void> deleteAccount() async {
    emit(ProfileDeleting());

    try {
      await _repository.deleteUser();
      emit(ProfileDeleted());
    } catch (e) {
      emit(ProfileError('Failed to delete account: $e'));
    }
  }

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}