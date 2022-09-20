import 'package:bluetooth_app_test/logger.dart';
import 'package:bluetooth_app_test/services/storage/shared_preferences_service.dart';
import 'package:bluetooth_app_test/services/storage/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DefaultDateNotifier extends StateNotifier<AsyncValue<DateTime>> {
  DefaultDateNotifier() : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    final defaultDateIso = await SharedPreferencesService().getString(StorageNames.defaultDate);
    final defaultDate = DateTime.tryParse(defaultDateIso);

    state = AsyncValue.data(defaultDate ?? DateTime.now().toLocal());
  }

  void setDefaultDate(DateTime defaultDate) {
    state = AsyncValue.data(defaultDate);
    SharedPreferencesService().setString(StorageNames.defaultDate, defaultDate.toIso8601String());
  }
}
