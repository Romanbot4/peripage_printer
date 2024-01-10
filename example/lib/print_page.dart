import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:peripage_printer/models/bluetooth_device.dart';
import 'package:peripage_printer/peripage_printer.dart';
import 'package:peripage_printer_example/widgets/easy_button.dart';

import 'constants/color.dart';
import 'constants/dimen.dart';
import 'widgets/easy_text.dart';

class PrintBody extends StatefulWidget {
  const PrintBody({super.key});

  @override
  State<PrintBody> createState() => _PrintBodyState();
}

class _PrintBodyState extends State<PrintBody> {
  final _plugin = PeripagePrinter();
  final GlobalKey repaintKey = GlobalKey();

  void _requestPermission() async {
    await _plugin.checkAndRequestBluetoothPermission();
  }

  bool isBluetoothOn = false;
  void _isBluetoothOn() async {
    isBluetoothOn = await _plugin.isBluetoothOn();
    if (mounted) setState(() {});
  }

  bool isBluetoothSupported = false;
  void _isBluetoothSupported() async {
    isBluetoothSupported = await _plugin.isBluetoothSupported();
    if (mounted) setState(() {});
  }

  bool isPrinterConnected = false;
  void _isPrinterConnected() async {
    isPrinterConnected = await _plugin.isPrinterConnected();
    if (mounted) setState(() {});
  }

  bool isPrinterConnecting = false;
  void _connectPrinter() async {
    isPrinterConnecting = true;
    if (mounted) setState(() {});

    isPrinterConnected = await _plugin.connectPrinter();

    isPrinterConnecting = false;
    if (mounted) setState(() {});
  }

  List<BluetoothDevice> devices = [];
  void _findDevices() async {
    devices = await _plugin.findBluetoothDevices();
    if (mounted) setState(() {});
  }

  List<BluetoothDevice> filteredPeripageDevices(List<BluetoothDevice> devices) {
    return devices.where((element) => element.name.startsWith("PPG")).toList();
  }

  final Map<String, bool> _connectedDevices = {};
  Future<void> _connectDevice(BluetoothDevice device) async {
    final result = await _plugin.connectBluetoothDevice(device);
    _connectedDevices[device.address] = result;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const margin = 16.0;
    final buttonWidth = MediaQuery.of(context).size.width - (2 * margin);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: margin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EasyButton(
              width: buttonWidth,
              label: "Request bluetooth permission",
              onPressed: _requestPermission,
            ),
            EasyButton(
              width: buttonWidth,
              label: "Check bluetooth is supported ? $isBluetoothSupported",
              onPressed: _isBluetoothSupported,
            ),
            EasyButton(
              width: buttonWidth,
              label: "Check bluetooth is on ? $isBluetoothOn",
              onPressed: _isBluetoothOn,
            ),
            EasyButton(
              width: buttonWidth,
              label: "Check printer is connected ? $isPrinterConnected",
              onPressed: _isPrinterConnected,
            ),
            EasyButton(
              width: buttonWidth,
              label: isPrinterConnecting
                  ? 'Connecting printer'
                  : 'Connect printer',
              onPressed: _connectPrinter,
            ),
            EasyButton(
              width: buttonWidth,
              label: 'Find devices ${devices.length}',
              onPressed: _findDevices,
            ),
            const SizedBox(height: 16.0),
            Text(
              "Filtered devices",
              style: theme.textTheme.titleMedium,
            ),
            ...filteredPeripageDevices(devices).map((device) {
              return GestureDetector(
                onTap: () async => await _connectDevice(device),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade400,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.print_rounded,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 16.0),
                      Text(
                        device.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      if (_connectedDevices.containsKey(device.address))
                        Text(
                          "Connected",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 16.0),
            RepaintBoundary(
              key: repaintKey,
              child: const Material(
                color: kWhiteColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PrintVoucherDetailItem(
                                label: "Customer Name :",
                                value: "Lucky",
                              ),
                              PrintVoucherDetailItem(
                                label: "Address/Ph no :",
                                value: "09 762345123",
                              ),
                              PrintVoucherDetailItem(
                                label: "A/C Price :",
                                value: "Lucky",
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PrintVoucherDetailItem(
                                  label: "Invoice No :", value: "A012U2"),
                              PrintVoucherDetailItem(
                                  label: "Date :", value: " 2/1/2024"),
                              PrintVoucherDetailItem(
                                  label: "Price :", value: "1,132,800"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: kAs20x),
                    SizedBox(height: kAs5x),
                  ],
                ),
              ),
            ),
            EasyButton(
              width: buttonWidth,
              label: 'Print',
              onPressed: _printImage,
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List?> capture() async {
    try {
      /// boundary widget by GlobalKey
      RenderRepaintBoundary? boundary = repaintKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;

      /// convert boundary to image
      ui.Image capturedImage = await boundary!.toImage(pixelRatio: 3.5);

      /// set ImageByteFormat
      final byteData =
          await capturedImage.toByteData(format: ui.ImageByteFormat.png);

      final pngBytes = byteData?.buffer.asUint8List();

      return pngBytes;
    } catch (e) {
      rethrow;
    }
  }

  void _printImage() async {
    final image = await capture();
    await _plugin.printImage(image!);

  }
}

class TitleTableRowItemView extends StatelessWidget {
  const TitleTableRowItemView({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: kAs45x,
      child: EasyText(
        text: label,
        fontSize: kFs14x,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class PrintVoucherDetailItem extends StatelessWidget {
  const PrintVoucherDetailItem({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return EasyText(
      text: "$label   $value",
      fontSize: kFs14x,
    );
  }
}
