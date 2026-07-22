import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tulis/constants/notion_theme.dart';
import 'package:tulis/helper.dart';
import 'package:tulis/providers/documents_provider.dart';
import 'package:tulis/widgets/document_list.dart';
import 'package:tulis/widgets/search_dialog.dart';

class Sidebar extends HookConsumerWidget {
  const Sidebar({super.key, this.onCloseDrawer});

  final VoidCallback? onCloseDrawer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeModeProvider);
    final canCreateNew = ref.watch(canCreateNewDocumentProvider);

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

          // Dark/Light Theme Switch
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: _SidebarItem(
              icon: themeMode == ThemeMode.dark
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
              label: themeMode == ThemeMode.dark ? 'Dark Mode' : 'Light Mode',
              onTap: () {
                toggleThemeMode(ref);
              },
            ),
          ),

          const SizedBox(height: 12),
          // Section header: PRIVATE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              'PRIVATE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: textMuted,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Documents List
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: DocumentList(),
            ),
          ),

          Divider(height: 1, color: borderBg),

          // "+ New page" Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _SidebarItem(
              icon: Icons.add,
              label: 'New page',
              onTap: canCreateNew ? () => createNewDocument(ref) : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends HookConsumerWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    this.onTap,
    this.shortcutHint,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final String? shortcutHint;

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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
