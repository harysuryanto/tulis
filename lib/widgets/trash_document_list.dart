import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tulis/constants/notion_theme.dart';
import 'package:tulis/helper.dart';
import 'package:tulis/models/text_document.dart';
import 'package:tulis/providers/documents_provider.dart';

class TrashDocumentList extends HookConsumerWidget {
  const TrashDocumentList({super.key, this.onCloseDrawer});

  final VoidCallback? onCloseDrawer;

  static const double itemHeight = 32.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trashedDocs = ref.watch(trashedDocumentsProvider);

    final sortedDocs = trashedDocs.values.toList()
      ..sort((a, b) {
        final dateA = a.deletedAt ?? a.updatedAt ?? a.createAt;
        final dateB = b.deletedAt ?? b.updatedAt ?? b.createAt;
        return dateB.compareTo(dateA);
      });

    if (sortedDocs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Text(
          'Trash is empty.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: sortedDocs.length * itemHeight,
        child: Stack(
          children: [
            for (int i = 0; i < sortedDocs.length; i++)
              AnimatedPositioned(
                key: ValueKey(sortedDocs[i].id),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                top: i * itemHeight,
                left: 0,
                right: 0,
                height: itemHeight,
                child: _TrashDocumentTile(
                  document: sortedDocs[i],
                  onCloseDrawer: onCloseDrawer,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TrashDocumentTile extends HookConsumerWidget {
  const _TrashDocumentTile({required this.document, this.onCloseDrawer});

  final TextDocument document;
  final VoidCallback? onCloseDrawer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHovered = useState(false);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final hoverColor = isDark
        ? NotionColors.darkHover
        : NotionColors.lightHover;

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: Container(
        height: TrashDocumentList.itemHeight - 2,
        margin: const EdgeInsets.symmetric(vertical: 1),
        decoration: BoxDecoration(
          color: isHovered.value ? hoverColor : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () {
            ref.read(selectedDocumentIdProvider.notifier).state = document.id;
            onCloseDrawer?.call();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 16,
                  color: isDark
                      ? NotionColors.darkTextMuted
                      : NotionColors.lightTextMuted,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    document.title.isEmpty ? 'Untitled' : document.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? NotionColors.darkTextPrimary
                          : NotionColors.lightTextPrimary,
                    ),
                  ),
                ),
                if (!isDesktop || isHovered.value) ...[
                  const SizedBox(width: 4),
                  InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: () {
                      restoreDocument(ref, document.id);
                      onCloseDrawer?.call();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        Icons.restore,
                        size: 14,
                        color: isDark
                            ? NotionColors.darkTextMuted
                            : NotionColors.lightTextMuted,
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: () => permanentDeleteDocument(ref, document.id),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        Icons.delete_forever,
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
