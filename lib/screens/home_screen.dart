import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../helper.dart';
import '../widgets/screen_wrapper.dart';
import '../widgets/text_editor.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: Column(
        children: [
          if (isDesktop) ...[
            WindowTitleBarBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: MoveWindow(
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        child: const Text('✍️ Tulis — by Hary Suryanto'),
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
            const SizedBox(height: 10),
          ],
          const Expanded(child: TextEditor()),

          // Prevent content blocked by virtual keyboard
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
