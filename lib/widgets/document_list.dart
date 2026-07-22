import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tulis/constants/notion_theme.dart';
import 'package:tulis/main.dart';
import 'package:tulis/models/text_document.dart';
import 'package:tulis/providers/documents_provider.dart';

class DocumentList extends HookConsumerWidget {
  const DocumentList({super.key});

  static const double itemHeight = 32.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documents = ref.watch(documentsProvider);
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

    final filteredDocs =
        documents.values.where((doc) {
          if (doc.deletedAt != null) return false;
          if (searchQuery.isEmpty) return true;
          final titleMatches = doc.title.toLowerCase().contains(searchQuery);
          final bodyMatches = doc.content.toPlainText().toLowerCase().contains(
            searchQuery,
          );
          return titleMatches || bodyMatches;
        }).toList()..sort((a, b) {
          final dateA = a.updatedAt ?? a.createAt;
          final dateB = b.updatedAt ?? b.createAt;
          return dateB.compareTo(dateA);
        });

    if (filteredDocs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Text(
          searchQuery.isEmpty ? 'No pages yet.' : 'No results found.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: filteredDocs.length * itemHeight,
        child: Stack(
          children: [
            for (int i = 0; i < filteredDocs.length; i++)
              AnimatedPositioned(
                key: ValueKey(filteredDocs[i].id),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                top: i * itemHeight,
                left: 0,
                right: 0,
                height: itemHeight,
                child: _DocumentTile(document: filteredDocs[i]),
              ),
          ],
        ),
      ),
    );
  }
}

class _DocumentTile extends HookConsumerWidget {
  const _DocumentTile({required this.document});

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
        height: DocumentList.itemHeight - 2,
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    onTap: () {
                      final container = ref.container;
                      final docTitle = document.title.isEmpty
                          ? 'Untitled'
                          : document.title;
                      final docId = document.id;

                      deleteDocument(ref, docId);

                      Future.delayed(const Duration(milliseconds: 150), () {
                        final messenger = scaffoldMessengerKey.currentState;
                        if (messenger == null) return;
                        messenger.clearSnackBars();

                        Timer? autoDismissTimer;

                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              '"$docTitle" moved to trash',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            duration: const Duration(seconds: 4),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: isDark
                                ? const Color(0xFF2C2C2C)
                                : const Color(0xFF37352F),
                            action: SnackBarAction(
                              label: 'Restore',
                              textColor: const Color(0xFF6EA8FE),
                              onPressed: () {
                                autoDismissTimer?.cancel();
                                messenger.hideCurrentSnackBar();
                                restoreDocumentContainer(container, docId);
                              },
                            ),
                          ),
                        );

                        autoDismissTimer = Timer(
                          const Duration(seconds: 4),
                          () {
                            messenger.hideCurrentSnackBar();
                          },
                        );
                      });
                    },
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
