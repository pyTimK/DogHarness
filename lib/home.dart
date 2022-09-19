import 'package:bluetooth_app_test/change_notifiers/bluetooth_data.dart';
import 'package:bluetooth_app_test/components/bluetoothDevicesBottomSheet.dart';
import 'package:bluetooth_app_test/functions/my_show_bottom_sheet.dart';
import 'package:bluetooth_app_test/functions/utils.dart';
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
          if (bluetoothData.isConnected)
            ElevatedButton(
              child: const Text('Write 1'),
              onPressed: () async {
                await bluetoothData.write("1");
              },
            ),
          if (bluetoothData.isConnected)
            ElevatedButton(
              child: const Text('Write 0'),
              onPressed: () async {
                await bluetoothData.write("0");
              },
            ),
          const SizedBox(height: 10),
          Text("Steps: ${bluetoothData.steps}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          if (bluetoothData.isConnected)
            const Text("Data Stream", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: dataStream.length,
              itemBuilder: (context, index) {
                var dataObject = dataStream[dataStream.length - index - 1];
                return Text("${getFomrattedTime(dataObject.datetime)}     ${dataObject.data}");
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10),
            ),
          ),
        ],
      ),
    );
  }
}
