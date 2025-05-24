// lib/services/mqtt_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  static final MqttService _instance = MqttService._internal();
  factory MqttService() => _instance;
  MqttService._internal();

  MqttServerClient? _client;
  final StreamController<double> _temperatureController =
      StreamController<double>.broadcast();

  Stream<double> get temperatureStream => _temperatureController.stream;

  double _currentTemperature = 22.0;
  double get currentTemperature => _currentTemperature;

  static const String broker = 'broker.hivemq.com';
  static const int port = 1883;
  static const String temperatureTopic = 'home/lab4/temperature';

  Future<bool> connect() async {
    try {
      final clientId =
          'flutter_client_${DateTime.now().millisecondsSinceEpoch}';
      _client = MqttServerClient(broker, clientId);

      _client!.port = port;
      _client!.keepAlivePeriod = 60;
      _client!.connectTimeoutPeriod = 10000;
      _client!.autoReconnect = true;
      _client!.logging(on: true);
      _client!.secure = false;

      _client!.setProtocolV311();

      final connMessage = MqttConnectMessage()
          .withClientIdentifier(clientId)
          .startClean()
          .withWillQos(MqttQos.atLeastOnce);
      _client!.connectionMessage = connMessage;

      print('MQTT: Connecting to $broker:$port with protocol v3.1.1');

      try {
        await _client!.connect();
      } on NoConnectionException catch (e) {
        print('MQTT: NoConnectionException - $e');
        _client!.disconnect();
        return false;
      } on SocketException catch (e) {
        print('MQTT: SocketException - $e');
        _client!.disconnect();
        return false;
      }

      if (_client!.connectionStatus!.state == MqttConnectionState.connected) {
        print('MQTT: Connected successfully');
        print('MQTT: Connection status: ${_client!.connectionStatus}');

        _subscribeToTemperature();
        _setupMessageHandlers();

        return true;
      } else {
        print('MQTT: Connection failed - ${_client!.connectionStatus}');
        _client!.disconnect();
        return false;
      }
    } catch (e) {
      print('MQTT: Connection error - $e');
      _client?.disconnect();
      return false;
    }
  }

  void _subscribeToTemperature() {
    try {
      print('MQTT: Subscribing to $temperatureTopic');
      _client!.subscribe(temperatureTopic, MqttQos.atLeastOnce);
      print('MQTT: Successfully subscribed to $temperatureTopic');
    } catch (e) {
      print('MQTT: Subscription error - $e');
    }
  }

  void _setupMessageHandlers() {
    _client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final recMess = c[0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(
        recMess.payload.message,
      );

      print('MQTT: Received message on topic ${c[0].topic}: $payload');

      if (c[0].topic == temperatureTopic) {
        _handleTemperatureMessage(payload);
      }
    });

    _client!.onConnected = () {
      print('MQTT: Connected callback triggered');
    };

    _client!.onDisconnected = () {
      print('MQTT: Disconnected callback triggered');
    };

    _client!.onAutoReconnect = () {
      print('MQTT: Auto reconnecting...');
    };

    _client!.onAutoReconnected = () {
      print('MQTT: Auto reconnected successfully');
      _subscribeToTemperature();
    };

    _client!.onSubscribed = (String topic) {
      print('MQTT: Successfully subscribed to topic: $topic');
    };

    _client!.onSubscribeFail = (String topic) {
      print('MQTT: Failed to subscribe to topic: $topic');
    };

    _client!.onUnsubscribed = (String? topic) {
      print('MQTT: Unsubscribed from topic: $topic');
    };
  }

  void _handleTemperatureMessage(String payload) {
    try {
      print('MQTT: Parsing payload: $payload');

      // First try to parse as JSON (format from Node.js server)
      final data = jsonDecode(payload);
      if (data['temperature'] != null) {
        final temperature = double.parse(data['temperature'].toString());
        _updateTemperature(temperature);
        print('MQTT: Parsed JSON temperature: ${temperature}°C');
        return;
      }
    } catch (e) {
      print('MQTT: JSON parse failed, trying as plain number: $e');
    }

    try {
      // If JSON parsing failed, try parsing as plain number
      final temperature = double.parse(payload.trim());
      _updateTemperature(temperature);
      print('MQTT: Parsed plain temperature: ${temperature}°C');
    } catch (e2) {
      print(
        'MQTT: Failed to parse temperature from payload: $payload, error: $e2',
      );
    }
  }

  void _updateTemperature(double temperature) {
    print(
      'MQTT: Updating temperature from $_currentTemperature to $temperature',
    );
    _currentTemperature = temperature;
    _temperatureController.add(temperature);
  }

  void disconnect() {
    try {
      print('MQTT: Disconnecting...');
      _client?.disconnect();
    } catch (e) {
      print('MQTT: Disconnect error - $e');
    }
  }

  bool get isConnected {
    return _client?.connectionStatus?.state == MqttConnectionState.connected;
  }

  void dispose() {
    disconnect();
    _temperatureController.close();
  }

  // Add method to test connection
  Future<void> testConnection() async {
    print('MQTT: Testing connection to $broker:$port');
    print(
      'MQTT: Current connection state: ${_client?.connectionStatus?.state}',
    );

    if (isConnected) {
      print('MQTT: Connection is active');
    } else {
      print('MQTT: Connection is not active, attempting to reconnect...');
      await connect();
    }
  }
}
