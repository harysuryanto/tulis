import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tulis/helper.dart';
import 'package:tulis/widgets/pane.dart';

class PageWrapper extends HookWidget {
  const PageWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    const double paneWidth = 200;
    const int paneExpandDuration = 1000;
    const int paneShrinkDuration = 200;
    final isPaneExpanded = useState(true);
    final animationController =
        useAnimationController(duration: const Duration(milliseconds: 400));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Pane
        AnimatedContainer(
          width: isPaneExpanded.value ? paneWidth : 0,
          height: MediaQuery.of(context).size.height,
          duration: Duration(
            milliseconds:
                isPaneExpanded.value ? paneExpandDuration : paneShrinkDuration,
          ),
          curve: isPaneExpanded.value ? Curves.elasticOut : Curves.easeOut,
          color: Colors.grey[200].withOpacity(.5),
          child: FittedBox(
            fit: BoxFit.fitHeight,
            alignment: Alignment.centerLeft,
            child: LimitedBox(
              maxWidth: paneWidth,
              maxHeight: MediaQuery.of(context).size.height,
              child: Pane(isExpanded: isPaneExpanded.value),
            ),
          ),
        ),
        // Main content
        Expanded(
          child: Column(
            children: [
              if (isDesktop) ...[
                WindowTitleBarBox(
                  child: Row(
                    children: [
                      IconButton(
                        icon: AnimatedIcon(
                          size: 18,
                          icon: AnimatedIcons.arrow_menu,
                          progress: animationController,
                        ),
                        onPressed: () {
                          if (isPaneExpanded.value) {
                            isPaneExpanded.value = !isPaneExpanded.value;
                            animationController.forward();
                          } else {
                            isPaneExpanded.value = !isPaneExpanded.value;
                            animationController.reverse();
                          }
                        },
                      ),
                      Expanded(
                        child: MoveWindow(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            color: Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: const Text('✍️ Tulis — by Hary'),
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
              ],
              Expanded(child: SafeArea(child: child)),
            ],
          ),
        ),
      ],
    );
  }
}
