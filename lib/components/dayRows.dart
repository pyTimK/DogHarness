import 'package:bluetooth_app_test/components/bouncing.dart';
import 'package:bluetooth_app_test/functions/utils.dart';
import 'package:bluetooth_app_test/helpers/date_helper.dart';
import 'package:bluetooth_app_test/logger.dart';
import 'package:bluetooth_app_test/pages/mainPages/home.dart';
import 'package:bluetooth_app_test/providers/providers.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DayRows extends ConsumerStatefulWidget {
  const DayRows({super.key});

  @override
  DayRowsState createState() => DayRowsState();
}

class DayRowsState extends ConsumerState<DayRows> {
  final _scrollController = ScrollController();
  static const cardWidth = 50.0;
  static const dividerWidth = 35.0;

  _onDateCardPress(DateTime date) {
    logger.wtf("PRESSED ${getFormattedDate(date)}");
    ref.read(defaultDateProvider.notifier).state = date;
  }

  _updateScroll(DateTime date) {
    final day = date.day;
    final screenWidth = MediaQuery.of(context).size.width;
    var scrollPosition =
        (day - 1) * (cardWidth + dividerWidth) - screenWidth / 2 + HomePageState.horizontalPadding + cardWidth / 2;

    scrollPosition = math.max(0, scrollPosition);

    _scrollController.animateTo(
      scrollPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScroll(ref.read(defaultDateProvider));
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime defaultDate = ref.watch(defaultDateProvider);
    ref.listen(defaultDateProvider, (oldDate, newDate) {
      _updateScroll(newDate);
    });
    return SizedBox(
      height: 60,
      child: ListView.separated(
        controller: _scrollController,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: DateHelper.getNumberOfDays(defaultDate),
        itemBuilder: (context, index) {
          final date = DateHelper.getDateFromIndex(defaultDate, index);
          final dayAbrv = DateHelper.formatDayAbrv(date);
          final isSelected = DateHelper.isSameDay(date, defaultDate);
          final backgrounColor = isSelected ? MyStyles.dark : MyStyles.white;
          final textColor = isSelected ? MyStyles.white : MyStyles.dark;
          return SizedBox(
            width: DayRowsState.cardWidth,
            child: Bouncing(
              onPressed: () => _onDateCardPress(date),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: backgrounColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(dayAbrv, style: MyStyles.p.colour(textColor)),
                      const SizedBox(height: 5),
                      Text('${date.day}', style: MyStyles.p.colour(textColor)),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          width: DayRowsState.dividerWidth,
        ),
      ),
    );
  }
}
