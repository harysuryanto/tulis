import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' show Document;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:tulis/constants/hive_boxes.dart';
import 'package:tulis/models/text_document.dart';

const String _kDocumentsHiveKey = 'documents_data';
const String _kThemeModeHiveKey = 'theme_mode_key';

// Helper to save documents to Hive storage
void saveDocumentsToHive(Map<int, TextDocument> docs) {
  try {
    final box = Hive.box(HiveBoxes.myBox);
    final jsonMap = docs.map(
      (key, doc) => MapEntry(key.toString(), doc.toJson()),
    );
    box.put(_kDocumentsHiveKey, jsonEncode(jsonMap));
  } catch (e, st) {
    log('Failed to save documents to Hive: $e', error: e, stackTrace: st);
  }
}

// Helper to load documents from Hive storage
Map<int, TextDocument> _loadDocumentsFromHive() {
  try {
    final box = Hive.box(HiveBoxes.myBox);
    final rawData = box.get(_kDocumentsHiveKey);

    if (rawData != null && rawData is String && rawData.isNotEmpty) {
      final decodedMap = jsonDecode(rawData) as Map<String, dynamic>;
      final result = <int, TextDocument>{};

      decodedMap.forEach((key, value) {
        if (value is Map) {
          final doc = TextDocument.fromJson(value);
          result[doc.id] = doc;
        }
      });

      if (result.isNotEmpty) {
        return result;
      }
    }
  } catch (e, st) {
    log(
      'Failed to load documents from Hive, seeding defaults: $e',
      error: e,
      stackTrace: st,
    );
  }

  // Seed default initial documents on first launch
  saveDocumentsToHive(_initialDefaultDocuments);
  return _initialDefaultDocuments;
}

// Theme mode provider with Hive persistence
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  try {
    final box = Hive.box(HiveBoxes.myBox);
    final savedMode = box.get(_kThemeModeHiveKey);
    if (savedMode == 'light') return ThemeMode.light;
    if (savedMode == 'dark') return ThemeMode.dark;
  } catch (_) {}
  return ThemeMode.dark;
});

void toggleThemeMode(WidgetRef ref) {
  final current = ref.read(themeModeProvider);
  final next = current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  ref.read(themeModeProvider.notifier).state = next;
  try {
    Hive.box(
      HiveBoxes.myBox,
    ).put(_kThemeModeHiveKey, next == ThemeMode.light ? 'light' : 'dark');
  } catch (_) {}
}

final documentsProvider = StateProvider<Map<int, TextDocument>>(
  (ref) => _loadDocumentsFromHive(),
);

final selectedDocumentIdProvider = StateProvider<int?>((ref) {
  final docs = _loadDocumentsFromHive();
  return docs.isNotEmpty ? docs.keys.first : null;
});

final searchQueryProvider = StateProvider<String>((ref) => '');

void createNewDocument(WidgetRef ref) {
  final docsNotifier = ref.read(documentsProvider.notifier);
  final newId = DateTime.now().millisecondsSinceEpoch;
  final newDoc = TextDocument(
    id: newId,
    title: 'Untitled',
    content: Document(),
    createAt: DateTime.now(),
  );

  docsNotifier.update((state) {
    final newState = {...state, newId: newDoc};
    saveDocumentsToHive(newState);
    return newState;
  });
  ref.read(selectedDocumentIdProvider.notifier).state = newId;
}

void deleteDocument(WidgetRef ref, int id) {
  final docsNotifier = ref.read(documentsProvider.notifier);
  docsNotifier.update((state) {
    final copy = Map<int, TextDocument>.from(state);
    copy.remove(id);
    saveDocumentsToHive(copy);
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
    final newState = {...state, id: updated};
    saveDocumentsToHive(newState);
    return newState;
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
    'attributes': {'list': 'checked'},
  },
  {'insert': 'Load documents from storage'},
  {
    'insert': '\n',
    'attributes': {'list': 'checked'},
  },
  {'insert': 'Add new document'},
  {
    'insert': '\n',
    'attributes': {'list': 'checked'},
  },
  {'insert': 'Reduce startup time'},
  {
    'insert': '\n',
    'attributes': {'list': 'checked'},
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

final _initialDefaultDocuments = <int, TextDocument>{
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
