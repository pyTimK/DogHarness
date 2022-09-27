import 'dart:async';

import 'package:bluetooth_app_test/constants.dart';
import 'package:bluetooth_app_test/logger.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectedDeviceNotifier extends StateNotifier<AsyncValue<BluetoothDevice?>> {
  ConnectedDeviceNotifier() : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() async {
    final connectedDevices = await FlutterBlue.instance.connectedDevices;
    if (connectedDevices.isEmpty) {
      state = const AsyncValue.data(null);
      return;
    }
    final device = connectedDevices.firstWhere((device) => device.name == Constants.deviceName);
    state = AsyncValue.data(device);
  }

  Future<void> connect() async {
    var flutterBlue = FlutterBlue.instance;

    if (!(await flutterBlue.isScanning.first)) {
      flutterBlue.startScan();
    }

    final results = await flutterBlue.scanResults.firstWhere((results) {
      return results.any((result) => result.device.name == Constants.deviceName);
    });

    final device = results.firstWhere((result) => result.device.name == Constants.deviceName).device;

    flutterBlue.stopScan();

    try {
      await device.connect(autoConnect: false);
      state = AsyncValue.data(device);
    } catch (e) {
      await device.disconnect();
      await Future.delayed(const Duration(seconds: 2));
      connect();
    }
  }

  Future<void> disconnect() async {
    var flutterBlue = FlutterBlue.instance;
    final connectedDevices = await flutterBlue.connectedDevices;

    for (var device in connectedDevices) {
      await device.disconnect();
    }
    state = const AsyncValue.data(null);

    // var device = state.value;

    // if (device == null) return;

    // if (await device.state.first == BluetoothDeviceState.connected) {
    //   await device.disconnect();
    //   state = const AsyncValue.data(null);
    // }
  }
}
