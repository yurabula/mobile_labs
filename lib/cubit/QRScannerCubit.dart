import 'dart:typed_data';Add commentMore actions

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab1/cubit/states/qr_scanner_state.dart';
import 'package:usb_serial/usb_serial.dart';

class QRScannerCubit extends Cubit<QRScannerState> {
  QRScannerCubit() : super(QRScannerInitial()) {
    _initializeUSBConnection();
  }

  UsbPort? _port;

  Future<void> _initializeUSBConnection() async {
    emit(QRScannerConnecting());
    final connected = await _connectToUSB();
    if (connected) {
      _listenToESP32();
      await _port?.write(Uint8List.fromList('GET\n'.codeUnits));
      emit(QRScannerConnected());
    } else {
      emit(QRScannerNotConnected());
    }
  }

  Future<bool> _connectToUSB() async {
    final devices = await UsbSerial.listDevices();
    if (devices.isNotEmpty) {
      _port = await devices[0].create();
      final bool opened = await _port?.open() ?? false;
      if (!opened) return false;

      await _port?.setDTR(true);
      await _port?.setRTS(true);
      await _port?.setPortParameters(
        9600,
        UsbPort.DATABITS_8,
        UsbPort.STOPBITS_1,
        UsbPort.PARITY_NONE,
      );
      return true;
    }
    return false;
  }

  Future<void> sendToMicrocontroller(String text) async {
    if (_port == null) {
      final success = await _connectToUSB();
      if (!success) {
        emit(const QRScannerError('USB connection failed'));
        return;
      }
    }

    emit(QRScannerSending());
    await _port?.write(Uint8List.fromList('$text\n'.codeUnits));
    emit(QRScannerSent(text));
  }

  void _listenToESP32() {
    _port?.inputStream?.listen((Uint8List data) {
      final String response = String.fromCharCodes(data).trim();
      if (response.isNotEmpty) {
        // You could emit another state here if needed
        print('ESP32: $response');
      }
    });
  }

  Future<void> reset() async {
    emit(QRScannerConnected());
  }

  @override
  Future<void> close() {
    _port?.close();
    return super.close();
  }
}