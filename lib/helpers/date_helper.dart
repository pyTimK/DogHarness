import 'package:intl/intl.dart';

abstract class DateHelper {
  static DateTime get now => DateTime.now().toLocal();

  static int getNumberOfDays(DateTime? inputDate) {
    final date = inputDate ?? now;
    return DateTime(date.year, date.month + 1, 0).day;
  }

  static int getNumberOfDaysToday() {
    return getNumberOfDays(now);
  }

  /// Ex: "Sep, 2022"
  static String formatMonthYear(DateTime? date) {
    return DateFormat('MMM, yyyy').format(date ?? now);
  }

  /// Ex: "Sep, 2022"
  static String formatMonthYearToday() {
    return formatMonthYear(now);
  }

  static DateTime getDateFromIndex(DateTime? inputDate, int index) {
    final date = inputDate ?? now;
    return DateTime(date.year, date.month, index + 1);
  }

  static String formatDayAbrv(DateTime? date) {
    return DateFormat('E').format(date ?? now);
  }

  static bool isSameDay(DateTime? date1, DateTime? date2) {
    return date1?.day == date2?.day && date1?.month == date2?.month && date1?.year == date2?.year;
  }
}
