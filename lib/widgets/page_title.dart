import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tulis/constants/notion_theme.dart';
import 'package:tulis/helper.dart';
import 'package:tulis/models/text_document.dart';
import 'package:tulis/providers/documents_provider.dart';

class PageTitle extends HookConsumerWidget {
  const PageTitle({super.key, required this.textDocument});

  final TextDocument textDocument;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: textDocument.title);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    useEffect(() {
      if (controller.text != textDocument.title) {
        controller.text = textDocument.title;
      }
      return null;
    }, [textDocument.id, textDocument.title]);

    final textPrimary = isDark
        ? NotionColors.darkTextPrimary
        : NotionColors.lightTextPrimary;
    final textMuted = isDark
        ? NotionColors.darkTextMuted
        : NotionColors.lightTextMuted;

    final updatedDateText = textDocument.updatedAt != null
        ? 'Updated ${formatDate(textDocument.updatedAt!)}'
        : 'Created ${formatDate(textDocument.createAt)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Input Field
        TextField(
          controller: controller,
          onChanged: (val) {
            updateDocumentTitle(ref, textDocument.id, val);
          },
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: -0.4,
            height: 1.25,
          ),
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: 'Untitled',
            hintStyle: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: textMuted.withValues(alpha: 0.4),
              letterSpacing: -0.4,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
        ),
        const SizedBox(height: 8),

        // Metadata Subtitle
        Text(
          updatedDateText,
          style: TextStyle(
            fontSize: 12,
            color: textMuted.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
