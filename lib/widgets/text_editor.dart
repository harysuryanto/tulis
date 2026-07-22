import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tulis/helper.dart';
import 'package:tulis/models/text_document.dart';
import 'package:tulis/providers/documents_provider.dart';

class TextEditor extends HookConsumerWidget {
  const TextEditor({super.key, required this.textDocument});

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

    useEffect(() {
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
    }, [key]);

    final colorScheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: isDesktop
          ? Colors.transparent
          : colorScheme.surfaceContainerLowest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalDirection: isDesktop
            ? VerticalDirection.down
            : VerticalDirection.up,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Material(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              elevation: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: QuillSimpleToolbar(
                  controller: quillController,
                  config: QuillSimpleToolbarConfig(
                    multiRowsDisplay: false,
                    toolbarIconAlignment: WrapAlignment.start,
                    showFontFamily: false,
                    showFontSize: false,
                    showUndo: true,
                    showRedo: true,
                    showBoldButton: true,
                    showItalicButton: true,
                    showUnderLineButton: true,
                    showStrikeThrough: true,
                    showInlineCode: true,
                    showColorButton: false,
                    showBackgroundColorButton: false,
                    showClearFormat: true,
                    showAlignmentButtons: true,
                    showHeaderStyle: true,
                    showListNumbers: true,
                    showListBullets: true,
                    showListCheck: true,
                    showCodeBlock: true,
                    showQuote: true,
                    showIndent: false,
                    showLink: false,
                    showDividers: true,
                    showSearchButton: false,
                    iconTheme: QuillIconTheme(
                      iconButtonUnselectedData: IconButtonData(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      iconButtonSelectedData: IconButtonData(
                        color: colorScheme.primary,
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text(
              textDocument.title,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
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
