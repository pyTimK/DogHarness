import 'package:bluetooth_app_test/state_notifiers/breath_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final breathProvider = StateNotifierProvider<BreathNotifier, List<int>>((ref) {
  return BreathNotifier();
});
