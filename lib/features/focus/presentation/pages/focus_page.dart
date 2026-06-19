import 'package:flutter/material.dart';
import '../../../../shared/widgets/honey_scaffold.dart';

/// Placeholder Focus/Timer page
class FocusPage extends StatelessWidget {
  const FocusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HoneyScaffold(
      title: 'Foco',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timer, size: 64),
            const SizedBox(height: 16),
            const Text('Focus Page Placeholder'),
            const SizedBox(height: 8),
            Text(
              'Pomodoro timer will be implemented here',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
