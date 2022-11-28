import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tulis/constants/hive_box_keys.dart';
import 'package:tulis/constants/hive_boxes.dart';
import 'package:tulis/helper.dart';

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
    final Box box = Hive.box(HiveBoxes.myBox);
    final documentFromStorage = box.get(HiveBoxKeys.document) as String?;
    if (documentFromStorage != null) {
      _quillController = QuillController(
        document: Document.fromJson(jsonDecode(documentFromStorage) as List),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      _quillController = QuillController.basic();
    }

    // Save document to storage on value change
    _quillController.addListener(() {
      final String json =
          jsonEncode(_quillController.document.toDelta().toJson());
      box.put(HiveBoxKeys.document, json);
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
