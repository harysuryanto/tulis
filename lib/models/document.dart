import 'package:flutter_quill/flutter_quill.dart' as quill show Document;

class Document {
  final int id;
  final String title;
  final quill.Document content;
  final DateTime createAt;
  final DateTime? updatedAt;

  const Document({
    required this.id,
    required this.title,
    required this.content,
    required this.createAt,
    this.updatedAt,
  });
}
