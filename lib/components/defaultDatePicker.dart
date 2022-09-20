import 'package:bluetooth_app_test/helpers/date_helper.dart';
import 'package:bluetooth_app_test/providers.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DefaultDatePicker extends ConsumerWidget {
  const DefaultDatePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime? date = ref.watch(defaultDateProvider).value;

    onTapHandler() async {
      var newDate = await showDatePicker(
        context: context,
        initialDate: date ?? DateTime.now(),
        firstDate: DateTime(2010),
        lastDate: DateTime(2030),
      );
      if (newDate != null) {
        ref.read(defaultDateProvider.notifier).setDefaultDate(newDate);
      }
    }

    return GestureDetector(
      onTap: onTapHandler,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: MyStyles.dark),
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Text(DateHelper.formatMonthYear(date), style: MyStyles.p),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, color: MyStyles.dark),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
