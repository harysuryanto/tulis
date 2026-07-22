import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tulis/constants/notion_theme.dart';
import 'package:tulis/models/text_document.dart';
import 'package:tulis/providers/documents_provider.dart';

class DocumentList extends HookConsumerWidget {
  const DocumentList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documents = ref.watch(documentsProvider);
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

    final filteredDocs = documents.values.where((doc) {
      if (searchQuery.isEmpty) return true;
      final titleMatches = doc.title.toLowerCase().contains(searchQuery);
      final bodyMatches = doc.content.toPlainText().toLowerCase().contains(
        searchQuery,
      );
      return titleMatches || bodyMatches;
    }).toList();

    if (filteredDocs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Text(
          searchQuery.isEmpty ? 'No pages yet.' : 'No results found.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: filteredDocs.length,
      itemBuilder: (context, index) {
        final document = filteredDocs[index];
        return _NotionDocumentTile(
          key: ValueKey(document.id),
          document: document,
        );
      },
    );
  }
}

class _NotionDocumentTile extends HookConsumerWidget {
  const _NotionDocumentTile({super.key, required this.document});

  final TextDocument document;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedDocumentIdProvider);
    final isSelected = document.id == selectedId;
    final isHovered = useState(false);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final hoverColor = isDark
        ? NotionColors.darkHover
        : NotionColors.lightHover;
    final activeColor = isDark
        ? NotionColors.darkActive
        : NotionColors.lightActive;

    Color tileColor = Colors.transparent;
    if (isSelected) {
      tileColor = activeColor;
    } else if (isHovered.value) {
      tileColor = hoverColor;
    }

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 1),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () {
            ref.read(selectedDocumentIdProvider.notifier).state = document.id;
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 16,
                  color: isSelected
                      ? (isDark
                            ? NotionColors.darkTextPrimary
                            : NotionColors.lightTextPrimary)
                      : (isDark
                            ? NotionColors.darkTextMuted
                            : NotionColors.lightTextMuted),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    document.title.isEmpty ? 'Untitled' : document.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isDark
                          ? NotionColors.darkTextPrimary
                          : NotionColors.lightTextPrimary,
                    ),
                  ),
                ),
                if (isHovered.value || isSelected) ...[
                  const SizedBox(width: 4),
                  InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: () => deleteDocument(ref, document.id),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        Icons.close,
                        size: 14,
                        color: isDark
                            ? NotionColors.darkTextMuted
                            : NotionColors.lightTextMuted,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
