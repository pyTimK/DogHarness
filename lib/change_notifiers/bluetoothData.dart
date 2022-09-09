import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';

FlutterBlue flutterBlue = FlutterBlue.instance;

class BluetoothData extends ChangeNotifier {
  BluetoothData() {
    refreshConnectedDevices();
  }

  // internals
  List<BluetoothDevice> _connectedDevices = [];

  // getters
  List<BluetoothDevice> get connectedDevices => _connectedDevices;

  // methods
  void refreshConnectedDevices() async {
    _connectedDevices = await flutterBlue.connectedDevices;
    notifyListeners();
  }

  void connectToDevice(BluetoothDevice device) async {
    await device.connect();
    _connectedDevices.add(device);
    notifyListeners();
  }

  void disconnectFromDevice(BluetoothDevice device) async {
    await device.disconnect();
    _connectedDevices.remove(device);
    notifyListeners();
  }

  void startScanning() async {
    var isScanning = await flutterBlue.isScanning.first;

    if (!isScanning) {
      flutterBlue.startScan();
    }
  }

  void stopScanning() async {
    var isScanning = await flutterBlue.isScanning.first;

    if (isScanning) {
      flutterBlue.stopScan();
    }
  }
}
