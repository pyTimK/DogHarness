import 'package:app_settings/app_settings.dart';
import 'package:bluetooth_app_test/components/myOverlay.dart';
import 'package:flutter/material.dart';

class TurnOnBluetooth extends StatelessWidget {
  const TurnOnBluetooth({
    Key? key,
  }) : super(key: key);

  void _openBluetoothSettings() async {
    await AppSettings.openBluetoothSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        MyOverlay(
          onTouch: (_) {},
          color: const Color.fromARGB(221, 22, 22, 22),
        ),
        UnconstrainedBox(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Bluetooth Disabled',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                      'Please turn on bluetooth to use this application.'),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: _openBluetoothSettings,
                        child: const Text('Open Bluetooth Settings'),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
