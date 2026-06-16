enum AppThemeMode {
  light,
  dark,
  system,
}

enum AmbientSound {
  none,
  rain,
  forest,
  whitenoise,
  cafe,
  ocean,
}

enum BlockIntensity {
  soft,
  medium,
  intense,
}

class SettingsEntity {
  final int focusDurationMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final int cyclesBeforeLongBreak;

  final bool appBlockingEnabled;
  final BlockIntensity blockIntensity;
  final List<String> blockedAppPackages;
  final bool silenceNotifications;
  final AmbientSound ambientSound;
  final double ambientVolume;

  final AppThemeMode themeMode;

  final String userName;
  final String? userAvatar;

  SettingsEntity({
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

  SettingsEntity copyWith({
    int? focusDurationMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? cyclesBeforeLongBreak,
    bool? appBlockingEnabled,
    BlockIntensity? blockIntensity,
    List<String>? blockedAppPackages,
    bool? silenceNotifications,
    AmbientSound? ambientSound,
    double? ambientVolume,
    AppThemeMode? themeMode,
    String? userName,
    String? userAvatar,
  }) {
    return SettingsEntity(
      focusDurationMinutes: focusDurationMinutes ?? this.focusDurationMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      cyclesBeforeLongBreak: cyclesBeforeLongBreak ?? this.cyclesBeforeLongBreak,
      appBlockingEnabled: appBlockingEnabled ?? this.appBlockingEnabled,
      blockIntensity: blockIntensity ?? this.blockIntensity,
      blockedAppPackages: blockedAppPackages ?? List.from(this.blockedAppPackages),
      silenceNotifications: silenceNotifications ?? this.silenceNotifications,
      ambientSound: ambientSound ?? this.ambientSound,
      ambientVolume: ambientVolume ?? this.ambientVolume,
      themeMode: themeMode ?? this.themeMode,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
    );
  }

  static SettingsEntity defaults() => SettingsEntity(
        focusDurationMinutes: 25,
        shortBreakMinutes: 5,
        longBreakMinutes: 15,
        cyclesBeforeLongBreak: 4,
        appBlockingEnabled: false,
        blockIntensity: BlockIntensity.intense,
        blockedAppPackages: const [],
        silenceNotifications: true,
        ambientSound: AmbientSound.rain,
        ambientVolume: 0.5,
        themeMode: AppThemeMode.system,
        userName: 'Marina',
        userAvatar: null,
      );
}
