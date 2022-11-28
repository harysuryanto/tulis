import 'package:fluent_ui/fluent_ui.dart';
import 'package:tulis/widgets/page_wrapper.dart';
import 'package:tulis/widgets/text_editor.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: Column(
        children: [
          const Expanded(child: TextEditor()),
          // Prevent content blocked by virtual keyboard
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
