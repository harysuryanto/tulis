import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tulis/constants/notion_theme.dart';
import 'package:tulis/helper.dart';
import 'package:tulis/models/text_document.dart';
import 'package:tulis/providers/documents_provider.dart';

void showNotionSearchDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    builder: (context) => const NotionSearchDialog(),
  );
}

class NotionSearchDialog extends HookConsumerWidget {
  const NotionSearchDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final searchController = useTextEditingController();
    final searchQuery = useState('');
    final documents = ref.watch(documentsProvider);

    final bg = isDark ? NotionColors.darkSidebar : NotionColors.lightCanvas;
    final borderBg = isDark
        ? NotionColors.darkBorder
        : NotionColors.lightBorder;
    final textPrimary = isDark
        ? NotionColors.darkTextPrimary
        : NotionColors.lightTextPrimary;
    final textMuted = isDark
        ? NotionColors.darkTextMuted
        : NotionColors.lightTextMuted;
    final hoverBg = isDark ? NotionColors.darkHover : NotionColors.lightHover;

    final query = searchQuery.value.toLowerCase().trim();

    final filteredDocs = documents.values.where((doc) {
      if (query.isEmpty) return true;
      final titleMatches = doc.title.toLowerCase().contains(query);
      final bodyMatches = doc.content.toPlainText().toLowerCase().contains(
        query,
      );
      return titleMatches || bodyMatches;
    }).toList();

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () {
          Navigator.of(context).pop();
        },
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 12,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: Container(
          width: 580,
          constraints: const BoxConstraints(maxHeight: 460),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderBg, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.15),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search Input Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, size: 18, color: textMuted),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        autofocus: true,
                        style: TextStyle(fontSize: 15, color: textPrimary),
                        onChanged: (val) {
                          searchQuery.value = val;
                        },
                        decoration: InputDecoration(
                          hintText: 'Search documents...',
                          hintStyle: TextStyle(
                            fontSize: 15,
                            color: textMuted.withValues(alpha: 0.6),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (searchQuery.value.isNotEmpty)
                      IconButton(
                        icon: Icon(Icons.close, size: 16, color: textMuted),
                        onPressed: () {
                          searchController.clear();
                          searchQuery.value = '';
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 24,
                          minHeight: 24,
                        ),
                      ),
                    if (isDesktop) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: hoverBg,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: borderBg),
                        ),
                        child: Text(
                          'ESC',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: textMuted,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Divider(height: 1, color: borderBg),

              // Search Results List
              Expanded(
                child: filteredDocs.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            query.isEmpty
                                ? 'No documents created yet.'
                                : 'No results found for "$query"',
                            style: TextStyle(fontSize: 13, color: textMuted),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 6,
                        ),
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          final doc = filteredDocs[index];
                          return _SearchDialogItemTile(
                            document: doc,
                            searchQuery: query,
                            onSelect: () {
                              ref
                                      .read(selectedDocumentIdProvider.notifier)
                                      .state =
                                  doc.id;
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
              ),

              // Dialog Footer / Shortcut Hint
              Divider(height: 1, color: borderBg),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      '${filteredDocs.length} ${filteredDocs.length == 1 ? 'result' : 'results'}',
                      style: TextStyle(fontSize: 11, color: textMuted),
                    ),
                    const Spacer(),
                    Text(
                      isDesktop ? 'Tap to open • Esc to close' : 'Tap to open',
                      style: TextStyle(fontSize: 11, color: textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchDialogItemTile extends HookConsumerWidget {
  const _SearchDialogItemTile({
    required this.document,
    required this.searchQuery,
    required this.onSelect,
  });

  final TextDocument document;
  final String searchQuery;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHovered = useState(false);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedId = ref.watch(selectedDocumentIdProvider);
    final isSelected = document.id == selectedId;

    final hoverBg = isDark ? NotionColors.darkHover : NotionColors.lightHover;
    final activeBg = isDark
        ? NotionColors.darkActive
        : NotionColors.lightActive;
    final textPrimary = isDark
        ? NotionColors.darkTextPrimary
        : NotionColors.lightTextPrimary;
    final textMuted = isDark
        ? NotionColors.darkTextMuted
        : NotionColors.lightTextMuted;

    final plainText = document.content.toPlainText().trim();
    String previewText = '';
    if (plainText.isNotEmpty && plainText != '\n') {
      previewText = plainText.replaceAll('\n', ' ');
    }

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: isHovered.value
              ? hoverBg
              : (isSelected
                    ? activeBg.withValues(alpha: 0.5)
                    : Colors.transparent),
          borderRadius: BorderRadius.circular(6),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onSelect,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 16,
                  color: isSelected ? textPrimary : textMuted,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.title.isEmpty ? 'Untitled' : document.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: textPrimary,
                        ),
                      ),
                      if (previewText.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          previewText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11, color: textMuted),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.north_west,
                  size: 12,
                  color: isHovered.value ? textMuted : Colors.transparent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
