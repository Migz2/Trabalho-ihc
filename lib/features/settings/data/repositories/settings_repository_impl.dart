import 'package:hive/hive.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../../../core/constants/hive_keys.dart';
import '../../../../core/services/hive_service.dart';
import '../models/settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  late Box _box;

  SettingsRepositoryImpl() {
    _box = HiveService.getBox(HiveKeys.settingsBox);
  }

  @override
  Future<SettingsEntity> getSettings() async {
    final model = _box.get('settings') as SettingsModel?;
    if (model != null) return model.toEntity();

    final defaults = SettingsEntity.defaults();
    await saveSettings(defaults);
    return defaults;
  }

  @override
  Future<void> saveSettings(SettingsEntity settings) async {
    final model = SettingsModel.fromEntity(settings);
    await _box.put('settings', model);
  }

  @override
  Future<void> updateFocusDuration(int minutes) async {
    final s = await getSettings();
    final updated = s.copyWith(focusDurationMinutes: minutes);
    await saveSettings(updated);
  }

  @override
  Future<void> updateThemeMode(AppThemeMode mode) async {
    final s = await getSettings();
    final updated = s.copyWith(themeMode: mode);
    await saveSettings(updated);
  }

  @override
  Future<void> toggleAppBlocking(bool enabled) async {
    final s = await getSettings();
    final updated = s.copyWith(appBlockingEnabled: enabled);
    await saveSettings(updated);
  }

  @override
  Future<void> updateBlockIntensity(BlockIntensity intensity) async {
    final s = await getSettings();
    final updated = s.copyWith(blockIntensity: intensity);
    await saveSettings(updated);
  }

  @override
  Future<void> updateBlockedApps(List<String> packages) async {
    final s = await getSettings();
    final updated = s.copyWith(blockedAppPackages: packages);
    await saveSettings(updated);
  }

  @override
  Future<void> toggleSilenceNotifications(bool enabled) async {
    final s = await getSettings();
    final updated = s.copyWith(silenceNotifications: enabled);
    await saveSettings(updated);
  }

  @override
  Future<void> updateAmbientSound(AmbientSound sound) async {
    final s = await getSettings();
    final updated = s.copyWith(ambientSound: sound);
    await saveSettings(updated);
  }
}
