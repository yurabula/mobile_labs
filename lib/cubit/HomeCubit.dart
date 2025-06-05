import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab1/cubit/states/home_state.dart';
import 'package:lab1/services/connection_service.dart';
import 'package:lab1/services/mqtt_service.dart';

class HomeCubit extends Cubit<HomeState> {
  final MqttService mqttService;
  final ConnectivityService connectivityService;
  late final StreamSubscription<ConnectionStatus> _connectivitySub;

  HomeCubit({
    required this.mqttService,
    required this.connectivityService,
  }) : super(const HomeState(
          temperature: 36.6,
          isCelsius: true,
          brightness: 0.5,
          isConnected: false,
        ),) {
    _init();
  }

  void _init() {
    _connectivitySub = connectivityService.statusStream.listen((status) {
      emit(state.copyWith(isConnected: status == ConnectionStatus.online));
    });

    mqttService.onDataReceived = (data) {
      final newTemp = double.tryParse(data);
      if (newTemp != null) {
        emit(state.copyWith(temperature: newTemp));
      }
    };

    mqttService.connect().then((_) {
      emit(state.copyWith(isConnected: true));
    });
  }

  void toggleUnit() {
    double temp = state.temperature;
    if (state.isCelsius) {
      temp = (temp * 9 / 5) + 32;
    } else {
      temp = (temp - 32) * 5 / 9;
    }
    emit(state.copyWith(
      temperature: temp,
      isCelsius: !state.isCelsius,
    ),);
  }

  void changeBrightness(double value) {
    emit(state.copyWith(brightness: value));
  }

  void scanTemperature() {
    if (state.isConnected) {
      mqttService.requestTemperature();
    }
  }

  @override
  Future<void> close() {
    _connectivitySub.cancel();
    connectivityService.dispose();
    mqttService.disconnect();
    return super.close();
  }
}