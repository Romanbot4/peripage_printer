import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:peripage_printer/models/bluetooth_device.dart';

import 'peripage_printer_platform_interface.dart';

class MethodChannelPeripagePrinter extends PeripagePrinterPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('peripage_printer');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> checkAndRequestBluetoothPermission() async {
    await methodChannel.invokeMethod(
      'checkAndRequestBluetoothPermission',
    );
  }

  @override
  Future<bool> connectPrinter() async {
    final result = await methodChannel.invokeMethod('connectPrinter') as bool;
    return result;
  }

  @override
  Future<bool> disconnectPrinter() async {
    final result =
        await methodChannel.invokeMethod('disconnectPrinter') as bool;
    return result;
  }

  @override
  Future<bool> isBluetoothOn() async {
    final result = await methodChannel.invokeMethod('isBluetoothOn') as bool;
    return result;
  }

  @override
  Future<bool> isBluetoothSupported() async {
    final result =
        await methodChannel.invokeMethod('isBluetoothSupported') as bool;
    return result;
  }

  @override
  Future<bool> isPrinterConnected() async {
    final result =
        await methodChannel.invokeMethod('isPrinterConnected') as bool;
    return result;
  }

  @override
  Future<Uint8List> messageToBitmap(
      {required String message, int fontSize = 20}) async {
    final result =
        await methodChannel.invokeMethod('messageToBitmap', <String, dynamic>{
      'message': message,
      'fontSize': fontSize,
    }) as Uint8List;
    return result;
  }

  @override
  Future<bool> printFeed({required int lines, required bool isBlank}) async {
    final result =
        await methodChannel.invokeMethod('printFeed', <String, dynamic>{
      'lines': lines,
      'isBlank': isBlank,
    });
    return result;
  }
  
  @override
  Future<void> turnOnBluetooth() async {
    await methodChannel.invokeMethod("turnOnBluetooth");
  }

  @override
  Future<List<BluetoothDevice>> findBluetoothDevices() async {
    final data = await methodChannel.invokeMethod("findBluetoothDevices") as List;
    return data.map((e) => BluetoothDevice.fromMap(e)).toList();
  }
  
  @override
  Future<bool> connectBluetoothDevice(BluetoothDevice device) async {
    final data = await methodChannel.invokeMethod("connectBluetoothDevice", device.toMap());
    return data as bool;
  }
  
  @override
  Future<bool> printImage(List<int> bitmap, {int? width}) async {
    final result = await methodChannel.invokeMethod('printImage', <String, dynamic>{
      'bitmap': bitmap,
      'width': width,
    });
    return result;
  }
}
