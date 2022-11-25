import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:hive_flutter/hive_flutter.dart';

import 'helper.dart';

class TextEditor extends StatefulWidget {
  const TextEditor({super.key});

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  late final QuillController _quillController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Load document from storage
    Box box = Hive.box('myBox');
    if (box.get('document') != null) {
      var json = jsonDecode(box.get('document')!);
      _quillController = QuillController(
        document: Document.fromJson(json),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      _quillController = QuillController.basic();
    }

    // Save document to storage on value change
    _quillController.addListener(() {
      String json = jsonEncode(_quillController.document.toDelta().toJson());
      box.put('document', json);
    });
  }

  @override
  void dispose() {
    _quillController.dispose();
    _focusNode.dispose();
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
              controller: _quillController,
              scrollController: ScrollController(),
              scrollable: true,
              focusNode: _focusNode,
              autoFocus: false,
              readOnly: false,
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
