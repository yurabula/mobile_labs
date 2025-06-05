import 'dart:typed_data';Add commentMore actions
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';

part 'states/message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageInitial());

  UsbPort? _port;
  Transaction<String>? _transaction;

  Future<void> connectAndRead() async {
    emit(MessageLoading());

    final devices = await UsbSerial.listDevices();
    if (devices.isEmpty) {
      emit(const MessageError('No USB devices found'));
      return;
    }

    _port = await devices[0].create();
    final bool openResult = await _port!.open();
    if (!openResult) {
      emit(const MessageError('Failed to open port'));
      return;
    }

    await _port!.setDTR(true);
    await _port!.setRTS(true);
    await _port!.setPortParameters(
      9600,
      UsbPort.DATABITS_8,
      UsbPort.STOPBITS_1,
      UsbPort.PARITY_NONE,
    );

    await _port!.write(Uint8List.fromList('GET\n'.codeUnits));

    _transaction = Transaction.stringTerminated(
      _port!.inputStream!,
      Uint8List.fromList([13, 10]),
    );

    _transaction!.stream.listen((data) {
      emit(MessageLoaded(data.trim()));
      _transaction?.dispose();
    });
  }

  @override
  Future<void> close() {
    _transaction?.dispose();
    _port?.close();
    return super.close();
  }
}