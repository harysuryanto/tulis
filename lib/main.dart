import 'dart:convert';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:window_manager/window_manager.dart';

import 'constants/hive_box_keys.dart';
import 'helper.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('myBox');

  if (isDesktop) {
    await windowManager.ensureInitialized();
    await Window.initialize();
    await Window.hideWindowControls();
    await Window.setEffect(
      effect: WindowEffect.acrylic,
      color: const Color.fromRGBO(0, 27, 38, .1),
    );
  }

  runApp(const MyApp());

  if (isDesktop) {
    doWhenWindowReady(() {
      appWindow.minSize = const Size(450, 500);
      appWindow.title = '✍️ Tulis — by Hary Suryanto';
      appWindow.show();
    });
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WindowListener {
  Box box = Hive.box('myBox');

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);

    restoreWindowSize();
    restoreWindowPosition();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowResize() {
    saveWindowSize();
  }

  @override
  void onWindowMove() {
    saveWindowPosition();
  }

  Future<void> restoreWindowSize() async {
    final windowSizeFromStorage = jsonDecode(box.get(HiveBoxKeys.windowSize));
    if (windowSizeFromStorage != null) {
      final size = Size(
        windowSizeFromStorage['width'],
        windowSizeFromStorage['height'],
      );
      await windowManager.setSize(size);
    }
  }

  Future<void> saveWindowSize() async {
    final size = await windowManager.getSize();
    final Map<String, double> sizeInMap = {
      'width': size.width,
      'height': size.height,
    };
    String json = jsonEncode(sizeInMap);
    box.put(HiveBoxKeys.windowSize, json);
  }

  Future<void> restoreWindowPosition() async {
    final windowPositionFromStorage = box.get(HiveBoxKeys.windowPosition);
    if (windowPositionFromStorage != null) {
      final windowPositionInMap = jsonDecode(windowPositionFromStorage);
      final position = Offset(
        windowPositionInMap['dx'],
        windowPositionInMap['dy'],
      );
      await windowManager.setPosition(position);
    }
  }

  Future<void> saveWindowPosition() async {
    final position = await windowManager.getPosition();
    final Map<String, double> positionInMap = {
      'dx': position.dx,
      'dy': position.dy,
    };
    String json = jsonEncode(positionInMap);
    box.put(HiveBoxKeys.windowPosition, json);
  }

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.blue,
        borderInputColor: Colors.transparent,
      ),
      title: '✍️ Tulis — by Hary Suryanto',
      home: const HomeScreen(),
    );
  }
}
