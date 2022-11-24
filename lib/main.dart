import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';

import 'helper.dart';
import 'text_editor.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (isDesktop) {
    await Window.initialize();
    await Window.hideWindowControls();
    await Window.setEffect(
      effect: WindowEffect.acrylic,
      color: const Color.fromRGBO(0, 27, 38, .5),
    );
  }

  runApp(const MyApp());

  if (isDesktop) {
    doWhenWindowReady(() {
      appWindow.size = const Size(500, 600);
      appWindow.minSize = const Size(300, 300);
      appWindow.title = 'Tulis';
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
        borderInputColor: Colors.transparent,
      ),
      title: 'Tulis',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          if (isDesktop)
            WindowTitleBarBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: MoveWindow(
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        child: const Text('✍️ Tulis'),
                      ),
                    ),
                  ),
                  MinimizeWindowButton(
                    colors: WindowButtonColors(iconNormal: Colors.white),
                  ),
                  MaximizeWindowButton(
                    colors: WindowButtonColors(iconNormal: Colors.white),
                  ),
                  CloseWindowButton(
                    colors: WindowButtonColors(
                      iconNormal: Colors.white,
                      mouseOver: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          const Expanded(child: TextEditor()),

          // Prevent content blocked by virtual keyboard
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
