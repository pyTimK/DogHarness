import 'package:bluetooth_app_test/constants.dart';
import 'package:bluetooth_app_test/state_notifiers/pulse_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pulseProvider = StateNotifierProvider<PulseNotifier, List<int>>((ref) {
  return PulseNotifier();
});
