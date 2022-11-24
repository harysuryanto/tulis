import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:tulis/helper.dart';

class TextEditor extends StatefulWidget {
  const TextEditor({super.key});

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  final _focusNode = FocusNode();
  final _controller = QuillController.basic();
  final _readOnly = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primarySwatch: Colors.blueGrey,
        textTheme: const TextTheme(),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        color: isDesktop ? null : Colors.white54,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          verticalDirection:
              isDesktop ? VerticalDirection.down : VerticalDirection.up,
          children: [
            QuillToolbar.basic(
              controller: _controller,
              toolbarIconAlignment: WrapAlignment.start,
              dialogTheme: QuillDialogTheme(
                dialogBackgroundColor: Colors.transparent,
              ),
              iconTheme: const QuillIconTheme(
                iconUnselectedFillColor: Colors.transparent,
              ),
              showFontFamily: false,
              showFontSize: false,
              showUndo: false,
              showRedo: false,
              showAlignmentButtons: false,
              showBackgroundColorButton: false,
              showCenterAlignment: false,
              showClearFormat: false,
              showColorButton: false,
              showDirection: false,
              showJustifyAlignment: false,
              showDividers: false,
              showSearchButton: false,
              showCodeBlock: false,
              showLeftAlignment: false,
              showRightAlignment: false,
              showQuote: false,
              showLink: false,
            ),
            Expanded(
              child: QuillEditor(
                controller: _controller,
                scrollController: ScrollController(),
                scrollable: true,
                focusNode: _focusNode,
                autoFocus: true,
                readOnly: _readOnly,
                expands: false,
                padding: const EdgeInsets.symmetric(vertical: 10),
                placeholder: 'Write here...',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
