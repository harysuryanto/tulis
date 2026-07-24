import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tulis/constants/notion_theme.dart';
import 'package:tulis/models/text_document.dart';
import 'package:tulis/providers/documents_provider.dart';
import 'package:tulis/widgets/page_wrapper.dart';
import 'package:tulis/widgets/text_editor.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDocumentId = ref.watch(selectedDocumentIdProvider);
    final documents = ref.watch(documentsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textMuted = isDark
        ? NotionColors.darkTextMuted
        : NotionColors.lightTextMuted;
    final textPrimary = isDark
        ? NotionColors.darkTextPrimary
        : NotionColors.lightTextPrimary;
    final buttonBg = isDark
        ? NotionColors.darkActive
        : NotionColors.lightActive;

    final selectedDoc = selectedDocumentId != null
        ? documents[selectedDocumentId]
        : null;

    Widget content;
    if (selectedDoc == null) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 48, color: textMuted),
            const SizedBox(height: 16),
            Text(
              'No document selected',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create a new page or select one from the sidebar.',
              style: TextStyle(fontSize: 13, color: textMuted),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonBg,
                foregroundColor: textPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              onPressed: () => createNewDocument(ref),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Create page', style: TextStyle(fontSize: 13)),
            ),
          ],
        ),
      );
    } else {
      final isTrashed = selectedDoc.deletedAt != null;
      content = Column(
        children: [
          if (isTrashed) _TrashBanner(document: selectedDoc),
          Expanded(
            child: TextEditor(
              key: ValueKey(selectedDoc.id),
              textDocument: selectedDoc,
              readOnly: isTrashed,
            ),
          ),
        ],
      );
    }

    return PageWrapper(
      child: Column(children: [Expanded(child: content)]),
    );
  }
}

class _TrashBanner extends ConsumerWidget {
  const _TrashBanner({required this.document});

  final TextDocument document;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bannerBg = isDark ? const Color(0xFF372E1A) : const Color(0xFFFBF3DB);
    final borderBg = isDark ? const Color(0xFF5C4922) : const Color(0xFFF4E3B9);
    final textPrimary = isDark
        ? const Color(0xFFF1F1F1)
        : const Color(0xFF37352F);
    final textMuted = isDark
        ? NotionColors.darkTextMuted
        : NotionColors.lightTextMuted;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bannerBg,
        border: Border(bottom: BorderSide(color: borderBg)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Row(
            children: [
              Icon(
                Icons.delete_outline,
                size: 18,
                color: isDark ? Colors.amber[300] : Colors.amber[900],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'This page is in the trash.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: isDark
                      ? NotionColors.darkActive
                      : NotionColors.lightActive,
                  foregroundColor: textPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () {
                  restoreDocument(ref, document.id);
                  ref.read(isTrashModeProvider.notifier).state = false;
                },
                icon: const Icon(Icons.restore, size: 14),
                label: const Text(
                  'Restore page',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Delete permanently',
                icon: Icon(Icons.delete_forever, size: 16, color: textMuted),
                onPressed: () {
                  permanentDeleteDocument(ref, document.id);
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
