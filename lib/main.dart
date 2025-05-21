import 'package:flutter/material.dart';

import 'package:flutter_application_1/features/home/screens/HomeScreen.dart';
import 'package:flutter_application_1/features/auth/screens/LoginScreen.dart';
import 'package:flutter_application_1/features/userPage/screens/EditProfileScreen.dart';
import 'package:flutter_application_1/features/userPage/screens/ProfileScreen.dart';
import 'package:flutter_application_1/features/auth/screens/RegisterScreen.dart';
import 'package:flutter_application_1/features/settings/screens/SettingsScreen.dart';
import 'package:flutter_application_1/services/AuthService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final bool isLoggedIn = await AuthService.isUserLoggedIn();

  bool autoLoginSuccessful = false;
  if (isLoggedIn) {
    autoLoginSuccessful = await AuthService.loginWithSavedCredentials();
  }

  runApp(MyApp(isLoggedIn: isLoggedIn && autoLoginSuccessful));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({required this.isLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2665B6),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2665B6),
          primary: const Color(0xFF2665B6),
          secondary: const Color(0xFFC1E1FF),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2665B6),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: {
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
