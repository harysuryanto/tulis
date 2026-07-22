import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tulis/constants/notion_theme.dart';
import 'package:tulis/providers/documents_provider.dart';

class TopBar extends HookConsumerWidget {
  const TopBar({
    super.key,
    required this.onToggleSidebar,
    required this.isSidebarVisible,
  });

  final VoidCallback onToggleSidebar;
  final bool isSidebarVisible;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedId = ref.watch(selectedDocumentIdProvider);
    final documents = ref.watch(documentsProvider);

    final selectedDoc = selectedId != null ? documents[selectedId] : null;
    final docTitle = selectedDoc?.title ?? 'Tulis';

    final textPrimary = isDark
        ? NotionColors.darkTextPrimary
        : NotionColors.lightTextPrimary;
    final textMuted = isDark
        ? NotionColors.darkTextMuted
        : NotionColors.lightTextMuted;

    // Sidebar AnimatedIcon Controller
    final sidebarAnimController = useAnimationController(
      duration: const Duration(milliseconds: 250),
      initialValue: isSidebarVisible ? 1.0 : 0.0,
    );

    useEffect(() {
      if (isSidebarVisible) {
        sidebarAnimController.forward();
      } else {
        sidebarAnimController.reverse();
      }
      return null;
    }, [isSidebarVisible]);

    final canCreateNew = ref.watch(canCreateNewDocumentProvider);

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          // Sidebar Toggle Button with AnimatedIcon (menu_close)
          _TopBarIconButton(
            customIcon: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: sidebarAnimController,
              size: 16,
              color: textPrimary,
            ),
            tooltip: isSidebarVisible ? 'Close sidebar' : 'Open sidebar',
            onPressed: onToggleSidebar,
          ),
          const SizedBox(width: 8),

          // Breadcrumbs
          Expanded(
            child: Row(
              children: [
                Text('Tulis', style: TextStyle(fontSize: 13, color: textMuted)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    '/',
                    style: TextStyle(
                      fontSize: 13,
                      color: textMuted.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    docTitle.isEmpty ? 'Untitled' : docTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Dark/Light Theme Toggle Button with AnimatedRotation & AnimatedSwitcher
          _TopBarIconButton(
            customIcon: AnimatedRotation(
              turns: isDark ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                  key: ValueKey(isDark),
                  size: 16,
                  color: textPrimary,
                ),
              ),
            ),
            tooltip: 'Toggle Theme',
            onPressed: () => toggleThemeMode(ref),
          ),
          const SizedBox(width: 4),
          _TopBarIconButton(
            icon: Icons.add,
            tooltip: canCreateNew ? 'New page' : 'Untitled page already exists',
            onPressed: canCreateNew ? () => createNewDocument(ref) : null,
          ),
        ],
      ),
    );
  }
}

class _TopBarIconButton extends HookConsumerWidget {
  const _TopBarIconButton({
    this.icon,
    this.customIcon,
    this.onPressed,
    this.tooltip,
  });

  final IconData? icon;
  final Widget? customIcon;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHovered = useState(false);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEnabled = onPressed != null;

    final hoverBg = isDark ? NotionColors.darkHover : NotionColors.lightHover;
    final textMuted = isDark
        ? NotionColors.darkTextMuted
        : NotionColors.lightTextMuted;
    final iconColor = isEnabled
        ? (isDark
              ? NotionColors.darkTextPrimary
              : NotionColors.lightTextPrimary)
        : textMuted.withValues(alpha: 0.38);

    Widget button = MouseRegion(
      onEnter: (_) => isHovered.value = isEnabled,
      onExit: (_) => isHovered.value = false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: (isHovered.value && isEnabled) ? hoverBg : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: IconButton(
          icon: customIcon ?? Icon(icon, size: 16, color: iconColor),
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}
