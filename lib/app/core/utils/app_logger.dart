import 'package:logger/logger.dart';

/// App-wide logger. Usage:
///   final log = appLogger(MyClass);
///   log.i('Info message');
///   log.e('Error message');
Logger appLogger(Type origin) {
  return Logger(
    printer: PrefixPrinter(
      PrettyPrinter(methodCount: 0, errorMethodCount: 5, lineLength: 80),
      debug: origin.toString(),
    ),
  );
}

/// Quick access top-level logger for non-class usage.
final log = appLogger(Object);
