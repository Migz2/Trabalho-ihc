import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../../../focus/presentation/providers/user_provider.dart';
import '../../../pet/presentation/providers/pet_provider.dart';
import '../../../statistics/presentation/providers/statistics_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final name = ref.read(settingsProvider).value?.userName ?? '';
    _controller = TextEditingController(text: name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final petLevel = ref.watch(petProvider.select((p) => p.value?.level ?? 1));
    final coins = ref.watch(userProvider.select((u) => u.value?.coins ?? 0));
    final streak = ref.watch(statisticsProvider.select((s) => s.value?.currentStreak ?? 0));

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil'), actions: [IconButton(onPressed: _save, icon: const Icon(Icons.save))]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.15), shape: BoxShape.circle),
              child: Center(child: Text(_controller.text.isNotEmpty ? _controller.text.substring(0,1).toUpperCase() : '', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Theme.of(context).colorScheme.primary))),
            ),
            const SizedBox(height: 12),
            TextField(controller: _controller, decoration: const InputDecoration(border: UnderlineInputBorder(), hintText: 'Nome'), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _statCard('Nível', '$petLevel'),
              _statCard('Moedas', '$coins'),
              _statCard('Sequência', '$streak'),
            ]),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _save, child: const Text('Salvar'))
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value) {
    return Column(
      children: [
        Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleLarge),
        Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  void _save() async {
    final newName = _controller.text.trim();
    await ref.read(settingsProvider.notifier).updateUserName(newName);
    await ref.read(userProvider.notifier).updateName(newName);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perfil atualizado! ✨')));
      Navigator.pop(context);
    }
  }
}
