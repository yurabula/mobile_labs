import 'package:flutter/material.dart';
import 'package:flutter_application_1/di/DiContainer.dart';
import 'package:flutter_application_1/services/AuthService.dart';
import 'package:flutter_application_1/features/home/screens/HomeScreen.dart';
import 'package:flutter_application_1/features/auth/screens/LoginScreen.dart';
import 'package:flutter_application_1/features/settings/screens/SettingsScreen.dart';
import 'package:flutter_application_1/features/auth/screens/RegisterScreen.dart';
import 'package:flutter_application_1/features/userPage/screens/ProfileScreen.dart';
import 'package:flutter_application_1/features/userPage/screens/EditProfileScreen.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final providers = await DIContainer.provideDependencies();

  runApp(MultiProvider(providers: providers, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лабораторна робота 3',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/home': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/edit_profile': (context) => const EditUserProfilePage(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    if (authService.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (authService.isAuthenticated) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
