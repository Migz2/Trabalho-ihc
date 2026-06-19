import 'package:flutter/material.dart';
import '../../../../shared/widgets/honey_scaffold.dart';

/// Placeholder Settings page
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HoneyScaffold(
      title: 'Ajustes',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.settings, size: 64),
            const SizedBox(height: 16),
            const Text('Settings Page Placeholder'),
            const SizedBox(height: 8),
            Text(
              'App settings will be implemented here',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
