import 'package:bluetooth_app_test/state_notifiers/connected_device_notifier.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bluetoothStateProvider = StreamProvider((ref) {
  return FlutterBlue.instance.state;
});

// final isScanningProvider = StreamProvider.autoDispose((ref) {
//   return FlutterBlue.instance.isScanning;
// });

final connectedDeviceProvider = StateNotifierProvider<ConnectedDeviceNotifier, AsyncValue<BluetoothDevice?>>((ref) {
  final bluetoothState = ref.watch(bluetoothStateProvider);
  return ConnectedDeviceNotifier();
});
