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
    bool clearUpdatedAt = false,
  }) {
    return TextDocument(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createAt: createAt ?? this.createAt,
      updatedAt: clearUpdatedAt ? null : (updatedAt ?? this.updatedAt),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content.toDelta().toJson(),
      'createAt': createAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory TextDocument.fromJson(Map<dynamic, dynamic> json) {
    List<dynamic> contentDelta = [];
    if (json['content'] is List) {
      contentDelta = json['content'] as List<dynamic>;
    }

    return TextDocument(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Untitled',
      content: contentDelta.isNotEmpty
          ? Document.fromJson(contentDelta)
          : Document(),
      createAt: json['createAt'] != null
          ? DateTime.parse(json['createAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  @override
  String toString() {
    return 'TextDocument(id: $id, title: $title, content: $content, createAt: $createAt, updatedAt: $updatedAt)';
  }
}
