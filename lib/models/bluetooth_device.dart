class BluetoothDevice {
  final String name;
  final String address;
  final String alias;
  final int bondState;
  final int type;

  const BluetoothDevice({
    required this.name,
    required this.address,
    required this.alias,
    required this.bondState,
    required this.type,
  });

  factory BluetoothDevice.fromMap(json) {
    return BluetoothDevice(
      name: json['name'],
      address: json['address'],
      alias: json['alias'],
      bondState: json['bondState'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'alias': alias,
      'bondState': bondState,
      'type': type,
    };
  }
}
