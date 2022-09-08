import 'package:bluetooth_app_test/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothDevicesBottomSheet extends StatefulWidget {
  const BluetoothDevicesBottomSheet({super.key});

  @override
  State<BluetoothDevicesBottomSheet> createState() =>
      _BluetoothDevicesBottomSheetState();
}

class _BluetoothDevicesBottomSheetState
    extends State<BluetoothDevicesBottomSheet> {
  List<BluetoothDevice> connectedDevices = [];
  FlutterBlue flutterBlue = FlutterBlue.instance;

  // init
  @override
  void initState() {
    super.initState();
    _refreshConnectedDevices();
  }

  _refreshConnectedDevices() async {
    var connectedDevices = await flutterBlue.connectedDevices;
    setState(() {
      this.connectedDevices = connectedDevices;
    });
  }

  void _connectToDevice(BluetoothDevice device) async {
    await device.connect();
    setState(() {
      connectedDevices = connectedDevices + [device];
    });
  }

  void _disconnectFromDevice(BluetoothDevice device) async {
    await device.disconnect();
    setState(() {
      connectedDevices =
          connectedDevices.where((element) => element != device).toList();
    });
  }

  void _displayBlootoothDevices() async {
    logger.wtf(await flutterBlue.connectedDevices);
  }

  void _scanBluetoothDevices() async {
    if (await flutterBlue.isScanning.first) {
      return;
    }
    flutterBlue.startScan(timeout: const Duration(seconds: 10));
  }

  @override
  Widget build(BuildContext context) {
    _scanBluetoothDevices();

    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Bluetooth Devices', style: TextStyle(fontSize: 20)),
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
                      onPressed: () => _disconnectFromDevice(device),
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
                      String deviceName =
                          r.device.name.isNotEmpty ? r.device.name : 'Unknown';
                      return StreamBuilder<BluetoothDeviceState>(
                          stream: r.device.state,
                          initialData: BluetoothDeviceState.disconnected,
                          builder: (c, snapshot) {
                            bool isConnected =
                                snapshot.data == BluetoothDeviceState.connected;

                            if (isConnected) {
                              return const SizedBox.shrink();
                            }

                            return ListTile(
                              title: Text(deviceName),
                              subtitle: Text(r.device.id.toString()),
                              trailing: ElevatedButton(
                                child: const Text('Connect'),
                                onPressed: () => _connectToDevice(r.device),
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
