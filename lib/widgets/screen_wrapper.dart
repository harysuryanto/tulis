import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../helper.dart';

class ScreenWrapper extends StatelessWidget {
  const ScreenWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isDesktop) ...[
          WindowTitleBarBox(
            child: Row(
              children: [
                Expanded(
                  child: MoveWindow(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      color: Colors.transparent,
                      padding: const EdgeInsets.only(left: 10),
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
        Expanded(child: child),
      ],
    );
  }
}
