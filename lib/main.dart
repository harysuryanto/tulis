import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:hive_flutter/adapters.dart';

import 'helper.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('myBox');

  if (isDesktop) {
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
