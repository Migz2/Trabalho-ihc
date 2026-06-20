// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsModelAdapter extends TypeAdapter<SettingsModel> {
  @override
  final int typeId = 11;

  @override
  SettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsModel(
      focusDurationMinutes: fields[0] as int,
      shortBreakMinutes: fields[1] as int,
      longBreakMinutes: fields[2] as int,
      cyclesBeforeLongBreak: fields[3] as int,
      appBlockingEnabled: fields[4] as bool,
      blockIntensity: fields[5] as BlockIntensity,
      blockedAppPackages: (fields[6] as List).cast<String>(),
      silenceNotifications: fields[7] as bool,
      ambientSound: fields[8] as AmbientSound,
      ambientVolume: fields[9] as double,
      themeMode: fields[10] as AppThemeMode,
      userName: fields[11] as String,
      userAvatar: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.focusDurationMinutes)
      ..writeByte(1)
      ..write(obj.shortBreakMinutes)
      ..writeByte(2)
      ..write(obj.longBreakMinutes)
      ..writeByte(3)
      ..write(obj.cyclesBeforeLongBreak)
      ..writeByte(4)
      ..write(obj.appBlockingEnabled)
      ..writeByte(5)
      ..write(obj.blockIntensity)
      ..writeByte(6)
      ..write(obj.blockedAppPackages)
      ..writeByte(7)
      ..write(obj.silenceNotifications)
      ..writeByte(8)
      ..write(obj.ambientSound)
      ..writeByte(9)
      ..write(obj.ambientVolume)
      ..writeByte(10)
      ..write(obj.themeMode)
      ..writeByte(11)
      ..write(obj.userName)
      ..writeByte(12)
      ..write(obj.userAvatar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
