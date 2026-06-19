import 'package:flutter/material.dart';
import '../../../../shared/widgets/honey_scaffold.dart';

/// Placeholder Statistics/History page
class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HoneyScaffold(
      title: 'Histórico',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bar_chart, size: 64),
            const SizedBox(height: 16),
            const Text('Statistics Page Placeholder'),
            const SizedBox(height: 8),
            Text(
              'Analytics and history will be implemented here',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
