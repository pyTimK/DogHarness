import 'package:bluetooth_app_test/change_notifiers/bluetoothData.dart';
import 'package:bluetooth_app_test/components/bluetoothDevicesBottomSheet.dart';
import 'package:bluetooth_app_test/functions/myShowBottomSheet.dart';
import 'package:bluetooth_app_test/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
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
    var dataStream = bluetoothData.dataStream;
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
            Expanded(
              child: FutureBuilder(
                  future: bluetoothData.services,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text("No Services");
                    }

                    List<BluetoothService> services = snapshot.data!;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            var service = services[index];
                            return Column(mainAxisSize: MainAxisSize.min, children: [
                              Text(service.uuid.toString()),
                              ...service.characteristics
                                  .where((characteristic) =>
                                      characteristic.properties.write || characteristic.properties.notify)
                                  .map((characteristic) => ListTile(
                                        title: Text(characteristic.uuid.toString()),
                                        subtitle: Text(characteristic.properties
                                            .toString()
                                            .replaceAll('CharacteristicProperty.', '')),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (characteristic.properties.notify)
                                              ElevatedButton(
                                                child: const Text('Read'),
                                                onPressed: () async {
                                                  bluetoothData.listen(characteristic);
                                                },
                                              ),
                                            if (characteristic.properties.write)
                                              ElevatedButton(
                                                child: const Text('Write 1'),
                                                onPressed: () async {
                                                  await characteristic.write([0x31], withoutResponse: true);
                                                },
                                              ),
                                            if (characteristic.properties.write)
                                              ElevatedButton(
                                                child: const Text('Write 0'),
                                                onPressed: () async {
                                                  await characteristic.write([0x30], withoutResponse: true);
                                                },
                                              ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ]);
                          },
                        ),
                        const SizedBox(height: 10),
                        Text("Steps: ${bluetoothData.steps}",
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 10),
                        const Text("Data Stream", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: dataStream.length,
                            itemBuilder: (context, index) {
                              return Text(dataStream[dataStream.length - index - 1]);
                            },
                          ),
                        ),
                      ],
                    );
                  }),
            )
        ],
      ),
    );
  }
}
