import 'dart:math' as math;
import 'package:bluetooth_app_test/styles.dart';
import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  const MyAlertDialog({required this.children, super.key});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Transform.rotate(
        angle: -3 * (math.pi / 180),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: MyStyles.white,
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: children),
        ),
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: MyStyles.white, width: 1),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
