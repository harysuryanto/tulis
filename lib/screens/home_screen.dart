import 'package:fluent_ui/fluent_ui.dart';

import '../widgets/screen_wrapper.dart';
import '../widgets/text_editor.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
