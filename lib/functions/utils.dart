import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ChangeNotifierProvider wrapWithProviderValues(
//     List providerValues, Widget child) {
//   if (providerValues.isEmpty) {
//     return ChangeNotifierProvider.value(
//       value: null,
//       child: child,
//     );
//   }

//   return ChangeNotifierProvider.value(
//       value: providerValues.first,
//       child: wrapWithProviderValues(providerValues.sublist(1), child));
// }

final DateFormat _timeFormatter = DateFormat('HH:mm:ss');

String getFomrattedTime(DateTime datetime) {
  return _timeFormatter.format(datetime);
}

String getFormattedDate(DateTime datetime) {
  return DateFormat('dd/MM/yyyy').format(datetime);
}
