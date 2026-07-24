import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tulis/constants/notion_theme.dart';
import 'package:tulis/widgets/search_dialog.dart';
import 'package:tulis/widgets/sidebar.dart';
import 'package:tulis/widgets/top_bar.dart';

class PageWrapper extends HookConsumerWidget {
  const PageWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double sidebarWidth = 240.0;
    final isSidebarExpanded = useState(true);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isSmallScreen = MediaQuery.of(context).size.width < 768;

    useEffect(() {
      if (isSmallScreen) {
        isSidebarExpanded.value = false;
      }
      return null;
    }, [isSmallScreen]);

    final canvasBg = isDark
        ? NotionColors.darkCanvas
        : NotionColors.lightCanvas;
    final sidebarBg = isDark
        ? NotionColors.darkSidebar
        : NotionColors.lightSidebar;
    final borderBg = isDark
        ? NotionColors.darkBorder
        : NotionColors.lightBorder;

    Widget bodyContent;

    if (isSmallScreen) {
      bodyContent = Scaffold(
        backgroundColor: canvasBg,
        body: Stack(
          children: [
            // Main Canvas Area
            Positioned.fill(
              child: Column(
                children: [
                  SafeArea(
                    bottom: false,
                    child: TopBar(
                      isSidebarVisible: isSidebarExpanded.value,
                      onToggleSidebar: () {
                        isSidebarExpanded.value = !isSidebarExpanded.value;
                      },
                    ),
                  ),
                  Expanded(child: child),
                ],
              ),
            ),
            // Mobile Backdrop scrim
            if (isSidebarExpanded.value)
              GestureDetector(
                onTap: () => isSidebarExpanded.value = false,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  color: Colors.black.withValues(alpha: 0.4),
                ),
              ),
            // Mobile Drawer Sidebar
            AnimatedPositioned(
              left: isSidebarExpanded.value ? 0 : -sidebarWidth,
              top: 0,
              bottom: 0,
              width: sidebarWidth,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: Material(
                elevation: 16,
                color: sidebarBg,
                child: SafeArea(
                  child: Sidebar(
                    onCloseDrawer: () => isSidebarExpanded.value = false,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      bodyContent = Scaffold(
        backgroundColor: canvasBg,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Desktop Collapsible Sidebar
            AnimatedContainer(
              width: isSidebarExpanded.value ? sidebarWidth : 0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: ClipRect(
                child: Container(
                  decoration: BoxDecoration(
                    color: sidebarBg,
                    border: Border(
                      right: BorderSide(color: borderBg, width: 1),
                    ),
                  ),
                  child: OverflowBox(
                    minWidth: sidebarWidth,
                    maxWidth: sidebarWidth,
                    alignment: Alignment.topLeft,
                    child: const Sidebar(),
                  ),
                ),
              ),
            ),
            // Main Canvas Area
            Expanded(
              child: Column(
                children: [
                  SafeArea(
                    bottom: false,
                    child: TopBar(
                      isSidebarVisible: isSidebarExpanded.value,
                      onToggleSidebar: () {
                        isSidebarExpanded.value = !isSidebarExpanded.value;
                      },
                    ),
                  ),
                  Expanded(child: child),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyP, meta: true): () {
          showSearchDialog(context, ref);
        },
        const SingleActivator(LogicalKeyboardKey.keyP, control: true): () {
          showSearchDialog(context, ref);
        },
        const SingleActivator(LogicalKeyboardKey.keyK, meta: true): () {
          showSearchDialog(context, ref);
        },
        const SingleActivator(LogicalKeyboardKey.keyK, control: true): () {
          showSearchDialog(context, ref);
        },
      },
      child: Focus(autofocus: true, child: bodyContent),
    );
  }
}
