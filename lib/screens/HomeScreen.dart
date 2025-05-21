import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/AcCard.dart';
import 'package:flutter_application_1/widgets/FrostedGlassCard.dart'; // <-- імпорт
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _airConditioners = [
    {'name': 'Living Room', 'temp': 24.5, 'isOn': true, 'mode': 'Cool'},
  ];

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTemperatures();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTemperatures() {
    setState(() {
      for (var ac in _airConditioners) {
        double variation = (DateTime.now().millisecond % 5) / 10;
        if (ac['isOn'] == true) {
          ac['temp'] = (ac['temp'] - 0.1 - variation).clamp(16.0, 30.0);
        } else {
          ac['temp'] = (ac['temp'] + 0.1 + variation).clamp(16.0, 30.0);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3A7BD5), Color(0xFF00D2FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Smart House',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.settings, color: Colors.white),
                          onPressed:
                              () => Navigator.pushNamed(context, '/settings'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.person, color: Colors.white),
                          onPressed:
                              () => Navigator.pushNamed(context, '/profile'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  'Air Conditioners',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _airConditioners.length,
                    itemBuilder: (context, index) {
                      var ac = _airConditioners[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: FrostedGlassCard(
                          child: AcCard(
                            name: ac['name'] as String,
                            temperature: ac['temp'] as double,
                            isOn: ac['isOn'] as bool,
                            mode: ac['mode'] as String,
                            isCelsius: true,
                            onToggle: (value) {
                              setState(() {
                                ac['isOn'] = value;
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
