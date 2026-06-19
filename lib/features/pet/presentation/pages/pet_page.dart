import 'package:flutter/material.dart';
import '../../../../shared/widgets/honey_scaffold.dart';

/// Placeholder Pet page
class PetPage extends StatelessWidget {
  const PetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HoneyScaffold(
      title: 'Pet',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pets, size: 64),
            const SizedBox(height: 16),
            const Text('Pet Page Placeholder'),
            const SizedBox(height: 8),
            Text(
              'Virtual pet will be implemented here',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
