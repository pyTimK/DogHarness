import 'package:bluetooth_app_test/change_notifiers/bluetoothData.dart';
import 'package:bluetooth_app_test/components/bluetoothDevicesBottomSheet.dart';
import 'package:bluetooth_app_test/functions/myShowBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _displayBluetoothDeviceList() {
    var bluetoothData = Provider.of<BluetoothData>(context, listen: false);

    myShowBottomSheet(
      context: context,
      builder: (_) {
        return ChangeNotifierProvider.value(
          value: bluetoothData,
          child: const BluetoothDevicesBottomSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var bluetoothData = context.watch<BluetoothData>();
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: _displayBluetoothDeviceList,
            child: const Text("Show Bluetooth Devices"),
          ),
          if (bluetoothData.connectedDevices.isNotEmpty)
            Text("Connected Devices: ${bluetoothData.connectedDevices.length}"),
        ],
      ),
    );
  }
}
