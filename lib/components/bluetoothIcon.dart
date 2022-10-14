import 'package:bluetooth_app_test/styles.dart';
import 'package:flutter/material.dart';

class BluetoothIcon extends StatelessWidget {
  const BluetoothIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(blurRadius: 1, color: MyStyles.dark20, spreadRadius: 1, offset: Offset(0, 2))],
          ),
          child: const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Icon(Icons.bluetooth_rounded, color: MyStyles.green),
          ),
        ),
        const Positioned(
          top: 0,
          right: 0,
          child: CircleAvatar(
            radius: 5,
            backgroundColor: MyStyles.green,
          ),
        ),
      ],
    );
  }
}
