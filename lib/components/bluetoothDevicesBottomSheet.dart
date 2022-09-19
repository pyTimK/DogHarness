import 'package:bluetooth_app_test/change_notifiers/bluetooth_data.dart';
import 'package:bluetooth_app_test/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

class BluetoothDevicesBottomSheet extends StatefulWidget {
  const BluetoothDevicesBottomSheet({super.key});

  @override
  State<BluetoothDevicesBottomSheet> createState() => _BluetoothDevicesBottomSheetState();
}

class _BluetoothDevicesBottomSheetState extends State<BluetoothDevicesBottomSheet> {
  BluetoothData? _bluetoothData;
  //init
  @override
  void initState() {
    super.initState();
    _bluetoothData = Provider.of<BluetoothData>(context, listen: false);
    _bluetoothData?.startScanning();
  }

  //dispose
  @override
  void dispose() {
    _bluetoothData?.stopScanning();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var bluetoothData = Provider.of<BluetoothData>(context);
    var connectedDevices = bluetoothData.connectedDevices;

    return Container(
      padding: const EdgeInsets.all(12),
      child: ListView(
        shrinkWrap: true,
        children: [
          const Center(
            child: Text('Bluetooth Devices', style: TextStyle(fontSize: 20)),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: connectedDevices.length,
                itemBuilder: (context, index) {
                  BluetoothDevice device = connectedDevices[index];
                  return ListTile(
                    title: Text(device.name),
                    subtitle: Text(device.id.toString()),
                    trailing: ElevatedButton(
                      child: const Text('Disconnect'),
                      onPressed: () => bluetoothData.disconnectFromDevice(device),
                    ),
                  );
                },
              ),
              StreamBuilder<List<ScanResult>>(
                stream: flutterBlue.scanResults,
                initialData: [],
                builder: (c, snapshot) => ListView(
                  shrinkWrap: true,
                  children: snapshot.data!.map(
                    (r) {
                      String deviceName = r.device.name.isNotEmpty ? r.device.name : 'Unknown';
                      return StreamBuilder<BluetoothDeviceState>(
                          stream: r.device.state,
                          initialData: BluetoothDeviceState.disconnected,
                          builder: (c, snapshot) {
                            bool isConnected = snapshot.data == BluetoothDeviceState.connected;

                            if (isConnected) {
                              return const SizedBox.shrink();
                            }

                            return ListTile(
                              title: Text(deviceName),
                              subtitle: Text(r.device.id.toString()),
                              trailing: ElevatedButton(
                                child: const Text('Connect'),
                                onPressed: () async {
                                  await bluetoothData.connectToDevice(r.device);
                                  if (mounted) {
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            );
                          });
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
