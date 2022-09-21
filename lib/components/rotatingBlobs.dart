import 'package:blobs/blobs.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:flutter/material.dart';

class RotatingBlobs extends StatefulWidget {
  const RotatingBlobs({super.key});

  @override
  State<RotatingBlobs> createState() => _RotatingBlobsState();
}

class _RotatingBlobsState extends State<RotatingBlobs> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 25000),
      vsync: this,
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Blob.animatedRandom(
            size: 210,
            edgesCount: 9,
            minGrowth: 9,
            loop: true,
            duration: const Duration(seconds: 3),
            styles: BlobStyles(
              color: MyStyles.dark20,
              fillType: BlobFillType.fill,
              strokeWidth: 3,
            ),
          ),
          Blob.animatedRandom(
            size: 185,
            edgesCount: 9,
            minGrowth: 9,
            loop: true,
            duration: const Duration(seconds: 3),
            styles: BlobStyles(
              color: MyStyles.dark60,
              fillType: BlobFillType.fill,
              strokeWidth: 3,
            ),
          ),
        ],
      ),
    );
  }
}
