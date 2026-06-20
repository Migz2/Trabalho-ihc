import '../entities/settings_entity.dart';

abstract class SettingsRepository {
  Future<SettingsEntity> getSettings();
  Future<void> saveSettings(SettingsEntity settings);
  Future<void> updateFocusDuration(int minutes);
  Future<void> updateThemeMode(AppThemeMode mode);
  Future<void> toggleAppBlocking(bool enabled);
  Future<void> updateBlockIntensity(BlockIntensity intensity);
  Future<void> updateBlockedApps(List<String> packages);
  Future<void> toggleSilenceNotifications(bool enabled);
  Future<void> updateAmbientSound(AmbientSound sound);
}
