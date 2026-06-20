import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/settings_entity.dart';
import '../../presentation/providers/settings_provider.dart';
import '../../../../core/services/app_blocking_service.dart';
import '../../../../core/services/providers/service_providers.dart';

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
    selected = ref.read(settingsProvider).value?.blockedAppPackages ?? [];
    _checkPermission();
    _loadApps();
  }

  Future<void> _checkPermission() async {
    final granted =
        await ref.read(appBlockingServiceProvider).requestUsageStatsPermission();
    setState(() => hasPermission = granted);
  }

  Future<void> _loadApps() async {
    final apps = await ref.read(appBlockingServiceProvider).getInstalledApps();
    setState(() => installed = apps);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider).value;
    final notifier = ref.read(settingsProvider.notifier);
    final intensity = settings?.blockIntensity ?? BlockIntensity.intense;

    return Scaffold(
      appBar: AppBar(title: const Text('Bloqueio de apps')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: hasPermission
            ? Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Intensidade do bloqueio'),
                  ),
                  RadioListTile<BlockIntensity>(
                    value: BlockIntensity.soft,
                    groupValue: intensity,
                    title: const Text('Suave — apenas lembrete'),
                    onChanged: (v) {
                      HapticFeedback.lightImpact();
                      notifier.updateBlockIntensity(v!);
                    },
                  ),
                  RadioListTile<BlockIntensity>(
                    value: BlockIntensity.medium,
                    groupValue: intensity,
                    title: const Text('Médio — redireciona ao Honey'),
                    onChanged: (v) {
                      HapticFeedback.lightImpact();
                      notifier.updateBlockIntensity(v!);
                    },
                  ),
                  RadioListTile<BlockIntensity>(
                    value: BlockIntensity.intense,
                    groupValue: intensity,
                    title: const Text('Intenso — retorno imediato'),
                    onChanged: (v) {
                      HapticFeedback.lightImpact();
                      notifier.updateBlockIntensity(v!);
                    },
                  ),
                  const SizedBox(height: 12),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Apps a bloquear'),
                  ),
                  Expanded(
                    child: installed.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: installed.length,
                            itemBuilder: (context, index) {
                              final app = installed[index];
                              final isChecked =
                                  selected.contains(app.packageName);
                              return CheckboxListTile(
                                title: Text(app.appName),
                                subtitle: Text(app.packageName),
                                value: isChecked,
                                onChanged: (v) {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    if (v == true) {
                                      selected.add(app.packageName);
                                    } else {
                                      selected.remove(app.packageName);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await notifier.updateBlockedApps(selected);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Salvo (${selected.length} apps selecionados)')),
                      );
                    },
                    child: Text('Salvar (${selected.length} apps selecionados)'),
                  ),
                ],
              )
            : Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.shield_outlined),
                      const SizedBox(height: 8),
                      const Text('Permissão necessária'),
                      const SizedBox(height: 8),
                      const Text(
                          'Para monitorar apps, o Honey precisa de acesso às estatísticas de uso.'),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _checkPermission,
                        child: const Text('Conceder permissão'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
