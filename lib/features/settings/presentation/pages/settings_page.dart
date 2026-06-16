import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/settings_provider.dart';
import '../../domain/entities/settings_entity.dart';
import '../../../shared/widgets/honey_card.dart';
import '../../../shared/widgets/honey_button.dart';
import '../../../shared/widgets/coin_display.dart';
import '../pages/profile_page.dart';
import 'app_blocking_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(settingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
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
                            child: Center(child: Text(settings.userName.substring(0,1), style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.primary))),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(settings.userName, style: Theme.of(context).textTheme.titleMedium),
                              Text('Estudante · Nível 1', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                            ],
                          ),
                          const Spacer(),
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
                        const Divider(),
                        _SliderTile(
                          label: 'Pausa curta',
                          value: settings.shortBreakMinutes.toDouble(),
                          min: 1,
                          max: 15,
                          divisions: 14,
                          unit: 'min',
                          onChanged: (v) => ref.read(settingsProvider.notifier).updateShortBreak(v.round()),
                        ),
                        const Divider(),
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
                              final granted = await ref.read(appBlockingServiceProvider).requestUsageStatsPermission();
                              if (!granted) {
                                showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Permissão necessária'), content: const Text('Permissão de acesso às estatísticas de uso é necessária para monitorar apps.'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))]));
                                return;
                              }
                            }
                            await ref.read(settingsProvider.notifier).toggleAppBlocking(v);
                          },
                          onTap: settings.appBlockingEnabled ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AppBlockingPage())) : null,
                        ),
                        const Divider(),
                        _ToggleTile(
                          icon: Icons.notifications_off_outlined,
                          iconColor: Colors.orange,
                          title: 'Silenciar notificações',
                          subtitle: 'Durante o foco',
                          value: settings.silenceNotifications,
                          onChanged: (v) => ref.read(settingsProvider.notifier).toggleSilenceNotifications(v),
                        ),
                        const Divider(),
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
                      const Divider(),
                      ListTile(
                        leading: Icon(Icons.cloud_upload_outlined),
                        title: const Text('Backup & sincronização'),
                        subtitle: Text('Última: hoje'),
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sincronização em breve! ☁️'))),
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
                  Slider(value: settings.ambientVolume, onChanged: (v) => ref.read(settingsProvider.notifier).updateAmbientVolume(v)),
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
      default:
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
              inactiveTrackColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              thumbColor: Theme.of(context).colorScheme.primary,
              overlayColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              trackHeight: 3.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(value: value, min: min, max: max, divisions: divisions, onChanged: onChanged),
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
            Switch(value: value, onChanged: onChanged, activeColor: Theme.of(context).colorScheme.primary, activeTrackColor: Theme.of(context).colorScheme.primary.withOpacity(0.4))
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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../../domain/entities/settings_entity.dart';
import 'profile_page.dart';
import 'app_blocking_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(settingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: async.when(
        data: (s) => _buildBody(context, ref, s!),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Erro carregando configurações')),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, SettingsEntity s) {
    final notifier = ref.read(settingsProvider.notifier);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Personalize', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).textTheme.caption?.color)),
          const SizedBox(height: 4),
          Text('Configurações', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 16),

          // Profile card
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage())),
            child: Card(
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
                      alignment: Alignment.center,
                      child: Text(s.userName.substring(0,1).toUpperCase(), style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.primary)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.userName, style: Theme.of(context).textTheme.titleMedium),
                        Text('Estudante · Nível 1', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).textTheme.caption?.color)),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right_rounded)
                  ],
                ),
              ),
            ),
          ),

          // Pomodoro section
          _sectionHeader(context, 'POMODORO'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  _sliderTile(context, 'Tempo de foco', s.focusDurationMinutes, 5, 60, 11, (v) => notifier.updateFocusDuration(v.round())),
                  const Divider(),
                  _sliderTile(context, 'Pausa curta', s.shortBreakMinutes, 1, 15, 14, (v) => notifier.updateShortBreak(v.round())),
                  const Divider(),
                  _sliderTile(context, 'Pausa longa', s.longBreakMinutes, 5, 30, 5, (v) => notifier.updateLongBreak(v.round())),
                ],
              ),
            ),
          ),

          _sectionHeader(context, 'CONCENTRAÇÃO'),
          Card(
            child: Column(
              children: [
                _toggleTile(context, Icons.shield_outlined, Colors.green, 'Bloqueio de apps', s.appBlockingEnabled ? s.blockIntensity.toString().split('.').last : 'Desativado', s.appBlockingEnabled, (v) async {
                  if (v) {
                    final granted = await ref.read(appBlockingServiceProvider).requestUsageStatsPermission();
                    if (!granted) {
                      showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Permissão necessária'), content: const Text('Permissão de estatísticas de uso necessária')));
                      return;
                    }
                  }
                  await notifier.toggleAppBlocking(v);
                }, onTap: s.appBlockingEnabled ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AppBlockingPage())) : null),
                const Divider(),
                _toggleTile(context, Icons.notifications_off_outlined, Colors.orange, 'Silenciar notificações', 'Durante o foco', s.silenceNotifications, (v) => notifier.toggleSilenceNotifications(v)),
                const Divider(),
                _navigationTile(context, Icons.volume_up_outlined, Colors.blue, 'Sons ambiente', s.ambientSound.toString().split('.').last, () => _showAmbientSoundSheet(context, ref, notifier, s)),
              ],
            ),
          ),

          _sectionHeader(context, 'APARÊNCIA'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: _toggleTile(context, Icons.dark_mode_outlined, Colors.grey, 'Tema escuro', s.themeMode.toString().split('.').last, s.themeMode == AppThemeMode.dark || (s.themeMode == AppThemeMode.system && MediaQuery.platformBrightnessOf(context) == Brightness.dark), (v) => notifier.updateThemeMode(v ? AppThemeMode.dark : AppThemeMode.light)),
            ),
          ),

          _sectionHeader(context, 'CONTA'),
          Card(
            child: Column(
              children: [
                _navigationTile(context, Icons.person_outline, Colors.grey, 'Perfil', '', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()))),
                const Divider(),
                _navigationTile(context, Icons.cloud_upload_outlined, Colors.grey, 'Backup & sincronização', 'Última: hoje', () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sincronização em breve! ☁️')))),
              ],
            ),
          ),

          const SizedBox(height: 32),
          Center(child: Text('Honey v1.0 · feito com 🍯', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).textTheme.caption?.color))),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(title.toUpperCase(), style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5)),
    );
  }

  Widget _sliderTile(BuildContext context, String label, int value, double min, double max, int divisions, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(children: [Text(label, style: Theme.of(context).textTheme.bodyMedium), const Spacer(), Text('$value min', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600))]),
          Slider(value: value.toDouble(), min: min, max: max, divisions: divisions, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _toggleTile(BuildContext context, IconData icon, Color iconColor, String title, String subtitle, bool value, ValueChanged<bool> onChanged, {VoidCallback? onTap}) {
    return ListTile(
      leading: Container(width:36, height:36, decoration: BoxDecoration(color: iconColor.withOpacity(0.15), shape: BoxShape.circle), child: Icon(icon, color: iconColor)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: onTap == null ? Switch(value: value, onChanged: onChanged, activeColor: Theme.of(context).colorScheme.primary) : const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _navigationTile(BuildContext context, IconData icon, Color iconColor, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Container(width:36, height:36, decoration: BoxDecoration(color: iconColor.withOpacity(0.15), shape: BoxShape.circle), child: Icon(icon, color: iconColor)),
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showAmbientSoundSheet(BuildContext context, WidgetRef ref, dynamic notifier, SettingsEntity s) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        builder: (context, scroll) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(width:32, height:4, decoration: BoxDecoration(color: Theme.of(context).dividerColor, borderRadius: BorderRadius.circular(4))),
              const SizedBox(height: 12),
              Text('Sons ambiente', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Row(children: [const Icon(Icons.volume_up), const SizedBox(width:8), const Text('Volume')]),
              Slider(value: s.ambientVolume, min: 0.0, max: 1.0, onChanged: (v) => notifier.updateAmbientVolume(v)),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: AmbientSound.values.map((sound) {
                    final label = sound.toString().split('.').last;
                    final selected = sound == s.ambientSound;
                    return ListTile(
                      leading: const Text('🔊'),
                      title: Text(label),
                      trailing: selected ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
                      onTap: () {
                        notifier.updateAmbientSound(sound);
                        ref.read(ambientSoundServiceProvider).play(sound, s.ambientVolume);
                        Navigator.pop(context);
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
}
