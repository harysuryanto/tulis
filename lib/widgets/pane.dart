import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:tulis/helper.dart';
import 'package:tulis/widgets/document_list.dart';

class Pane extends StatelessWidget {
  const Pane({
    super.key,
    required this.isExpanded,
  });

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
            if (isDesktop)
              SizedBox(
                height: appWindow.titleBarButtonSize.height,
                child: MoveWindow(),
              ),
            const Text('Documents'),
            const Expanded(child: DocumentList()),
          ],
        ),
      ),
    );
  }
}
