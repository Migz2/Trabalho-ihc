import 'dart:async';

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

class _AppBlockingPageState extends ConsumerState<AppBlockingPage>
    with WidgetsBindingObserver {
  bool hasPermission = false;
  bool hasNotificationAccess = false;
  bool hasOverlayAccess = false;
  List<AppInfo> installed = [];
  List<String> selected = [];
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    selected = List.from(
        ref.read(settingsProvider).value?.blockedAppPackages ?? const []);
    _checkPermission();
    _loadApps();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Re-check after the user returns from the system settings screen,
    // since granting the permission there doesn't notify the app directly.
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    }
  }

  Future<void> _checkPermission() async {
    final service = ref.read(appBlockingServiceProvider);
    final granted = await service.hasUsageStatsPermission();
    final notifGranted = await service.hasNotificationListenerPermission();
    final overlayGranted = await service.hasOverlayPermission();
    if (!mounted) return;
    setState(() {
      hasPermission = granted;
      hasNotificationAccess = notifGranted;
      hasOverlayAccess = overlayGranted;
    });
    if (granted && installed.isEmpty) unawaited(_loadApps());
  }

  Future<void> _requestPermission() async {
    await ref.read(appBlockingServiceProvider).requestUsageStatsPermission();
  }

  Future<void> _requestNotificationAccess() async {
    await ref
        .read(appBlockingServiceProvider)
        .requestNotificationListenerPermission();
  }

  Future<void> _requestOverlayAccess() async {
    await ref.read(appBlockingServiceProvider).requestOverlayPermission();
  }

  Future<void> _loadApps() async {
    final apps = await ref.read(appBlockingServiceProvider).getInstalledApps();
    if (!mounted) return;
    setState(() => installed = apps);
  }

  Future<void> _save() async {
    final notifier = ref.read(settingsProvider.notifier);
    await notifier.updateBlockedApps(selected);
    if (!mounted) return;
    final failed = ref.read(settingsProvider).hasError;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(failed
            ? 'Erro ao salvar. Tente novamente.'
            : 'Salvo (${selected.length} apps selecionados)'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider).value;
    final notifier = ref.read(settingsProvider.notifier);
    final intensity = settings?.blockIntensity ?? BlockIntensity.intense;

    final filtered = _query.isEmpty
        ? installed
        : installed
            .where((a) => a.appName.toLowerCase().contains(_query.toLowerCase()))
            .toList();

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
                  if (!hasOverlayAccess) ...[
                    const SizedBox(height: 8),
                    Card(
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: ListTile(
                        leading: const Icon(Icons.layers_outlined),
                        title: const Text('Permitir aparecer sobre outros apps'),
                        subtitle: const Text(
                            'Sem isso, o retorno ao Honey pode falhar ou demorar'),
                        trailing: TextButton(
                          onPressed: _requestOverlayAccess,
                          child: const Text('Permitir'),
                        ),
                      ),
                    ),
                  ],
                  if (!hasNotificationAccess) ...[
                    const SizedBox(height: 8),
                    Card(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: ListTile(
                        leading: const Icon(Icons.notifications_off_outlined),
                        title: const Text('Silenciar notificações dos apps bloqueados'),
                        subtitle: const Text('Requer acesso a notificações'),
                        trailing: TextButton(
                          onPressed: _requestNotificationAccess,
                          child: const Text('Permitir'),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Apps a bloquear'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Buscar app pelo nome',
                      prefixIcon: Icon(Icons.search),
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                  Expanded(
                    child: installed.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final app = filtered[index];
                              final isChecked =
                                  selected.contains(app.packageName);
                              return CheckboxListTile(
                                secondary: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: app.icon != null
                                      ? MemoryImage(app.icon!)
                                      : null,
                                  child: app.icon == null
                                      ? const Icon(Icons.android)
                                      : null,
                                ),
                                title: Text(app.appName),
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
                    onPressed: _save,
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
                        onPressed: _requestPermission,
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
