import 'dart:io';

import 'package:intl/intl.dart';

bool get isDesktop {
  return Platform.isLinux || Platform.isMacOS || Platform.isWindows;
}

String formatDate(DateTime date) {
  return DateFormat('MMM d, yyyy').format(date);
}
