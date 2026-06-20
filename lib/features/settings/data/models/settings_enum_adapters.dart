import 'package:hive/hive.dart';
import 'package:honey/features/settings/domain/entities/settings_entity.dart';

class AppThemeModeAdapter extends TypeAdapter<AppThemeMode> {
  @override
  final int typeId = 12;

  @override
  AppThemeMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppThemeMode.light;
      case 1:
        return AppThemeMode.dark;
      case 2:
        return AppThemeMode.system;
      default:
        return AppThemeMode.system;
    }
  }

  @override
  void write(BinaryWriter writer, AppThemeMode obj) {
    writer.writeByte(obj.index);
  }
}

class AmbientSoundAdapter extends TypeAdapter<AmbientSound> {
  @override
  final int typeId = 13;

  @override
  AmbientSound read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AmbientSound.none;
      case 1:
        return AmbientSound.rain;
      case 2:
        return AmbientSound.forest;
      case 3:
        return AmbientSound.whitenoise;
      case 4:
        return AmbientSound.cafe;
      case 5:
        return AmbientSound.ocean;
      default:
        return AmbientSound.none;
    }
  }

  @override
  void write(BinaryWriter writer, AmbientSound obj) {
    writer.writeByte(obj.index);
  }
}

class BlockIntensityAdapter extends TypeAdapter<BlockIntensity> {
  @override
  final int typeId = 14;

  @override
  BlockIntensity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BlockIntensity.soft;
      case 1:
        return BlockIntensity.medium;
      case 2:
        return BlockIntensity.intense;
      default:
        return BlockIntensity.intense;
    }
  }

  @override
  void write(BinaryWriter writer, BlockIntensity obj) {
    writer.writeByte(obj.index);
  }
}
