import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:peripage_printer/peripage_printer.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("PeripagePrinter", () {
    testWidgets('getPlatformVersion test', (WidgetTester tester) async {
      final PeripagePrinter plugin = PeripagePrinter();
      final String? version = await plugin.getPlatformVersion();
      expect(version?.isNotEmpty, true);
    });

    testWidgets('checkAndRequestBluetoothPermission test',
        (WidgetTester tester) async {
      final PeripagePrinter plugin = PeripagePrinter();
      await plugin.checkAndRequestBluetoothPermission();
    });

    testWidgets('findBluetoothDevices test', (WidgetTester tester) async {
      final PeripagePrinter plugin = PeripagePrinter();
      final devices = await plugin.findBluetoothDevices();
      expect(devices, isNotEmpty);
    });
  });
}
