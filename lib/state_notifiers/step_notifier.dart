import 'package:bluetooth_app_test/constants.dart';
import 'package:bluetooth_app_test/services/storage/shared_preferences_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _storageService = SharedPreferencesService();

class StepNotifier extends StateNotifier<int> {
  StepNotifier() : super(0) {
    refresh();
  }

  Future<void> refresh() async {
    state = await _storageService.getInt(StorageNames.steps);
  }

  Future<void> reset() async {
    await _storageService.setInt(StorageNames.steps, 0);
    state = 0;
  }

  Future<void> set(int steps) async {
    await _storageService.setInt(StorageNames.steps, steps);
    state = steps;
  }

  Future<void> add() async {
    final steps = state + 1;
    await _storageService.setInt(StorageNames.steps, steps);
    state = steps;
  }
}
