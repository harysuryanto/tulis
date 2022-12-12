import 'dart:convert';
import 'dart:developer';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
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
    final focusNode = FocusNode();
    final quillController = QuillController(
      document: textDocument.content,
      selection: const TextSelection.collapsed(offset: 0),
    );
    final selectedDocumentId = ref.read(selectedDocumentIdProvider);

    void saveDocument() {
      log('Saving document...');
      final String json =
          jsonEncode(quillController.document.toDelta().toJson());
      // box.put(HiveBoxKeys.document, json);

      // TODO: Simpan setiap perubahan ke [documentsProvider]
    }

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

        return () {
          // focusNode.dispose();
        };
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
            child: QuillToolbar.basic(
              controller: quillController,
              afterButtonPressed: focusNode.requestFocus,
              toolbarIconAlignment: WrapAlignment.start,
              dialogTheme: QuillDialogTheme(
                dialogBackgroundColor: Colors.transparent,
              ),
              iconTheme: QuillIconTheme(
                iconUnselectedFillColor: Colors.transparent,
                iconSelectedFillColor: Colors.blue,
              ),
              showFontFamily: false,
              showFontSize: false,
              showUndo: false,
              showRedo: false,
              showBackgroundColorButton: false,
              showCenterAlignment: false,
              showClearFormat: false,
              showColorButton: false,
              showJustifyAlignment: false,
              showDividers: false,
              showSearchButton: false,
              showCodeBlock: false,
              showLeftAlignment: false,
              showRightAlignment: false,
              showQuote: false,
              showLink: false,
            ),
          ),
          Expanded(
            child: MouseRegion(
              cursor: SystemMouseCursors.text,
              child: QuillEditor(
                controller: quillController,
                scrollController: ScrollController(),
                focusNode: focusNode,
                autoFocus: false,
                readOnly: false,
                scrollable: true,
                expands: false,
                padding: const EdgeInsets.all(20),
                placeholder: 'Write here...',
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

    // // Load document from storage
    // final Box box = Hive.box(HiveBoxes.myBox);
    // final documentFromStorage = box.get(HiveBoxKeys.document) as String?;
    // if (documentFromStorage != null) {
    //   _quillController = QuillController(
    //     document: Document.fromJson(jsonDecode(documentFromStorage) as List),
    //     selection: const TextSelection.collapsed(offset: 0),
    //   );
    // } else {
    //   _quillController = QuillController.basic();
    // }

    // Save document to storage on value changes
    _quillController.addListener(() {
      // final String json =
      //     jsonEncode(_quillController.document.toDelta().toJson());
      // box.put(HiveBoxKeys.document, json);
      log('${widget.key} Saving doc...');
    });
  }

  @override
  void dispose() {
    log('${widget.key} Dispose');
    _focusNode.dispose();
    // _quillController.dispose();
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
            child: QuillToolbar.basic(
              controller: _quillController,
              afterButtonPressed: _focusNode.requestFocus,
              toolbarIconAlignment: WrapAlignment.start,
              dialogTheme: QuillDialogTheme(
                dialogBackgroundColor: Colors.transparent,
              ),
              iconTheme: QuillIconTheme(
                iconUnselectedFillColor: Colors.transparent,
                iconSelectedFillColor: Colors.blue,
              ),
              showFontFamily: false,
              showFontSize: false,
              showUndo: false,
              showRedo: false,
              showBackgroundColorButton: false,
              showCenterAlignment: false,
              showClearFormat: false,
              showColorButton: false,
              showJustifyAlignment: false,
              showDividers: false,
              showSearchButton: false,
              showCodeBlock: false,
              showLeftAlignment: false,
              showRightAlignment: false,
              showQuote: false,
              showLink: false,
            ),
          ),
          Expanded(
            child: MouseRegion(
              cursor: SystemMouseCursors.text,
              child: QuillEditor(
                controller: _quillController,
                scrollController: ScrollController(),
                focusNode: _focusNode,
                autoFocus: false,
                readOnly: false,
                scrollable: true,
                expands: false,
                padding: const EdgeInsets.all(20),
                placeholder: 'Write here...',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
