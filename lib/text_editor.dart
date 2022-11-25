import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

import 'helper.dart';

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
  void initState() {
    super.initState();

    /// Load last document from storage
    // _controller.document.insert(0, data);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: isDesktop ? null : Colors.grey[180],
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
            iconTheme: QuillIconTheme(
              iconUnselectedFillColor: Colors.transparent,
              iconSelectedFillColor: Colors.blue,
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
              onTapDown: (details, p1) {
                // Save document to storage
                return false;
              },
              controller: _controller,
              scrollController: ScrollController(),
              scrollable: true,
              focusNode: _focusNode,
              autoFocus: true,
              readOnly: _readOnly,
              expands: false,
              padding: const EdgeInsets.symmetric(vertical: 20),
              placeholder: 'Write here...',
            ),
          ),
        ],
      ),
    );
  }
}
