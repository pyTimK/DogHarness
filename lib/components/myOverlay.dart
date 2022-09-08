import 'package:flutter/material.dart';

class MyOverlay extends StatelessWidget {
  const MyOverlay({Key? key, this.onTouch, this.color = Colors.transparent})
      : super(key: key);
  final void Function(DragDownDetails)? onTouch;
  final Color color;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onPanDown: onTouch,
      child: Container(
        color: color,
        width: width,
        height: height,
      ),
    );
  }
}
