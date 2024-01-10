import 'dart:typed_data';

import '/models/bluetooth_device.dart';

import 'peripage_printer_platform_interface.dart';

class PeripagePrinter {
  Future<String?> getPlatformVersion() {
    return PeripagePrinterPlatform.instance.getPlatformVersion();
  }

  Future<void> checkAndRequestBluetoothPermission() {
    return PeripagePrinterPlatform.instance
        .checkAndRequestBluetoothPermission();
  }

  Future<bool> isBluetoothOn() {
    return PeripagePrinterPlatform.instance.isBluetoothOn();
  }

  Future<bool> isBluetoothSupported() {
    return PeripagePrinterPlatform.instance.isBluetoothSupported();
  }

  Future<void> turnOnBluetooth() {
    return PeripagePrinterPlatform.instance.turnOnBluetooth();
  }

  Future<bool> isPrinterConnected() {
    return PeripagePrinterPlatform.instance.isPrinterConnected();
  }

  Future<bool> connectPrinter() {
    return PeripagePrinterPlatform.instance.connectPrinter();
  }

  Future<bool> disconnectPrinter() {
    return PeripagePrinterPlatform.instance.disconnectPrinter();
  }

  Future<bool> printFeed({
    required int lines,
    required bool isBlank,
  }) {
    return PeripagePrinterPlatform.instance.printFeed(
      lines: lines,
      isBlank: isBlank,
    );
  }

  Future<bool> printImage(List<int> bitmap, {int? width}) async {
    return PeripagePrinterPlatform.instance.printImage(bitmap, width: width);
  }

  Future<Uint8List> messageToBitmap({
    required String message,
    int fontSize = 20,
  }) {
    return PeripagePrinterPlatform.instance.messageToBitmap(
      message: message,
      fontSize: fontSize,
    );
  }

  Future<List<BluetoothDevice>> findBluetoothDevices() async {
    return PeripagePrinterPlatform.instance.findBluetoothDevices();
  }

  Future<bool> connectBluetoothDevice(BluetoothDevice device) async {
    return PeripagePrinterPlatform.instance.connectBluetoothDevice(device);
  }
}
