import 'package:flutter/material.dart';
import 'package:tulis/widgets/document_list.dart';

class Pane extends StatelessWidget {
  const Pane({super.key, required this.isExpanded});

  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isExpanded ? 1 : 0,
      duration: const Duration(milliseconds: 200),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).viewPadding.top),
            const Text(
              'Documents',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Expanded(child: DocumentList()),
          ],
        ),
      ),
    );
  }
}
