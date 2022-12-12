import 'dart:developer';

import 'package:flutter_quill/flutter_quill.dart' show Document;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tulis/helper.dart';
import 'package:tulis/models/text_document.dart';

final documentsProvider = StateProvider((ref) => _documents);
final selectedDocumentIdProvider = StateProvider<int?>((ref) {
  final documents = ref.read(documentsProvider);
  final int? key = documents.isNotEmpty ? documents.keys.toList()[0] : null;

  log(documents.keys.toList()[0].toString());
  return key;
});

final _docExample = [
  {'insert': 'TODO'},
  {
    'insert': '\n',
    'attributes': {'header': 3}
  },
  {'insert': 'Rename screen to page'},
  {
    'insert': '\n',
    'attributes': {'list': 'checked'}
  },
  {'insert': 'Create models for'},
  {
    'insert': '\n',
    'attributes': {'list': 'checked'}
  },
  {'insert': 'Window size'},
  {
    'insert': '\n',
    'attributes': {'list': 'checked', 'indent': 1}
  },
  {'insert': 'Window position'},
  {
    'insert': '\n',
    'attributes': {'list': 'checked', 'indent': 1}
  },
  {'insert': 'Set title overflow to ellipsis'},
  {
    'insert': '\n',
    'attributes': {'list': 'checked'}
  },
  {'insert': 'Increase min window width by 50'},
  {
    'insert': '\n',
    'attributes': {'list': 'checked'}
  },
  {'insert': 'Decrease min window height by 300'},
  {
    'insert': '\n',
    'attributes': {'list': 'checked'}
  },
  {'insert': 'Save list of documents to storage'},
  {
    'insert': '\n',
    'attributes': {'list': 'unchecked'}
  },
  {'insert': 'Load documents from storage'},
  {
    'insert': '\n',
    'attributes': {'list': 'unchecked'}
  },
  {'insert': 'Add new document'},
  {
    'insert': '\n',
    'attributes': {'list': 'unchecked'}
  },
  {'insert': 'Reduce startup time'},
  {
    'insert': '\n',
    'attributes': {'list': 'unchecked'}
  }
];
final _docExample2 = [
  {'insert': 'TODO Tulis'},
  {
    'insert': '\n',
    'attributes': {'header': 3}
  },
  {'insert': 'Rename screen to page'},
  {
    'insert': '\n',
    'attributes': {'list': 'checked'}
  },
  {'insert': 'Create models for'},
  {
    'insert': '\n',
    'attributes': {'list': 'checked'}
  },
  {'insert': 'Window size'},
  {
    'insert': '\n',
    'attributes': {'list': 'checked', 'indent': 1}
  },
  {'insert': 'Window position'},
  {
    'insert': '\n',
    'attributes': {'list': 'checked', 'indent': 1}
  }
];

final _documents = <int, TextDocument>{
  1: TextDocument(
    id: 1,
    title: formatDate(DateTime(2022, 11, 25, 5, 24)),
    content: Document.fromJson(_docExample),
    createAt: DateTime(2022, 11, 25, 5, 24),
  ),
  2: TextDocument(
    id: 2,
    title: formatDate(DateTime(2022, 11, 29, 02, 11)),
    content: Document.fromJson(_docExample2),
    createAt: DateTime(2022, 11, 29, 02, 11),
  ),
  3: TextDocument(
    id: 3,
    title: formatDate(DateTime(2021)),
    content: Document(),
    createAt: DateTime(2021),
  ),
};
