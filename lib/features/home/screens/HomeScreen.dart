import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/home/widgets/AcCard.dart';
import 'package:flutter_application_1/core/widgets/FrostedGlassCard.dart';
import 'package:flutter_application_1/core/widgets/CustomButton.dart';
import 'package:flutter_application_1/services/mqtt_service.dart';
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

  final MqttService _mqttService = MqttService();
  StreamSubscription<double>? _temperatureSubscription;
  double _currentTemperature = 22.0;
  Timer? _timer;
  bool _mqttConnected = false;
  String _connectionStatus = 'Connecting...';

  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _initializeMqtt();

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _updateTemperatures();
    });
  }

  Future<void> _initializeMqtt() async {
    try {
      print('HomeScreen: Initializing MQTT connection...');
      setState(() {
        _connectionStatus = 'Connecting to MQTT...';
      });

      final connected = await _mqttService.connect();

      if (connected) {
        print('HomeScreen: MQTT connected successfully');
        setState(() {
          _mqttConnected = true;
          _connectionStatus = 'Connected';
        });

        _temperatureSubscription = _mqttService.temperatureStream.listen(
          (temperature) {
            print('HomeScreen: Received temperature update: $temperature°C');
            if (mounted) {
              setState(() {
                _currentTemperature = temperature;
              });
            }
          },
          onError: (error) {
            print('HomeScreen: Temperature stream error: $error');
          },
        );

        setState(() {
          _currentTemperature = _mqttService.currentTemperature;
        });
      } else {
        print('HomeScreen: Failed to connect to MQTT');
        setState(() {
          _mqttConnected = false;
          _connectionStatus = 'Connection Failed';
        });
      }
    } catch (e) {
      print('HomeScreen: MQTT initialization error: $e');
      setState(() {
        _mqttConnected = false;
        _connectionStatus = 'Error: $e';
      });
    }
  }

  @override
  void dispose() {
    print('HomeScreen: Disposing resources...');
    _timer?.cancel();
    _temperatureSubscription?.cancel();
    super.dispose();
  }

  void _updateTemperatures() {
    if (_mqttConnected) {
      setState(() {
        for (var ac in _airConditioners) {
          ac['temp'] = _currentTemperature;
        }
      });
    }
  }

  void _decreaseCounter() {
    setState(() {
      _counter -= 5;
    });
  }

  void _increaseCounter() {
    setState(() {
      _counter += 8;
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

                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 20),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        _mqttConnected
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _mqttConnected ? Colors.green : Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _mqttConnected ? Icons.cloud_done : Icons.cloud_off,
                        color: _mqttConnected ? Colors.green : Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _connectionStatus,
                        style: TextStyle(
                          color: _mqttConnected ? Colors.green : Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Значення',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        '$_counter',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: _decreaseCounter,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.8),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  '-5',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _increaseCounter,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  '+8',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.qr_code, color: Colors.white),
                      onPressed:
                          () => Navigator.pushNamed(context, '/qr_screen'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.phone, color: Colors.white),
                      onPressed:
                          () => Navigator.pushNamed(context, '/message_view'),
                    ),
                  ],
                ),
                const Text(
                  'Air Conditioners',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.thermostat,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Current: ${_currentTemperature.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      if (!_mqttConnected)
                        GestureDetector(
                          onTap: _initializeMqtt,
                          child: const Icon(
                            Icons.refresh,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                ),

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
