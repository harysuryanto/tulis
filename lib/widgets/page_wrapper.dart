import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tulis/widgets/pane.dart';

class PageWrapper extends HookConsumerWidget {
  const PageWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double paneWidth = 200;
    const int paneExpandDuration = 1000;
    const int paneShrinkDuration = 200;
    final isPaneExpanded = useState(true);
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );

    final isSmallScreen = MediaQuery.of(context).size.width <= 600;

    useEffect(() {
      if (isSmallScreen) {
        isPaneExpanded.value = false;
      }
      return null;
    }, [isSmallScreen]);

    if (isSmallScreen) {
      return Stack(
        children: [
          Column(
            children: [
              SafeArea(
                top: true,
                bottom: false,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isPaneExpanded.value ? Icons.close : Icons.menu,
                        ),
                        onPressed: () {
                          isPaneExpanded.value = !isPaneExpanded.value;
                        },
                      ),
                      const Text('✍️ Tulis — by Hary'),
                    ],
                  ),
                ),
              ),
              Expanded(child: SafeArea(child: child)),
            ],
          ),
          if (isPaneExpanded.value)
            GestureDetector(
              onTap: () => isPaneExpanded.value = false,
              child: Container(color: Colors.black.withValues(alpha: .3)),
            ),
          AnimatedPositioned(
            left: isPaneExpanded.value ? 0 : -MediaQuery.of(context).size.width,
            top: 0,
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color:
                      Colors.grey[200]?.withValues(alpha: .5) ??
                      Colors.grey.withValues(alpha: .5),
                  child: Column(
                    children: [
                      SafeArea(
                        top: true,
                        bottom: false,
                        child: Row(
                          children: [
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => isPaneExpanded.value = false,
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: Pane(isExpanded: isPaneExpanded.value)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Pane
          AnimatedContainer(
            width: isPaneExpanded.value ? paneWidth : 0,
            height: MediaQuery.of(context).size.height,
            duration: Duration(
              milliseconds: isPaneExpanded.value
                  ? paneExpandDuration
                  : paneShrinkDuration,
            ),
            curve: isPaneExpanded.value ? Curves.elasticOut : Curves.easeOut,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Theme.of(context).cardColor,
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
              ),
            ),
          ),
          // Main content
          Expanded(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
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
                ),
                Expanded(child: SafeArea(child: child)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
