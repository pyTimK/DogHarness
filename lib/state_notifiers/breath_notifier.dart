import 'dart:math';

import 'package:bluetooth_app_test/constants.dart';
import 'package:bluetooth_app_test/logger.dart';
import 'package:bluetooth_app_test/services/storage/shared_preferences_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _storageService = SharedPreferencesService();

class BreathNotifier extends StateNotifier<List<int>> {
  BreathNotifier() : super([0]);

  Future<void> reset() async {
    await _storageService.setInt(StorageNames.breathPerMin, 0);
    state = [0];
  }

  Future<void> add(int distance) async {
    final distanceListNew = List<int>.from(state);
    // distanceListNew.add(value);
    // final distanceListNew = state;
    distanceListNew.add(distance);

    state = distanceListNew;
  }
}
