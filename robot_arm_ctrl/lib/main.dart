import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Robot Arm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

extension IntToString on int {
  String toHex() => '0x${toRadixString(16)}';
  String toPadded([int width = 3]) => toString().padLeft(width, '0');
  String toTransport() {
    switch (this) {
      case SerialPortTransport.usb:
        return 'USB';
      case SerialPortTransport.bluetooth:
        return 'Bluetooth';
      case SerialPortTransport.native:
        return 'Native';
      default:
        return 'Unknown';
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var availablePorts = [];

  void initPorts() {
    setState(() => availablePorts = SerialPort.availablePorts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Robot Arm")),
      body: ListView(
        children: [
          for (final address in availablePorts)
            Builder(builder: (context) {
              final port = SerialPort(address);
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      connectPort(port);
                    },
                    child: Card(
                      child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Text('${port.description}')),
                    ),
                  ),
                  //Text('Transport${port.transport.toTransport()}'),
                  // Text('USB Bus', port.busNumber?.toPadded()),
                  //Text('USB Device'+ port.deviceNumber?.toPadded),
                  // Text('Vendor ID', port.vendorId?.toHex()),
                  // Text('Product ID', port.productId?.toHex()),
                  // Text('Manufacturer', port.manufacturer),
                  // Text('Product Name', port.productName),
                  // Text('Serial Number', port.serialNumber),
                  // Text('MAC Address', port.macAddress),
                ],
              );
            }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: initPorts,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  connectPort(SerialPort port) async {
    final configu = SerialPortConfig();
    configu.baudRate = 115200;
    configu.bits = 8;
    configu.parity = 0;
    port.config = configu;
    SerialPortReader reader = SerialPortReader(port, timeout: 1);

    try {
      port.openReadWrite();
      print(port.write(_stringToUint8List('G28')));
      await reader.stream.listen((data) {
        print('received : $data');
      });
      //port.close();
    } on SerialPortError catch (err, _) {
      print(SerialPort.lastError);
      port.close();
    }
  }

  Uint8List _stringToUint8List(String data) {
    List<int> codeUnits = data.codeUnits;
    Uint8List uint8list = Uint8List.fromList(codeUnits);
    return uint8list;
  }
}
