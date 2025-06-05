import 'package:flutter_bloc/flutter_bloc.dart';Add commentMore actions
import 'package:lab1/cubit/states/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void toggleNotifications(bool value) {
    emit(state.copyWith(notificationsEnabled: value));
  }

  void toggleDarkMode(bool value) {
    emit(state.copyWith(darkModeEnabled: value));
  }

  void saveSettings() {
    // Here you could persist settings to storage if needed.
    // This is just a placeholder for future logic.
  }
}