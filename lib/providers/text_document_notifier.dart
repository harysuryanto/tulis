import 'dart:math';

import 'package:flutter_quill/flutter_quill.dart' show Document;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tulis/models/text_document.dart';

class TextDocumentsNotifier extends StateNotifier<Map<int, TextDocument>> {
  TextDocumentsNotifier()
      : super(
          {
            0: TextDocument(
              id: 0,
              title: '',
              content: Document(),
              createAt: DateTime.now(),
            ),
          },
        );

  void add({required String title, required Document document}) {
    final id = Random().nextInt(1000);
    state.addAll({
      id: TextDocument(
        id: id,
        title: title,
        content: document,
        createAt: DateTime.now(),
      ),
    });
  }

  void update({
    required int id,
    required String title,
    required Document document,
  }) {
    state.update(
      id,
      (value) => value.copyWith(
        title: title,
        content: document,
      ),
    );
  }

  void delete({required int id}) {
    state.remove(id);
  }
}
