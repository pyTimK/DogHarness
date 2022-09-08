import 'package:app_settings/app_settings.dart';
import 'package:bluetooth_app_test/components/bluetoothDevicesBottomSheet.dart';
import 'package:bluetooth_app_test/components/myoverlay.dart';
import 'package:bluetooth_app_test/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothState bluetoothState = BluetoothState.unknown;

  //init
  @override
  void initState() {
    super.initState();
    flutterBlue.setLogLevel(LogLevel.debug);
    flutterBlue.state.listen((state) {
      setState(() {
        bluetoothState = state;
      });
    });
  }

  void _displayBluetoothDeviceList() {
    // _displayBlootoothDevices();

    // show bottom sheet
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (context) {
          return const BluetoothDevicesBottomSheet();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    onPressed: _displayBluetoothDeviceList,
                    child: const Text("Show Bluetooth Devices")),
              ],
            ),
          ),
          if (bluetoothState == BluetoothState.off) const TurnOnBluetooth(),
        ],
      ),
    );
  }
}

class TurnOnBluetooth extends StatelessWidget {
  const TurnOnBluetooth({
    Key? key,
  }) : super(key: key);

  void _openBluetoothSettings() async {
    await AppSettings.openBluetoothSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        MyOverlay(
          onTouch: (_) {},
          color: Color.fromARGB(221, 22, 22, 22),
        ),
        UnconstrainedBox(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Bluetooth Disabled',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                      'Please turn on bluetooth to use this application.'),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: _openBluetoothSettings,
                        child: const Text('Open Bluetooth Settings'),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
