import 'package:flutter_bloc/flutter_bloc.dart';Add commentMore actions
import 'package:lab1/services/mqtt_service.dart';

class MqttState {
  final String? temperature;
  final bool connected;

  MqttState({this.temperature, this.connected = false});
}

class MqttCubit extends Cubit<MqttState> {
  final MqttService _mqttService;

  MqttCubit(this._mqttService) : super(MqttState()) {
    _mqttService.onDataReceived = (data) {
      emit(MqttState(temperature: data, connected: true));
    };
    _connect();
  }

  Future<void> _connect() async {
    await _mqttService.connect();
    // Optionally handle connection state here as well.
  }

  void requestTemperature() {
    _mqttService.requestTemperature();
  }

  @override
  Future<void> close() {
    _mqttService.disconnect();
    return super.close();
  }
}