import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tulis/constants/notion_theme.dart';
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

    final nonTrashedDocs = documents.values
        .where((d) => d.deletedAt == null)
        .toList();
    final hasActiveDoc =
        selectedDocumentId != null &&
        documents.containsKey(selectedDocumentId) &&
        documents[selectedDocumentId]!.deletedAt == null;

    Widget content;
    if (nonTrashedDocs.isEmpty || !hasActiveDoc) {
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
      content = TextEditor(
        key: ValueKey(documents[selectedDocumentId]!.id),
        textDocument: documents[selectedDocumentId]!,
      );
    }

    return PageWrapper(
      child: Column(
        children: [
          Expanded(child: content),
          // Prevent content blocked by virtual keyboard
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
