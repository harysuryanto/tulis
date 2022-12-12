import 'dart:developer';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tulis/models/text_document.dart';
import 'package:tulis/providers/documents_provider.dart';

class DocumentList extends HookConsumerWidget {
  const DocumentList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Migrate to newer state
    final documents = ref.watch(documentsProvider);
    if (documents.isEmpty) {
      return const Text('No documents available. Please add one.');
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        final document = documents.values.toList()[index];
        log(document.id.toString());
        return _MyListTile(document: document);
      },
      itemCount: documents.length,
    );
  }
}

class _MyListTile extends HookConsumerWidget {
  const _MyListTile({
    required this.document,
  });

  final TextDocument document;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDocumentId = ref.watch(selectedDocumentIdProvider);
    final isHovered = useState(false);

    void openDocument() {
      ref
          .read(selectedDocumentIdProvider.notifier)
          .update((id) => id = document.id);
    }

    return GestureDetector(
      onTap: openDocument,
      child: MouseRegion(
        onEnter: (_) => isHovered.value = true,
        onExit: (_) => isHovered.value = false,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(isHovered.value ? .1 : 0),
            border: Border.all(
              color: Colors.white.withOpacity(isHovered.value ? .2 : 0),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  document.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: document.id == selectedDocumentId
                        ? FontWeight.bold
                        : null,
                  ),
                ),
                // Subtitle
                Text(
                  '${document.updatedAt?.second ?? document.createAt}',
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
