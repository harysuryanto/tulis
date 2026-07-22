import 'dart:io';

import 'package:intl/intl.dart';

bool get isDesktop {
  return Platform.isLinux || Platform.isMacOS || Platform.isWindows;
}

String formatDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final dateDay = DateTime(date.year, date.month, date.day);
  final diffDays = today.difference(dateDay).inDays;

  if (diffDays == 0) {
    return 'Today';
  } else if (diffDays == 1) {
    return 'Yesterday';
  } else if (diffDays < 7) {
    const dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return dayNames[date.weekday - DateTime.monday];
  } else if (date.year == now.year) {
    return DateFormat('d MMM').format(date);
  }
  return DateFormat('d MMM yyyy').format(date);
}
