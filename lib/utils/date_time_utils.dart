import 'package:intl/intl.dart';
import 'package:food_app/core/exceptions/app_exceptions.dart';

/// Utility helpers for parsing and formatting date/time using EU conventions.
class DateTimeUtils {
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');
  final DateFormat _dateTimeFormat = DateFormat('dd-MM-yyyy HH:mm');

  /// Parses a date string in the form `dd-MM-yyyy`.
  DateTime parseDate(String input) {
    try {
      return _dateFormat.parseStrict(input);
    } catch (_) {
      throw InvalidInputFormatException(input);
    }
  }

  /// Parses a date and time string in the form `dd-MM-yyyy HH:mm`.
  DateTime parseDateTime(String input) {
    try {
      return _dateTimeFormat.parseStrict(input);
    } catch (_) {
      throw InvalidInputFormatException(input);
    }
  }

  /// Formats a [DateTime] as `dd-MM-yyyy` or returns `N/A` if invalid.
  String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    try {
      return _dateFormat.format(date);
    } catch (_) {
      return 'N/A';
    }
  }

  /// Formats a [DateTime] including time using 24-hour clock.
  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    try {
      return _dateTimeFormat.format(dateTime);
    } catch (_) {
      return 'N/A';
    }
  }
}
