import 'package:bluetooth_app_test/change_notifiers/bluetoothData.dart';
import 'package:bluetooth_app_test/components/turnOnBlueetooth.dart';
import 'package:bluetooth_app_test/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("General Kenobi!"),
      ),
      body: Stack(
        children: [
          ChangeNotifierProvider(
            create: (parentContext) => BluetoothData(),
            child: const Home(),
          ),
          if (bluetoothState == BluetoothState.off) const TurnOnBluetooth(),
        ],
      ),
    );
  }
}
