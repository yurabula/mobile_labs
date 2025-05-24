import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/home/widgets/AcCard.dart';
import 'package:flutter_application_1/core/widgets/FrostedGlassCard.dart';
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

  @override
  void initState() {
    super.initState();
    _initializeMqtt();

    // Оновлюємо температуру кожні 2 секунди замість кожної секунди
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

        // Встановлюємо початкову температуру
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

                // MQTT Connection Status
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

                const Text(
                  'Air Conditioners',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),

                // Current Temperature Display
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
