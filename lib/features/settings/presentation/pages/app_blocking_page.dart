import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/settings_provider.dart';
import '../../../core/services/app_blocking_service.dart';

class AppBlockingPage extends ConsumerStatefulWidget {
  const AppBlockingPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AppBlockingPage> createState() => _AppBlockingPageState();
}

class _AppBlockingPageState extends ConsumerState<AppBlockingPage> {
  bool hasPermission = false;
  List<AppInfo> installed = [];
  List<String> selected = [];

  @override
  void initState() {
    super.initState();
    _checkPermission();
    _loadApps();
  }

  Future<void> _checkPermission() async {
    final granted = await ref.read(appBlockingServiceProvider).requestUsageStatsPermission();
    setState(() => hasPermission = granted);
  }

  Future<void> _loadApps() async {
    final apps = await ref.read(appBlockingServiceProvider).getInstalledApps();
    setState(() => installed = apps);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bloqueio de apps')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: hasPermission ? Column(children: [
          const Text('Intensidade do bloqueio'),
          RadioListTile(value: BlockIntensity.soft, groupValue: null, title: const Text('Suave — apenas lembrete'), onChanged: (_) {}),
          RadioListTile(value: BlockIntensity.medium, groupValue: null, title: const Text('Médio — redireciona ao Honey'), onChanged: (_) {}),
          RadioListTile(value: BlockIntensity.intense, groupValue: null, title: const Text('Intenso — retorno imediato'), onChanged: (_) {}),
          const SizedBox(height: 12),
          Expanded(
            child: installed.isEmpty ? const Center(child: CircularProgressIndicator()) : ListView.builder(itemCount: installed.length, itemBuilder: (context, index) {
              final app = installed[index];
              final isChecked = selected.contains(app.packageName);
              return CheckboxListTile(title: Text(app.appName), subtitle: Text(app.packageName), value: isChecked, onChanged: (v) { setState(() { if (v == true) selected.add(app.packageName); else selected.remove(app.packageName); }); });
            }),
          ),
          ElevatedButton(onPressed: () async { await ref.read(settingsProvider.notifier).updateBlockedApps(selected); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Salvo'))); }, child: const Text('Salvar'))
        ]) : Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.shield_outlined), const SizedBox(height: 8), const Text('Permissão necessária'), const SizedBox(height: 8), const Text('Para monitorar apps, o Honey precisa de acesso às estatísticas de uso.'), const SizedBox(height: 8), ElevatedButton(onPressed: _checkPermission, child: const Text('Conceder permissão'))]))),
    );
  }
}
