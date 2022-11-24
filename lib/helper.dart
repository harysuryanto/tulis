import 'dart:io';

bool get isDesktop {
  return Platform.isLinux || Platform.isMacOS || Platform.isWindows;
}
