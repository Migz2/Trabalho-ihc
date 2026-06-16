// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:hive/hive.dart';
import 'achievement_model.dart';

class AchievementModelAdapter extends TypeAdapter<AchievementModel> {
  @override
  final int typeId = 8;

  @override
  AchievementModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AchievementModel(
      id: fields[0] as int,
      title: fields[1] as String,
      description: fields[2] as String,
      emoji: fields[3] as String,
      coinReward: fields[4] as int,
      unlocked: fields[5] as bool,
      unlockedAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AchievementModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.emoji)
      ..writeByte(4)
      ..write(obj.coinReward)
      ..writeByte(5)
      ..write(obj.unlocked)
      ..writeByte(6)
      ..write(obj.unlockedAt);
  }
}

class AchievementIdAdapter extends TypeAdapter<AchievementId> {
  @override
  final int typeId = 9;

  @override
  AchievementId read(BinaryReader reader) {
    final idx = reader.readByte();
    return AchievementId.values[idx];
  }

  @override
  void write(BinaryWriter writer, AchievementId obj) {
    writer.writeByte(obj.index);
  }
}
