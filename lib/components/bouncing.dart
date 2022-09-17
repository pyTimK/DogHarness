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
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        _controller.forward();
      },
      onPointerUp: (PointerUpEvent event) {
        _controller.reverse();
        widget.onPress();
      },
      child: Transform.scale(
        scale: scaleAnimation.value,
        child: widget.child,
      ),
    );
  }
}
