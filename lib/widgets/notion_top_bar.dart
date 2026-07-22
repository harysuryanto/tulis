import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tulis/constants/notion_theme.dart';
import 'package:tulis/providers/documents_provider.dart';

class NotionTopBar extends HookConsumerWidget {
  const NotionTopBar({
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
    final themeMode = ref.watch(themeModeProvider);

    final selectedDoc = selectedId != null ? documents[selectedId] : null;
    final docTitle = selectedDoc?.title ?? 'Tulis';

    final textPrimary = isDark
        ? NotionColors.darkTextPrimary
        : NotionColors.lightTextPrimary;
    final textMuted = isDark
        ? NotionColors.darkTextMuted
        : NotionColors.lightTextMuted;

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          // Sidebar Toggle Button
          _TopBarIconButton(
            icon: Icons.view_sidebar_outlined,
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

          // Right action buttons
          _TopBarIconButton(
            icon: themeMode == ThemeMode.dark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
            tooltip: 'Toggle Theme',
            onPressed: () {
              ref
                  .read(themeModeProvider.notifier)
                  .state = themeMode == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark;
            },
          ),
          const SizedBox(width: 4),
          _TopBarIconButton(
            icon: Icons.add,
            tooltip: 'New page',
            onPressed: () => createNewDocument(ref),
          ),
        ],
      ),
    );
  }
}

class _TopBarIconButton extends HookConsumerWidget {
  const _TopBarIconButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHovered = useState(false);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final hoverBg = isDark ? NotionColors.darkHover : NotionColors.lightHover;
    final iconColor = isDark
        ? NotionColors.darkTextPrimary
        : NotionColors.lightTextPrimary;

    Widget button = MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isHovered.value ? hoverBg : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: IconButton(
          icon: Icon(icon, size: 16, color: iconColor),
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
