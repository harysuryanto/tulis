import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tulis/providers/text_document_notifier.dart';

final textDocuments =
    StateProvider<TextDocumentsNotifier>((ref) => TextDocumentsNotifier());
