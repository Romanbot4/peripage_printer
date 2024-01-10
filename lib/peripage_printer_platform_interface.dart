import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'models/bluetooth_device.dart';
import 'peripage_printer_method_channel.dart';

abstract class PeripagePrinterPlatform extends PlatformInterface {
  PeripagePrinterPlatform() : super(token: _token);

  static final Object _token = Object();

  static PeripagePrinterPlatform _instance = MethodChannelPeripagePrinter();

  static PeripagePrinterPlatform get instance => _instance;

  static set instance(PeripagePrinterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> checkAndRequestBluetoothPermission();

  Future<bool> isBluetoothOn();

  Future<bool> isBluetoothSupported();

  Future<void> turnOnBluetooth();

  Future<bool> isPrinterConnected();

  Future<bool> connectPrinter();

  Future<bool> disconnectPrinter();

  Future<bool> printFeed({
    required int lines,
    required bool isBlank,
  });

  Future<bool> printImage(List<int> bitmap, {int? width});

  Future<Uint8List> messageToBitmap({
    required String message,
    int fontSize = 20,
  });

  Future<List<BluetoothDevice>> findBluetoothDevices();

  Future<bool> connectBluetoothDevice(BluetoothDevice device);
}
