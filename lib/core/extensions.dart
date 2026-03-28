// lib/core/extensions.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  Size get screenSize => MediaQuery.sizeOf(this);
}

extension DateTimeX on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);
  bool isSameDate(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  String get weekdayAndDate => DateFormat('EEEE, d MMMM').format(this);
  String get shortLabel => DateFormat('MMM d').format(this);
  String get timeLabel => DateFormat('HH:mm').format(this);
}

extension StringX on String {
  String get capitalized =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  String get firstWord {
    final List<String> parts = trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? this : parts.first;
  }
}
