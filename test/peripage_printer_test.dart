// import 'package:flutter_test/flutter_test.dart';
// import 'package:peripage_printer/peripage_printer.dart';
// import 'package:peripage_printer/peripage_printer_platform_interface.dart';
// import 'package:peripage_printer/peripage_printer_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockPeripagePrinterPlatform
//     with MockPlatformInterfaceMixin
//     implements PeripagePrinterPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final PeripagePrinterPlatform initialPlatform = PeripagePrinterPlatform.instance;

//   test('$MethodChannelPeripagePrinter is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelPeripagePrinter>());
//   });

//   test('getPlatformVersion', () async {
//     PeripagePrinter peripagePrinterPlugin = PeripagePrinter();
//     MockPeripagePrinterPlatform fakePlatform = MockPeripagePrinterPlatform();
//     PeripagePrinterPlatform.instance = fakePlatform;

//     expect(await peripagePrinterPlugin.getPlatformVersion(), '42');
//   });
// }
