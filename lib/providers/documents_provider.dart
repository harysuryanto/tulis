import 'dart:math';

import 'package:flutter_quill/flutter_quill.dart' as quill show Document;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tulis/models/document.dart';

final documentsProvider = Provider((ref) => _documents);
final selectedDocumentIdProvider = StateProvider<int?>((ref) => null);

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

final _documents = <Document>[
  Document(
    id: Random().nextInt(1000),
    title: 'Today',
    content: quill.Document.fromJson(_docExample),
    createAt: DateTime(2022, 11, 29, 02, 11),
    updatedAt: DateTime(2022, 11, 29, 03, 12),
  ),
  Document(
    id: Random().nextInt(1000),
    title: 'Yesterday',
    content: quill.Document(),
    createAt: DateTime(2021),
  ),
];
