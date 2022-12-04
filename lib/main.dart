import 'dart:convert';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tulis/constants/hive_box_keys.dart';
import 'package:tulis/constants/hive_boxes.dart';
import 'package:tulis/helper.dart';
import 'package:tulis/models/window_position.dart';
import 'package:tulis/models/window_size.dart';
import 'package:tulis/pages/home_page.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox(HiveBoxes.myBox);

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
      appWindow.minSize = const Size(500, 200);
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
  Box box = Hive.box(HiveBoxes.myBox);

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
    final windowSizeFromStorage = box.get(HiveBoxKeys.windowSize) as String?;
    final windowSize = WindowSize.fromMap(
      jsonDecode(windowSizeFromStorage!) as Map<String, dynamic>,
    );
    await windowManager.setSize(Size(windowSize.width, windowSize.height));
  }

  Future<void> saveWindowSize() async {
    final size = await windowManager.getSize();
    final windowSize =
        WindowSize(width: size.width, height: size.height).toMap();
    box.put(HiveBoxKeys.windowSize, jsonEncode(windowSize));
  }

  Future<void> restoreWindowPosition() async {
    final windowPositionFromStorage =
        box.get(HiveBoxKeys.windowPosition) as String?;
    if (windowPositionFromStorage != null) {
      final windowPosition = WindowPosition.fromMap(
        jsonDecode(windowPositionFromStorage) as Map<String, dynamic>,
      );
      await windowManager
          .setPosition(Offset(windowPosition.dx, windowPosition.dy));
    }
  }

  Future<void> saveWindowPosition() async {
    final position = await windowManager.getPosition();
    final windowPosition =
        WindowPosition(dx: position.dx, dy: position.dy).toMap();
    box.put(HiveBoxKeys.windowPosition, jsonEncode(windowPosition));
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
      home: const HomePage(),
    );
  }
}
