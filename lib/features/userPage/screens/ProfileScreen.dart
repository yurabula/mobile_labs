import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/widgets/CustomButton.dart';
import 'package:flutter_application_1/features/userPage/widgets/ProfileInfoItem.dart';
import 'package:flutter_application_1/data/repositories/LocalUserRepository.dart';
import 'package:flutter_application_1/domain/entities/User.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  final _repository = LocalUserRepository();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _repository.getUser();
    setState(() {
      _user = user;
    });
  }

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
          child: Container(
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
                  child: Icon(Icons.person, size: 48, color: Color(0xFF009FFD)),
                ),
                const SizedBox(height: 12),
                Text(
                  _user?.name ?? 'Loading...',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _user?.email ?? '',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 16),
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
                  text: 'Edit Profile',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/edit_profile',
                    ).then((_) => _loadUser());
                  },
                  isPrimary: true,
                ),
                const SizedBox(height: 12),
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
        ),
      ),
    );
  }
}
