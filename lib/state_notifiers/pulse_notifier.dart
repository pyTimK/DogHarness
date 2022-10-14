import 'package:bluetooth_app_test/constants.dart';
import 'package:bluetooth_app_test/functions/utils.dart';
import 'package:bluetooth_app_test/services/storage/shared_preferences_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _storageService = SharedPreferencesService();

class PulseNotifier extends StateNotifier<List<int>> {
  PulseNotifier() : super([0]);

  Future<void> reset() async {
    await _storageService.setInt(StorageNames.pulseAve, 0);
    await _storageService.setInt(StorageNames.pulseNum, 0);
    state = [0];
  }

  Future<void> add(int value) async {
    final pulseAve = await _storageService.getInt(StorageNames.pulseAve);
    final pulseNum = await _storageService.getInt(StorageNames.pulseNum);
    final pulseAveNew = getNewAve(pulseAve, pulseNum, value);
    final pulseNumNew = pulseNum + 1;

    await _storageService.setInt(StorageNames.pulseAve, pulseAveNew);
    await _storageService.setInt(StorageNames.pulseNum, pulseNumNew);

    final pulseListNew = List<int>.from(state);
    // pulseListNew.add(value);
    // final pulseListNew = state;
    pulseListNew.add(value);

    state = pulseListNew;
  }
}
