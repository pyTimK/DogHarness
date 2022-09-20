/// This file contains the Bouncing widget which is used to
/// provide the bouncing animation to a child widget.
import 'package:flutter/material.dart';

class Bouncing extends StatefulWidget {
  const Bouncing({
    required this.child,
    required this.onPress,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPress;

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
      duration: const Duration(milliseconds: 200),
    );

    scaleAnimation = Tween(begin: 1.0, end: 0.8).animate(
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
        hasMoved = false;
        _controller.forward().then((_) => _controller.reverse());
      },
      onPointerUp: (PointerUpEvent event) {
        if (!hasMoved) {
          widget.onPress();
        }
      },
      onPointerMove: (PointerMoveEvent event) {
        hasMoved = true;
      },
      child: Transform.scale(
        scale: scaleAnimation.value,
        child: widget.child,
      ),
    );
  }
}
