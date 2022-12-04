import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tulis/models/document.dart';
import 'package:tulis/providers/documents_provider.dart';

class DocumentList extends HookConsumerWidget {
  const DocumentList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documents = ref.watch(documentsProvider);
    return ListView.builder(
      itemBuilder: (context, index) {
        final data = documents[index];
        return _MyListTile(data: data);
      },
      itemCount: documents.length,
    );
  }
}

class _MyListTile extends HookConsumerWidget {
  const _MyListTile({
    required this.data,
  });

  final Document data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDocumentId = ref.watch(selectedDocumentIdProvider);
    final isHovered = useState(false);

    void openDocument() {
      ref
          .read(selectedDocumentIdProvider.notifier)
          .update((id) => id = data.id);
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
            child: Text(
              data.title,
              style: data.id == selectedDocumentId
                  ? const TextStyle(fontWeight: FontWeight.bold)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
