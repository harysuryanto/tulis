import 'package:fluent_ui/fluent_ui.dart';
import 'package:tulis/widgets/screen_wrapper.dart';
import 'package:tulis/widgets/text_editor.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
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
