import 'dart:developer';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tulis/helper.dart';
import 'package:tulis/models/text_document.dart';
import 'package:tulis/providers/documents_provider.dart';

class TextEditor2 extends HookConsumerWidget {
  const TextEditor2({
    super.key,
    required this.textDocument,
  });

  final TextDocument textDocument;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode();
    final quillController = useRef(
      QuillController(
        document: textDocument.content,
        selection: const TextSelection.collapsed(offset: 0),
      ),
    ).value;
    final selectedDocumentId = ref.read(selectedDocumentIdProvider);

    useEffect(
      () {
        // Save document to storage on value changes
        quillController.addListener(() {
          focusNode.requestFocus();
          final latestDocument = quillController.document;
          log(latestDocument.toPlainText());
          ref.read(documentsProvider.notifier).update((state) {
            final oldDocument = {...state};
            oldDocument.update(
              selectedDocumentId!,
              (value) => TextDocument(
                id: value.id,
                title: value.title,
                content: Document.fromDelta(latestDocument.toDelta()),
                createAt: value.createAt,
                updatedAt: DateTime.now(),
              ),
            );
            return oldDocument;
          });
        });
        return quillController.dispose;
      },
      [key],
    );

    return ColoredBox(
      color: isDesktop ? Colors.transparent : Colors.grey[180],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalDirection:
            isDesktop ? VerticalDirection.down : VerticalDirection.up,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: QuillSimpleToolbar(
              controller: quillController,
              config: QuillSimpleToolbarConfig(
                toolbarIconAlignment: WrapAlignment.start,
                showFontFamily: false,
                showFontSize: false,
                showUndo: false,
                showRedo: false,
                showBackgroundColorButton: false,
                showAlignmentButtons: false,
                showColorButton: false,
                showDividers: false,
                showSearchButton: false,
                showCodeBlock: false,
                showQuote: false,
                showLink: false,
                iconTheme: QuillIconTheme(
                  iconButtonUnselectedData: const IconButtonData(
                    color: Colors.transparent,
                  ),
                  iconButtonSelectedData: IconButtonData(
                    color: Colors.blue,
                  ),
                ),
                buttonOptions: QuillSimpleToolbarButtonOptions(
                  base: QuillToolbarBaseButtonOptions(
                    afterButtonPressed: focusNode.requestFocus,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: MouseRegion(
              cursor: SystemMouseCursors.text,
              child: QuillEditor.basic(
                controller: quillController,
                focusNode: focusNode,
                config: const QuillEditorConfig(
                  autoFocus: false,
                  expands: false,
                  padding: EdgeInsets.all(20),
                  placeholder: 'Write here...',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TextEditor extends StatefulWidget {
  const TextEditor({
    super.key,
    required this.textDocument,
  });

  final TextDocument textDocument;

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  final FocusNode _focusNode = FocusNode();
  late final QuillController _quillController;

  @override
  void initState() {
    super.initState();

    _quillController = QuillController(
      document: widget.textDocument.content,
      selection: const TextSelection.collapsed(offset: 0),
    );

    // Save document to storage on value changes
    _quillController.addListener(() {
      log('${widget.key} Saving doc...');
    });
  }

  @override
  void dispose() {
    log('${widget.key} Dispose');
    _focusNode.dispose();
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: isDesktop ? Colors.transparent : Colors.grey[180],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalDirection:
            isDesktop ? VerticalDirection.down : VerticalDirection.up,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: QuillSimpleToolbar(
              controller: _quillController,
              config: QuillSimpleToolbarConfig(
                toolbarIconAlignment: WrapAlignment.start,
                showFontFamily: false,
                showFontSize: false,
                showUndo: false,
                showRedo: false,
                showBackgroundColorButton: false,
                showAlignmentButtons: false,
                showColorButton: false,
                showDividers: false,
                showSearchButton: false,
                showCodeBlock: false,
                showQuote: false,
                showLink: false,
                iconTheme: QuillIconTheme(
                  iconButtonUnselectedData: const IconButtonData(
                    color: Colors.transparent,
                  ),
                  iconButtonSelectedData: IconButtonData(
                    color: Colors.blue,
                  ),
                ),
                buttonOptions: QuillSimpleToolbarButtonOptions(
                  base: QuillToolbarBaseButtonOptions(
                    afterButtonPressed: _focusNode.requestFocus,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: MouseRegion(
              cursor: SystemMouseCursors.text,
              child: QuillEditor.basic(
                controller: _quillController,
                focusNode: _focusNode,
                config: const QuillEditorConfig(
                  autoFocus: false,
                  expands: false,
                  padding: EdgeInsets.all(20),
                  placeholder: 'Write here...',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
