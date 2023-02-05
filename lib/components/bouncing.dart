/// This file contains the Bouncing widget which is used to
/// provide the bouncing animation to a child widget.
import 'package:bluetooth_app_test/logger.dart';
import 'package:flutter/material.dart';

var pointerMovedCount = 0;

class Bouncing extends StatefulWidget {
  const Bouncing({
    required this.child,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;

  @override
  State<Bouncing> createState() => _BouncingState();
}

class _BouncingState extends State<Bouncing> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> scaleAnimation;
  var hasMoved = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    scaleAnimation = Tween(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        // logger.wtf("pointerdown");
        hasMoved = false;
        pointerMovedCount = 0;
        _controller.forward().then((_) => _controller.reverse());
      },
      onPointerUp: (PointerUpEvent event) {
        // logger.wtf("pointerup");
        // logger.wtf("hasMoved: $hasMoved");
        if (!hasMoved) {
          widget.onPressed();
        }
      },
      onPointerMove: (PointerMoveEvent event) {
        // logger.wtf("pointermove");
        pointerMovedCount++;
        hasMoved = pointerMovedCount > 30;
        _controller.reset();
      },
      child: Transform.scale(
        scale: scaleAnimation.value,
        child: widget.child,
      ),
    );
  }
}
