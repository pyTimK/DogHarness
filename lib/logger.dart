/// This file exports the logger function
/// which is used to log custom-designed messages to the console.
import 'package:logger/logger.dart';

Logger _logger({Level level = Level.verbose}) => Logger(
      printer: _CustomerPrinter(),
      level: level,
    );

class _CustomerPrinter extends LogPrinter {
  // final String className;
  // CustomerPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.levelColors[event.level];
    final emoji = PrettyPrinter.levelEmojis[event.level];
    final message = event.message;

    return [color!('$emoji: $message')];
  }
}

var logger = _logger();
