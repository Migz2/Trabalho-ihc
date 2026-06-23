import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/settings_provider.dart';
import '../../domain/entities/settings_entity.dart';
import '../pages/profile_page.dart';
import 'app_blocking_page.dart';
import '../../../../core/services/providers/service_providers.dart';
import '../../../focus/presentation/providers/user_provider.dart';
import '../../../pet/presentation/providers/pet_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(settingsProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: async.when(
        data: (settings) {
          if (settings == null) return const SizedBox.shrink();
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Personalize', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                const SizedBox(height: 4),
                Text('Configurações', style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 16),

                // Profile card
                InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage())),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(child: Text(settings.userName.isNotEmpty ? settings.userName.substring(0,1) : '?', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.primary))),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(settings.userName, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium),
                                Text('Estudante · Nível 1', maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ],
                      ),
                    ),
                  ),
                ),

                // Pomodoro section
                const _SectionHeader('POMODORO'),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        _SliderTile(
                          label: 'Tempo de foco',
                          value: settings.focusDurationMinutes.toDouble(),
                          min: 5,
                          max: 60,
                          divisions: 11,
                          unit: 'min',
                          onChanged: (v) => ref.read(settingsProvider.notifier).updateFocusDuration(v.round()),
                        ),
                        Divider(height: 1, thickness: 0.5, color: Theme.of(context).dividerColor),
                        _SliderTile(
                          label: 'Pausa curta',
                          value: settings.shortBreakMinutes.toDouble(),
                          min: 1,
                          max: 15,
                          divisions: 14,
                          unit: 'min',
                          onChanged: (v) => ref.read(settingsProvider.notifier).updateShortBreak(v.round()),
                        ),
                        Divider(height: 1, thickness: 0.5, color: Theme.of(context).dividerColor),
                        _SliderTile(
                          label: 'Pausa longa',
                          value: settings.longBreakMinutes.toDouble(),
                          min: 5,
                          max: 30,
                          divisions: 5,
                          unit: 'min',
                          onChanged: (v) => ref.read(settingsProvider.notifier).updateLongBreak(v.round()),
                        ),
                      ],
                    ),
                  ),
                ),

                const _SectionHeader('PET'),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Consumer(
                    builder: (context, ref, _) {
                      final petAsync = ref.watch(petProvider);
                      final petName = petAsync.value?.name ?? 'Mel';
                      return _NavigationTile(
                        icon: Icons.pets,
                        iconColor: Theme.of(context).colorScheme.primary,
                        title: 'Nome do pet',
                        subtitle: petName,
                        onTap: () => _showRenameDialog(context, ref, petName),
                      );
                    },
                  ),
                ),

                const _SectionHeader('CONCENTRAÇÃO'),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        _ToggleTile(
                          icon: Icons.shield_outlined,
                          iconColor: Colors.green,
                          title: 'Bloqueio de apps',
                          subtitle: settings.appBlockingEnabled ? settings.blockIntensity.toString() + ' · ' + settings.blockedAppPackages.length.toString() + ' apps' : 'Desativado',
                          value: settings.appBlockingEnabled,
                          onChanged: (v) async {
                            if (v) {
                              final blockingService = ref.read(appBlockingServiceProvider);
                              final granted = await blockingService.hasUsageStatsPermission();
                              if (!granted) {
                                await blockingService.requestUsageStatsPermission();
                                if (!context.mounted) return;
                                unawaited(showDialog(context: context, builder: (dialogContext) => AlertDialog(title: const Text('Permissão necessária'), content: const Text('Permissão de acesso às estatísticas de uso é necessária para monitorar apps.'), actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('OK'))])));
                                return;
                              }
                            }
                            await ref.read(settingsProvider.notifier).toggleAppBlocking(v);
                          },
                          onTap: settings.appBlockingEnabled ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AppBlockingPage())) : null,
                        ),
                        Divider(height: 1, thickness: 0.5, color: Theme.of(context).dividerColor),
                        _ToggleTile(
                          icon: Icons.notifications_off_outlined,
                          iconColor: Colors.orange,
                          title: 'Silenciar notificações',
                          subtitle: 'Durante o foco',
                          value: settings.silenceNotifications,
                          onChanged: (v) => ref.read(settingsProvider.notifier).toggleSilenceNotifications(v),
                        ),
                        Divider(height: 1, thickness: 0.5, color: Theme.of(context).dividerColor),
                        _NavigationTile(
                          icon: Icons.volume_up_outlined,
                          iconColor: Colors.blue,
                          title: 'Sons ambiente',
                          subtitle: settings.ambientSound.toString().split('.').last,
                          onTap: () => _showAmbientSoundSheet(context, ref, settings),
                        ),
                      ],
                    ),
                  ),
                ),

                const _SectionHeader('APARÊNCIA'),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: _ToggleTile(
                      icon: Icons.dark_mode_outlined,
                      iconColor: Colors.grey,
                      title: 'Tema escuro',
                      subtitle: settings.themeMode == AppThemeMode.dark ? 'Escuro' : settings.themeMode == AppThemeMode.light ? 'Claro' : 'Automático',
                      value: settings.themeMode == AppThemeMode.dark || (settings.themeMode == AppThemeMode.system && MediaQuery.platformBrightnessOf(context) == Brightness.dark),
                      onChanged: (v) => ref.read(settingsProvider.notifier).updateThemeMode(v ? AppThemeMode.dark : AppThemeMode.light),
                    ),
                  ),
                ),

                const _SectionHeader('CONTA'),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.person_outline),
                        title: const Text('Perfil'),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage())),
                      ),
                      Divider(height: 1, thickness: 0.5, color: Theme.of(context).dividerColor),
                      ListTile(
                        leading: Icon(Icons.cloud_upload_outlined),
                        title: const Text('Backup & sincronização'),
                        subtitle: Text('Última: hoje'),
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sincronização em breve! ☁️'))),
                      ),
                      Divider(height: 1, thickness: 0.5, color: Theme.of(context).dividerColor),
                      ListTile(
                        leading: const Icon(Icons.bug_report_outlined),
                        title: const Text('Adicionar 500 moedas (teste)'),
                        subtitle: const Text('Atalho de desenvolvimento'),
                        onTap: () async {
                          await ref.read(userProvider.notifier).addCoins(500);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('🍯 +500 moedas adicionadas!')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                Center(child: Text('Honey v1.0 · feito com 🍯', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant))),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Erro ao carregar configurações: $e')),
      ),
    );
  }

  void _showRenameDialog(BuildContext context, WidgetRef ref, String currentPetName) {
    final controller = TextEditingController(text: currentPetName);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Renomear pet'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Novo nome',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          maxLength: 12,
          textCapitalization: TextCapitalization.words,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                await ref.read(petProvider.notifier).renamePet(name);
              }
              Navigator.pop(dialogContext);
              if (context.mounted && name.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$name aí vem! 🐾')),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _showAmbientSoundSheet(BuildContext context, WidgetRef ref, SettingsEntity settings) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        builder: (context, controller) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(width: 32, height: 4, decoration: BoxDecoration(color: Theme.of(context).dividerColor, borderRadius: BorderRadius.circular(999))),
              const SizedBox(height: 12),
              Text('Sons ambiente', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.volume_up_outlined),
                  const SizedBox(width: 8),
                  const Text('Volume'),
                  const Spacer(),
                  Slider(
                    value: settings.ambientVolume,
                    onChanged: (v) => ref.read(settingsProvider.notifier).updateAmbientVolume(v),
                    onChangeEnd: (_) => HapticFeedback.selectionClick(),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  children: AmbientSound.values.map((s) {
                    return ListTile(
                      leading: Text(_emojiForSound(s)),
                      title: Text(s.toString().split('.').last),
                      trailing: s == settings.ambientSound ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
                      onTap: () async {
                        await ref.read(settingsProvider.notifier).updateAmbientSound(s);
                        await ref.read(ambientSoundServiceProvider).play(s, ref.read(settingsProvider).value?.ambientVolume ?? 0.5);
                      },
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _emojiForSound(AmbientSound s) {
    switch (s) {
      case AmbientSound.rain:
        return '🌧️';
      case AmbientSound.forest:
        return '🌲';
      case AmbientSound.whitenoise:
        return '〰️';
      case AmbientSound.cafe:
        return '☕';
      case AmbientSound.ocean:
        return '🌊';
      case AmbientSound.none:
        return '🔇';
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(text.toUpperCase(), style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5, color: Theme.of(context).colorScheme.onSurfaceVariant)),
    );
  }
}

class _SliderTile extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String unit;
  final ValueChanged<double> onChanged;

  const _SliderTile({required this.label, required this.value, required this.min, required this.max, required this.divisions, required this.unit, required this.onChanged, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
              const Spacer(),
              Text('${value.round()} $unit', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600)),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Theme.of(context).colorScheme.primary,
              inactiveTrackColor: Theme.of(context).colorScheme.primaryContainer,
              thumbColor: Theme.of(context).colorScheme.primary,
              overlayColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
              trackHeight: 4.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
              onChangeEnd: (_) => HapticFeedback.selectionClick(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onTap;

  const _ToggleTile({required this.icon, required this.iconColor, required this.title, required this.subtitle, required this.value, required this.onChanged, this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(color: iconColor.withOpacity(0.15), borderRadius: BorderRadius.circular(999)), child: Icon(icon, color: iconColor)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(title, style: Theme.of(context).textTheme.titleMedium), Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant))],
              ),
            ),
            Switch(
              value: value,
              onChanged: (v) {
                HapticFeedback.lightImpact();
                onChanged(v);
              },
              activeColor: Theme.of(context).colorScheme.tertiary,
              activeTrackColor: Theme.of(context).colorScheme.tertiary.withOpacity(0.4),
            )
          ],
        ),
      ),
    );
  }
}

class _NavigationTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _NavigationTile({required this.icon, required this.iconColor, required this.title, required this.onTap, this.subtitle = '', Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(width: 36, height: 36, decoration: BoxDecoration(color: iconColor.withOpacity(0.15), borderRadius: BorderRadius.circular(999)), child: Icon(icon, color: iconColor)),
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
