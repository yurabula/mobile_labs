import 'package:flutter_application_1/data/local/LocalStorageInterface.dart';
import 'package:flutter_application_1/data/local/SharedPrefsStorage.dart';
import 'package:flutter_application_1/data/repositories/UserRepository.dart';
import 'package:flutter_application_1/data/repositories/UserRepositoryInterface.dart';
import 'package:flutter_application_1/services/AuthService.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class DIContainer {
  static Future<List<SingleChildWidget>> provideDependencies() async {
    final localStorage = SharedPrefsStorage();
    await localStorage.init();

    final userRepository = UserRepository(localStorage);
    final authService = AuthService(userRepository);

    return [
      Provider<LocalStorageInterface>.value(value: localStorage),
      Provider<UserRepositoryInterface>.value(value: userRepository),
      ChangeNotifierProvider<AuthService>.value(value: authService),
    ];
  }
}
