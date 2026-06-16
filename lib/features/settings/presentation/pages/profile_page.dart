import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';

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
              _statCard('Nível', '1'),
              _statCard('Moedas', '0'),
              _statCard('Dias', '0'),
            ]),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _save, child: const Text('Salvar'))
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value) {
    return Column(children: [Text(value, style: Theme.of(context).textTheme.titleLarge), Text(label)]);
  }

  void _save() async {
    await ref.read(settingsProvider.notifier).updateUserName(_controller.text.trim());
    // TODO: update userProvider
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perfil atualizado! ✨')));
      Navigator.pop(context);
    }
  }
}
