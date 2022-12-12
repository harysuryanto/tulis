import 'package:flutter/foundation.dart';
import 'package:flutter_quill/flutter_quill.dart' show Document;

@immutable
class TextDocument {
  final int id;
  final String title;
  final Document content;
  final DateTime createAt;
  final DateTime? updatedAt;

  const TextDocument({
    required this.id,
    required this.title,
    required this.content,
    required this.createAt,
    this.updatedAt,
  });

  TextDocument copyWith({
    int? id,
    String? title,
    Document? content,
    DateTime? createAt,
    DateTime? updatedAt,
  }) {
    return TextDocument(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createAt: createAt ?? this.createAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'TextDocument(id: $id, title: $title, content: $content, createAt: $createAt, updatedAt: $updatedAt)';
  }
}
