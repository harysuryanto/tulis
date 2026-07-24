import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tulis/constants/notion_theme.dart';
import 'package:tulis/helper.dart';
import 'package:tulis/providers/documents_provider.dart';
import 'package:tulis/widgets/document_list.dart';
import 'package:tulis/widgets/search_dialog.dart';
import 'package:tulis/widgets/trash_document_list.dart';

class Sidebar extends HookConsumerWidget {
  const Sidebar({super.key, this.onCloseDrawer});

  final VoidCallback? onCloseDrawer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeModeProvider);
    final canCreateNew = ref.watch(canCreateNewDocumentProvider);
    final isTrashMode = ref.watch(isTrashModeProvider);
    final trashCount = ref.watch(trashCountProvider);

    final sidebarBg = isDark
        ? NotionColors.darkSidebar
        : NotionColors.lightSidebar;
    final borderBg = isDark
        ? NotionColors.darkBorder
        : NotionColors.lightBorder;
    final textMuted = isDark
        ? NotionColors.darkTextMuted
        : NotionColors.lightTextMuted;
    final textPrimary = isDark
        ? NotionColors.darkTextPrimary
        : NotionColors.lightTextPrimary;

    return Container(
      width: 240,
      color: sidebarBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar Header (Workspace selector)
          Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 8,
              top: 12,
              bottom: 8,
            ),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: isDark
                        ? NotionColors.darkHover
                        : NotionColors.lightActive,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.center,
                  child: const Text('✍️', style: TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tulis Workspace',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onCloseDrawer != null)
                  IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    onPressed: onCloseDrawer,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 28,
                      minHeight: 28,
                    ),
                  ),
              ],
            ),
          ),

          // Search Bar Trigger
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: _SidebarItem(
              icon: Icons.search,
              label: 'Search',
              shortcutHint: isDesktop
                  ? (Platform.isMacOS ? '⌘P' : 'Ctrl+P')
                  : null,
              onTap: () {
                if (onCloseDrawer != null) onCloseDrawer!();
                showSearchDialog(context, ref);
              },
            ),
          ),

          // Theme Switcher (System / Light / Dark)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: _SidebarItem(
              customIcon: AnimatedRotation(
                turns: switch (themeMode) {
                  ThemeMode.system => 0.0,
                  ThemeMode.light => 0.5,
                  ThemeMode.dark => 1.0,
                },
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    switch (themeMode) {
                      ThemeMode.system => Icons.brightness_auto_outlined,
                      ThemeMode.light => Icons.light_mode_outlined,
                      ThemeMode.dark => Icons.dark_mode_outlined,
                    },
                    key: ValueKey(themeMode),
                    size: 16,
                    color: textMuted,
                  ),
                ),
              ),
              label: switch (themeMode) {
                ThemeMode.system => 'System Theme',
                ThemeMode.light => 'Light Mode',
                ThemeMode.dark => 'Dark Mode',
              },
              onTap: () {
                toggleThemeMode(ref);
              },
            ),
          ),

          const SizedBox(height: 12),

          // Back button (animates in/out)
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOutCubic,
            child: AnimatedOpacity(
              opacity: isTrashMode ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: isTrashMode
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: _SidebarItem(
                        icon: Icons.arrow_back,
                        label: 'Back to pages',
                        onTap: () {
                          ref.read(isTrashModeProvider.notifier).state = false;
                        },
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),

          // Section header with animated crossfade
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, anim) =>
                FadeTransition(opacity: anim, child: child),
            child: Padding(
              key: ValueKey(isTrashMode ? 'trash' : 'private'),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(
                isTrashMode ? 'TRASH' : 'PRIVATE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: textMuted,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          // Documents List or Trash List with slide + fade transition
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                switchInCurve: Curves.easeInOutCubic,
                switchOutCurve: Curves.easeInOutCubic,
                transitionBuilder: (child, animation) {
                  final isNew = child.key == const ValueKey('trash');
                  final offset = isNew
                      ? const Offset(0.3, 0.0)
                      : const Offset(-0.3, 0.0);
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: offset,
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: SizedBox.expand(
                  key: isTrashMode
                      ? const ValueKey('trash')
                      : const ValueKey('docs'),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: isTrashMode
                        ? TrashDocumentList(onCloseDrawer: onCloseDrawer)
                        : DocumentList(onCloseDrawer: onCloseDrawer),
                  ),
                ),
              ),
            ),
          ),

          Divider(height: 1, color: borderBg),

          // Trash Nav Item (always visible)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: _SidebarItem(
              icon: Icons.delete_outline,
              label: 'Trash',
              trailing: trashCount > 0
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? NotionColors.darkHover
                            : NotionColors.lightActive,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$trashCount',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: textMuted,
                        ),
                      ),
                    )
                  : null,
              onTap: isTrashMode
                  ? null
                  : () {
                      ref.read(isTrashModeProvider.notifier).state = true;
                    },
            ),
          ),

          // "+ New page" Button (animates out in trash mode)
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOutCubic,
            child: AnimatedOpacity(
              opacity: isTrashMode ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: isTrashMode
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _SidebarItem(
                        icon: Icons.add,
                        label: 'New page',
                        onTap: canCreateNew
                            ? () {
                                createNewDocument(ref);
                                onCloseDrawer?.call();
                              }
                            : null,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends HookConsumerWidget {
  const _SidebarItem({
    this.icon,
    this.customIcon,
    required this.label,
    this.onTap,
    this.shortcutHint,
    this.trailing,
  });

  final IconData? icon;
  final Widget? customIcon;
  final String label;
  final VoidCallback? onTap;
  final String? shortcutHint;
  final Widget? trailing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHovered = useState(false);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEnabled = onTap != null;

    final hoverBg = isDark ? NotionColors.darkHover : NotionColors.lightHover;
    final textMuted = isDark
        ? NotionColors.darkTextMuted
        : NotionColors.lightTextMuted;
    final textPrimary = isEnabled
        ? (isDark
              ? NotionColors.darkTextPrimary
              : NotionColors.lightTextPrimary)
        : textMuted.withValues(alpha: 0.38);

    return MouseRegion(
      onEnter: (_) => isHovered.value = isEnabled,
      onExit: (_) => isHovered.value = false,
      child: Container(
        decoration: BoxDecoration(
          color: (isHovered.value && isEnabled) ? hoverBg : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                customIcon ??
                    Icon(
                      icon,
                      size: 16,
                      color: isEnabled
                          ? textMuted
                          : textMuted.withValues(alpha: 0.38),
                    ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(fontSize: 13, color: textPrimary),
                  ),
                ),
                if (shortcutHint != null)
                  Text(
                    shortcutHint!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: textMuted,
                    ),
                  ),
                ?trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
