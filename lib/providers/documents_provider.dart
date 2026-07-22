import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' show Document;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:tulis/models/text_document.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

final documentsProvider = StateProvider<Map<int, TextDocument>>(
  (ref) => _documents,
);
final selectedDocumentIdProvider = StateProvider<int?>((ref) {
  return _documents.isNotEmpty ? _documents.keys.first : null;
});

final searchQueryProvider = StateProvider<String>((ref) => '');

void createNewDocument(WidgetRef ref) {
  final docs = ref.read(documentsProvider.notifier);
  final newId = DateTime.now().millisecondsSinceEpoch;
  final newDoc = TextDocument(
    id: newId,
    title: 'Untitled',
    content: Document(),
    createAt: DateTime.now(),
  );

  docs.update((state) => {...state, newId: newDoc});
  ref.read(selectedDocumentIdProvider.notifier).state = newId;
}

void deleteDocument(WidgetRef ref, int id) {
  final docsNotifier = ref.read(documentsProvider.notifier);
  docsNotifier.update((state) {
    final copy = Map<int, TextDocument>.from(state);
    copy.remove(id);
    return copy;
  });

  final currentSelected = ref.read(selectedDocumentIdProvider);
  if (currentSelected == id) {
    final remaining = ref.read(documentsProvider);
    ref.read(selectedDocumentIdProvider.notifier).state = remaining.isNotEmpty
        ? remaining.keys.first
        : null;
  }
}

void updateDocumentTitle(WidgetRef ref, int id, String newTitle) {
  ref.read(documentsProvider.notifier).update((state) {
    if (!state.containsKey(id)) return state;
    final oldDoc = state[id]!;
    final updated = oldDoc.copyWith(title: newTitle, updatedAt: DateTime.now());
    return {...state, id: updated};
  });
}

final _docExample = [
  {'insert': 'TODO'},
  {
    'insert': '\n',
    'attributes': {'header': 3},
  },
  {'insert': 'Rename screen to page'},
  {
    'insert': '\n',
    'attributes': {'list': 'checked'},
  },
  {'insert': 'Create models for'},
  {
    'insert': '\n',
    'attributes': {'list': 'checked'},
  },
  {'insert': 'Window size'},
  {
    'insert': '\n',
    'attributes': {'list': 'checked', 'indent': 1},
  },
  {'insert': 'Window position'},
  {
    'insert': '\n',
    'attributes': {'list': 'checked', 'indent': 1},
  },
  {'insert': 'Set title overflow to ellipsis'},
  {
    'insert': '\n',
    'attributes': {'list': 'checked'},
  },
  {'insert': 'Increase min window width by 50'},
  {
    'insert': '\n',
    'attributes': {'list': 'checked'},
  },
  {'insert': 'Decrease min window height by 300'},
  {
    'insert': '\n',
    'attributes': {'list': 'checked'},
  },
  {'insert': 'Save list of documents to storage'},
  {
    'insert': '\n',
    'attributes': {'list': 'unchecked'},
  },
  {'insert': 'Load documents from storage'},
  {
    'insert': '\n',
    'attributes': {'list': 'unchecked'},
  },
  {'insert': 'Add new document'},
  {
    'insert': '\n',
    'attributes': {'list': 'unchecked'},
  },
  {'insert': 'Reduce startup time'},
  {
    'insert': '\n',
    'attributes': {'list': 'unchecked'},
  },
];
final _docExample2 = [
  {'insert': 'TODO Tulis'},
  {
    'insert': '\n',
    'attributes': {'header': 3},
  },
  {'insert': 'Rename screen to page'},
  {
    'insert': '\n',
    'attributes': {'list': 'checked'},
  },
  {'insert': 'Create models for'},
  {
    'insert': '\n',
    'attributes': {'list': 'checked'},
  },
  {'insert': 'Window size'},
  {
    'insert': '\n',
    'attributes': {'list': 'checked', 'indent': 1},
  },
  {'insert': 'Window position'},
  {
    'insert': '\n',
    'attributes': {'list': 'checked', 'indent': 1},
  },
];

final _documents = <int, TextDocument>{
  1: TextDocument(
    id: 1,
    title: 'Getting Started',
    content: Document.fromJson(_docExample),
    createAt: DateTime(2022, 11, 25, 5, 24),
  ),
  2: TextDocument(
    id: 2,
    title: 'Project Roadmap',
    content: Document.fromJson(_docExample2),
    createAt: DateTime(2022, 11, 29, 02, 11),
  ),
  3: TextDocument(
    id: 3,
    title: 'Quick Notes',
    content: Document(),
    createAt: DateTime(2021),
  ),
};
