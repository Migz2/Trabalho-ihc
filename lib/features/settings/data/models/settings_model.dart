import 'package:hive/hive.dart';
import '../../domain/entities/settings_entity.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 11)
class SettingsModel {
  @HiveField(0)
  final int focusDurationMinutes;

  @HiveField(1)
  final int shortBreakMinutes;

  @HiveField(2)
  final int longBreakMinutes;

  @HiveField(3)
  final int cyclesBeforeLongBreak;

  @HiveField(4)
  final bool appBlockingEnabled;

  @HiveField(5)
  final BlockIntensity blockIntensity;

  @HiveField(6)
  final List<String> blockedAppPackages;

  @HiveField(7)
  final bool silenceNotifications;

  @HiveField(8)
  final AmbientSound ambientSound;

  @HiveField(9)
  final double ambientVolume;

  @HiveField(10)
  final AppThemeMode themeMode;

  @HiveField(11)
  final String userName;

  @HiveField(12)
  final String? userAvatar;

  SettingsModel({
    required this.focusDurationMinutes,
    required this.shortBreakMinutes,
    required this.longBreakMinutes,
    required this.cyclesBeforeLongBreak,
    required this.appBlockingEnabled,
    required this.blockIntensity,
    required this.blockedAppPackages,
    required this.silenceNotifications,
    required this.ambientSound,
    required this.ambientVolume,
    required this.themeMode,
    required this.userName,
    this.userAvatar,
  });

  factory SettingsModel.fromEntity(SettingsEntity e) {
    return SettingsModel(
      focusDurationMinutes: e.focusDurationMinutes,
      shortBreakMinutes: e.shortBreakMinutes,
      longBreakMinutes: e.longBreakMinutes,
      cyclesBeforeLongBreak: e.cyclesBeforeLongBreak,
      appBlockingEnabled: e.appBlockingEnabled,
      blockIntensity: e.blockIntensity,
      blockedAppPackages: List.from(e.blockedAppPackages),
      silenceNotifications: e.silenceNotifications,
      ambientSound: e.ambientSound,
      ambientVolume: e.ambientVolume,
      themeMode: e.themeMode,
      userName: e.userName,
      userAvatar: e.userAvatar,
    );
  }

  SettingsEntity toEntity() {
    return SettingsEntity(
      focusDurationMinutes: focusDurationMinutes,
      shortBreakMinutes: shortBreakMinutes,
      longBreakMinutes: longBreakMinutes,
      cyclesBeforeLongBreak: cyclesBeforeLongBreak,
      appBlockingEnabled: appBlockingEnabled,
      blockIntensity: blockIntensity,
      blockedAppPackages: List.from(blockedAppPackages),
      silenceNotifications: silenceNotifications,
      ambientSound: ambientSound,
      ambientVolume: ambientVolume,
      themeMode: themeMode,
      userName: userName,
      userAvatar: userAvatar,
    );
  }
}
