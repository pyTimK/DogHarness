import 'package:bluetooth_app_test/state_notifiers/step_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stepProvider = StateNotifierProvider<StepNotifier, int>((ref) {
  return StepNotifier();
});
