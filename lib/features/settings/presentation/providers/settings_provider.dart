import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../../../core/services/providers/service_providers.dart';

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, SettingsEntity?>(() => SettingsNotifier());

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  final async = ref.watch(settingsProvider);
  return async.when(
    data: (s) {
      final mode = s?.themeMode ?? AppThemeMode.system;
      switch (mode) {
        case AppThemeMode.light:
          return ThemeMode.light;
        case AppThemeMode.dark:
          return ThemeMode.dark;
        case AppThemeMode.system:
          return ThemeMode.system;
      }
    },
    loading: () => ThemeMode.system,
    error: (_, __) => ThemeMode.system,
  );
});

class SettingsNotifier extends AsyncNotifier<SettingsEntity?> {
  late final SettingsRepository _repo;

  @override
  Future<SettingsEntity?> build() async {
    _repo = SettingsRepositoryImpl();
    try {
      state = const AsyncValue.loading();
      final settings = await _repo.getSettings();
      state = AsyncValue.data(settings);
      return settings;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<void> updateFocusDuration(int minutes) async {
    if (minutes < 5 || minutes > 60) return;
    try {
      state = const AsyncValue.loading();
      await _repo.updateFocusDuration(minutes);
      final s = await _repo.getSettings();
      state = AsyncValue.data(s);
      // notify TimerProvider: caller should listen to settingsProvider.select
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateShortBreak(int minutes) async {
    if (minutes < 1 || minutes > 15) return;
    try {
      state = const AsyncValue.loading();
      final s = (await _repo.getSettings()).copyWith(shortBreakMinutes: minutes);
      await _repo.saveSettings(s);
      state = AsyncValue.data(s);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateLongBreak(int minutes) async {
    if (minutes < 5 || minutes > 30) return;
    try {
      state = const AsyncValue.loading();
      final s = (await _repo.getSettings()).copyWith(longBreakMinutes: minutes);
      await _repo.saveSettings(s);
      state = AsyncValue.data(s);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateCycles(int count) async {
    if (count < 2 || count > 6) return;
    try {
      state = const AsyncValue.loading();
      final s = (await _repo.getSettings()).copyWith(cyclesBeforeLongBreak: count);
      await _repo.saveSettings(s);
      state = AsyncValue.data(s);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleAppBlocking(bool enabled) async {
    try {
      state = const AsyncValue.loading();
      await _repo.toggleAppBlocking(enabled);
      final s = await _repo.getSettings();
      state = AsyncValue.data(s);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateBlockIntensity(BlockIntensity intensity) async {
    try {
      state = const AsyncValue.loading();
      await _repo.updateBlockIntensity(intensity);
      final s = await _repo.getSettings();
      state = AsyncValue.data(s);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateBlockedApps(List<String> packages) async {
    try {
      state = const AsyncValue.loading();
      await _repo.updateBlockedApps(packages);
      final s = await _repo.getSettings();
      state = AsyncValue.data(s);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleSilenceNotifications(bool enabled) async {
    try {
      state = const AsyncValue.loading();
      await _repo.toggleSilenceNotifications(enabled);
      final s = await _repo.getSettings();
      // apply immediately via NotificationService
      final notif = ref.read(notificationServiceProvider);
      if (enabled) {
        await notif.silenceForFocus();
      } else {
        await notif.cancelAll();
      }
      state = AsyncValue.data(s);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateAmbientSound(AmbientSound sound) async {
    try {
      state = const AsyncValue.loading();
      await _repo.updateAmbientSound(sound);
      final s = await _repo.getSettings();
      // apply via ambientSoundService
      final ambient = ref.read(ambientSoundServiceProvider);
      await ambient.play(sound, s.ambientVolume);
      state = AsyncValue.data(s);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateAmbientVolume(double volume) async {
    try {
      state = const AsyncValue.loading();
      final current = await _repo.getSettings();
      final s = current.copyWith(ambientVolume: volume);
      await _repo.saveSettings(s);
      final ambient = ref.read(ambientSoundServiceProvider);
      await ambient.setVolume(volume);
      state = AsyncValue.data(s);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateThemeMode(AppThemeMode mode) async {
    try {
      state = const AsyncValue.loading();
      await _repo.updateThemeMode(mode);
      final s = await _repo.getSettings();
      state = AsyncValue.data(s);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateUserName(String name) async {
    try {
      state = const AsyncValue.loading();
      final s = (await _repo.getSettings()).copyWith(userName: name);
      await _repo.saveSettings(s);
      // optionally update UserProvider
      state = AsyncValue.data(s);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
