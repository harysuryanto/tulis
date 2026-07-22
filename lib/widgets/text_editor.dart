import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tulis/constants/notion_theme.dart';
import 'package:tulis/helper.dart';
import 'package:tulis/models/text_document.dart';
import 'package:tulis/providers/documents_provider.dart';
import 'package:tulis/widgets/notion_page_title.dart';

class TextEditor extends HookConsumerWidget {
  const TextEditor({super.key, required this.textDocument});

  final TextDocument textDocument;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode();
    useListenable(focusNode);
    final isFocused = focusNode.hasFocus;

    final quillController = useRef(
      QuillController(
        document: textDocument.content,
        selection: const TextSelection.collapsed(offset: 0),
      ),
    ).value;

    final docId = textDocument.id;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    useEffect(() {
      final initialDeltaJson = jsonEncode(
        textDocument.content.toDelta().toJson(),
      );
      final initialUpdatedAt = textDocument.updatedAt;

      void listener() {
        final latestDocument = quillController.document;
        final currentDeltaJson = jsonEncode(latestDocument.toDelta().toJson());
        final isContentChanged = currentDeltaJson != initialDeltaJson;

        ref.read(documentsProvider.notifier).update((state) {
          if (!state.containsKey(docId)) return state;
          final value = state[docId]!;

          final updated = isContentChanged
              ? value.copyWith(
                  content: Document.fromDelta(latestDocument.toDelta()),
                  updatedAt: DateTime.now(),
                )
              : value.copyWith(
                  content: Document.fromDelta(latestDocument.toDelta()),
                  updatedAt: initialUpdatedAt,
                  clearUpdatedAt: initialUpdatedAt == null,
                );

          final newState = {...state, docId: updated};
          saveDocumentsToHive(newState);
          return newState;
        });
      }

      quillController.addListener(listener);
      return () => quillController.removeListener(listener);
    }, [docId]);

    final borderBg = isDark
        ? NotionColors.darkBorder
        : NotionColors.lightBorder;
    final toolbarBg = isDark
        ? NotionColors.darkSidebar
        : NotionColors.lightSidebar;
    final textPrimary = isDark
        ? NotionColors.darkTextPrimary
        : NotionColors.lightTextPrimary;
    final textMuted = isDark
        ? NotionColors.darkTextMuted
        : NotionColors.lightTextMuted;

    Widget buildToolbar() {
      return Container(
        decoration: BoxDecoration(
          color: toolbarBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderBg),
          boxShadow: isDesktop
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: QuillSimpleToolbar(
          controller: quillController,
          config: QuillSimpleToolbarConfig(
            multiRowsDisplay: false,
            headerStyleType: HeaderStyleType.original,
            toolbarSectionSpacing: 1.0,
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
            showAlignmentButtons: false,
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
                color: textMuted,
                padding: const EdgeInsets.all(1),
                visualDensity: VisualDensity.compact,
              ),
              iconButtonSelectedData: IconButtonData(
                color: textPrimary,
                padding: const EdgeInsets.all(1),
                visualDensity: VisualDensity.compact,
              ),
            ),
            buttonOptions: QuillSimpleToolbarButtonOptions(
              base: QuillToolbarBaseButtonOptions(
                iconSize: 18.0,
                iconButtonFactor: 0.75,
                afterButtonPressed: focusNode.requestFocus,
              ),
              selectHeaderStyleDropdownButton:
                  QuillToolbarSelectHeaderStyleDropdownButtonOptions(
                    textStyle: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: textPrimary,
                    ),
                    iconSize: 14.0,
                    iconButtonFactor: 0.8,
                  ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        // Desktop Static Toolbar Header (Shown ONLY on desktop)
        if (isDesktop)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: buildToolbar(),
              ),
            ),
          ),

        // Main Document Canvas (Top-aligned, Max Width 800, Fills vertical space)
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 24,
                  right: 24,
                  bottom: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Inline Title Header
                    NotionPageTitle(textDocument: textDocument),

                    // Text Editor Canvas (Expands to fill remaining height)
                    Expanded(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.text,
                        child: QuillEditor.basic(
                          controller: quillController,
                          focusNode: focusNode,
                          config: QuillEditorConfig(
                            autoFocus: false,
                            expands: true,
                            padding: EdgeInsets.zero,
                            placeholder: "Write something...",
                            customStyles: DefaultStyles(
                              h1: DefaultTextBlockStyle(
                                TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: textPrimary,
                                  height: 1.25,
                                ),
                                const HorizontalSpacing(0, 0),
                                const VerticalSpacing(14, 4),
                                const VerticalSpacing(0, 0),
                                null,
                              ),
                              h2: DefaultTextBlockStyle(
                                TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimary,
                                  height: 1.3,
                                ),
                                const HorizontalSpacing(0, 0),
                                const VerticalSpacing(12, 4),
                                const VerticalSpacing(0, 0),
                                null,
                              ),
                              h3: DefaultTextBlockStyle(
                                TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimary,
                                  height: 1.35,
                                ),
                                const HorizontalSpacing(0, 0),
                                const VerticalSpacing(10, 4),
                                const VerticalSpacing(0, 0),
                                null,
                              ),
                              paragraph: DefaultTextBlockStyle(
                                TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: textPrimary,
                                ),
                                const HorizontalSpacing(0, 0),
                                const VerticalSpacing(2, 2),
                                const VerticalSpacing(0, 0),
                                null,
                              ),
                              lists: DefaultListBlockStyle(
                                TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: textPrimary,
                                ),
                                const HorizontalSpacing(0, 0),
                                const VerticalSpacing(2, 2),
                                const VerticalSpacing(0, 0),
                                null,
                                null,
                              ),
                              placeHolder: DefaultTextBlockStyle(
                                TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: textMuted.withValues(alpha: 0.5),
                                ),
                                const HorizontalSpacing(0, 0),
                                const VerticalSpacing(0, 0),
                                const VerticalSpacing(0, 0),
                                null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Mobile Floating Keyboard Toolbar (Shows ONLY on mobile when editor is focused)
        if (!isDesktop && isFocused)
          Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 4,
              bottom: 8 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: buildToolbar(),
              ),
            ),
          ),
      ],
    );
  }
}
