import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tulis/providers/documents_provider.dart';
import 'package:tulis/widgets/page_wrapper.dart';
import 'package:tulis/widgets/text_editor.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDocumentId = ref.watch(selectedDocumentIdProvider);
    final documents = ref.watch(documentsProvider);
    return PageWrapper(
      child: Column(
        children: [
          Expanded(
            child: documents.isEmpty
                ? const Center(child: Text('No data available.'))
                : TextEditor2(
                    key: ValueKey(documents[selectedDocumentId]!.id),
                    textDocument: documents[selectedDocumentId]!,
                  ),
          ),
          // Prevent content blocked by virtual keyboard
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
