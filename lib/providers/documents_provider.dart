import 'dart:math';

import 'package:flutter_quill/flutter_quill.dart' show Document;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tulis/models/text_document.dart';

final documentsProvider = Provider((ref) => _documents);
final selectedDocumentIdProvider = StateProvider<int?>((ref) {
  return _documents.isNotEmpty ? _documents[0].id : null;
});

final _docExample = [
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

final _documents = <TextDocument>[
  TextDocument(
    id: Random().nextInt(1000),
    title: _formatDate(DateTime(2022, 11, 29, 02, 11)),
    content: Document.fromJson(_docExample),
    createAt: DateTime(2022, 11, 29, 02, 11),
    updatedAt: DateTime(2022, 11, 29, 03, 12),
  ),
  TextDocument(
    id: Random().nextInt(1000),
    title: _formatDate(DateTime(2021)),
    content: Document(),
    createAt: DateTime(2021),
  ),
];

String _formatDate(DateTime date) {
  return DateFormat('MMM d, yyyy').format(date);
}
