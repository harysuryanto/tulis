import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill hide Text;
import 'package:tulis/models/document.dart';

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
    title: 'Today',
    content: quill.Document.fromJson(_docExample),
    createAt: DateTime(2022, 11, 29, 02, 11),
    updatedAt: DateTime(2022, 11, 29, 03, 12),
  ),
  Document(
    title: 'Yesterday',
    content: quill.Document(),
    createAt: DateTime(2021),
  ),
];

class DocumentList extends StatelessWidget {
  const DocumentList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final data = _documents[index];
        return _MyListTile(data: data);
      },
      itemCount: _documents.length,
    );
  }
}

class _MyListTile extends HookWidget {
  const _MyListTile({
    required this.data,
  });

  final Document data;

  @override
  Widget build(BuildContext context) {
    final isHovered = useState(false);

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(isHovered.value ? .1 : 0),
          border: Border.all(
            color: Colors.white.withOpacity(isHovered.value ? .2 : 0),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(data.title),
      ),
    );
  }
}
