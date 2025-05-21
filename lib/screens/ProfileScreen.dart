import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/CustomButton.dart';
import 'package:flutter_application_1/widgets/ProfileInfoItem.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xFFD6EFFF),
                      child: Icon(
                        Icons.person,
                        size: 48,
                        color: Color(0xFF009FFD),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Yura',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const ProfileInfoItem(
                      icon: Icons.account_circle,
                      title: 'Account',
                      subtitle: 'Personal details',
                    ),
                    const Divider(height: 1),
                    const ProfileInfoItem(
                      icon: Icons.devices,
                      title: 'My Devices',
                      subtitle: 'Air conditioners, sensors',
                    ),
                    const Divider(height: 1),
                    const SizedBox(height: 30),
                    CustomButton(
                      text: 'Log Out',
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      isPrimary: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
