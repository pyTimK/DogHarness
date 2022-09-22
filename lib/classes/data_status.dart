import 'package:flutter/material.dart';

class DataStatus {
  final int value;
  final String label;
  final String status;
  final Color color;
  final String icon;

  const DataStatus(
      {required this.value, required this.label, required this.status, required this.color, required this.icon});

  @override
  String toString() => status;
}
