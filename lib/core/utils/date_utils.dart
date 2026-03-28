// lib/core/utils/date_utils.dart
import 'package:intl/intl.dart';

DateTime combineDateAndTime(DateTime date, DateTime time) {
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

DateTime startOfWeek(DateTime value) {
  return value.subtract(Duration(days: value.weekday - 1));
}

DateTime endOfWeek(DateTime value) {
  return startOfWeek(value).add(const Duration(days: 6));
}

String formatDurationLabel(Duration duration) {
  final int minutes = duration.inMinutes;
  final int hours = minutes ~/ 60;
  final int remainingMinutes = minutes % 60;
  if (hours == 0) {
    return '${remainingMinutes}m';
  }
  return '${hours}h ${remainingMinutes}m';
}

String formatCsvDate(DateTime? value) {
  if (value == null) {
    return '';
  }
  return DateFormat('yyyy-MM-dd HH:mm').format(value);
}
