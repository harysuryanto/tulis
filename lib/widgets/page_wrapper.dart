import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tulis/helper.dart';

class PageWrapper extends HookWidget {
  const PageWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isPaneExpanded = useState(true);
    final animationController =
        useAnimationController(duration: const Duration(milliseconds: 400));

    return Stack(
      children: [
        // Pane background
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: AnimatedContainer(
            width: isPaneExpanded.value ? 200 : 0,
            duration: Duration(milliseconds: isPaneExpanded.value ? 400 : 200),
            curve: isPaneExpanded.value ? Curves.easeOutBack : Curves.easeOut,
            color: isPaneExpanded.value
                ? Colors.grey[200].withOpacity(.5)
                : Colors.transparent,
          ),
        ),
        // Pane content
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: 200,
          child: _Pane(isPaneExpanded: isPaneExpanded.value),
        ),
        // Main content
        AnimatedPositioned(
          duration: Duration(milliseconds: isPaneExpanded.value ? 400 : 200),
          curve: isPaneExpanded.value ? Curves.easeOutBack : Curves.easeOut,
          left: isPaneExpanded.value ? 200 : 0,
          top: 0,
          right: 0,
          bottom: 0,
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

class _Pane extends StatelessWidget {
  const _Pane({
    required this.isPaneExpanded,
  });

  final bool isPaneExpanded;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isPaneExpanded ? 1 : 0,
      duration: const Duration(milliseconds: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: appWindow.titleBarButtonSize.height,
            child: MoveWindow(),
          ),
          const Text('This is pane'),
        ],
      ),
    );
  }
}
