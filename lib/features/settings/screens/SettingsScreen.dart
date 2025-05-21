import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/widgets/CustomButton.dart';
import 'package:flutter_application_1/features/settings/widgets/SettingToggleItem.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _darkMode = false;
  bool _autoSync = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF009FFD), Color(0xFF2A2A72)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              SettingToggleItem(
                title: 'Notifications',
                subtitle: 'Receive temperature alerts',
                value: _notifications,
                onChanged: (val) => setState(() => _notifications = val),
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Save Settings',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings saved')),
                  );
                  Navigator.pop(context);
                },
                isPrimary: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
