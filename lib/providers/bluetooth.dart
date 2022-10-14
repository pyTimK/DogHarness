import 'package:bluetooth_app_test/classes/bluetooth_data.dart';
import 'package:bluetooth_app_test/logger.dart';
import 'package:bluetooth_app_test/state_notifiers/connected_device_notifier.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bluetoothStateProvider = StreamProvider((ref) {
  return FlutterBlue.instance.state;
});

final isConnectAutomaticallyProvider = StateProvider((ref) {
  return false;
});

final connectedDeviceProvider = StateNotifierProvider<ConnectedDeviceNotifier, AsyncValue<BluetoothDevice?>>((ref) {
  final bluetoothState = ref.watch(bluetoothStateProvider);
  return ConnectedDeviceNotifier();
});

final writableCharacteristicProvider = FutureProvider((ref) async {
  final connectedDevice = ref.watch(connectedDeviceProvider).value;
  logger.wtf("connectedDevice: $connectedDevice");

  if (connectedDevice == null) return null;

  final services = await connectedDevice.discoverServices();

  for (BluetoothService service in services) {
    for (BluetoothCharacteristic characteristic in service.characteristics) {
      if (characteristic.properties.write) {
        return characteristic;
      }
    }
  }

  return null;
});

final notifiableCharacteristicProvider = FutureProvider((ref) async {
  final connectedDevice = ref.watch(connectedDeviceProvider).value;

  logger.d('notifiableCharacteristicProvider');
  logger.d(connectedDevice);

  if (connectedDevice == null) return null;
  logger.d('PASSED NULL!!!!');

  final services = await connectedDevice.discoverServices();

  for (BluetoothService service in services) {
    for (BluetoothCharacteristic characteristic in service.characteristics) {
      if (characteristic.properties.notify) {
        logger.d(characteristic);
        return characteristic;
      }
    }
  }

  return null;
});

final shouldListenProvider = StateProvider<bool>((ref) {
  return false;
});

final isListeningProvider = FutureProvider<bool>((ref) async {
  final notifiableCharacteristic = ref.watch(notifiableCharacteristicProvider).value;
  final shouldListen = ref.watch(shouldListenProvider);

  logger.d('isListeningProvider');
  // logger.d(notifiableCharacteristic?.descriptors[0].value);
  logger.d(shouldListen);

  if (notifiableCharacteristic == null) return false;

  if (shouldListen) {
    await notifiableCharacteristic.setNotifyValue(true);
    return true;
  } else {
    await notifiableCharacteristic.setNotifyValue(false);
    return false;
  }
});

final dataStreamProvider = StreamProvider<BluetoothData>((ref) {
  final notifiableCharacteristic = ref.watch(notifiableCharacteristicProvider).value;
  final isListening = ref.watch(isListeningProvider).value ?? false;

  if (notifiableCharacteristic == null || !isListening) return const Stream.empty();

  return notifiableCharacteristic.value.asyncMap<BluetoothData>((value) {
    return BluetoothData.fromBytes(value);
  });
});
