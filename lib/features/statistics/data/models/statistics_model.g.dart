// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:hive/hive.dart';
import 'statistics_model.dart';
import 'achievement_model.dart';

class StatisticsModelAdapter extends TypeAdapter<StatisticsModel> {
  @override
  final int typeId = 10;

  @override
  StatisticsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StatisticsModel(
      currentStreak: fields[0] as int,
      longestStreak: fields[1] as int,
      totalHoursStudied: fields[2] as double,
      totalPomodoros: fields[3] as int,
      lastStudyDate: fields[4] as DateTime?,
      achievements: (fields[5] as List).cast<AchievementModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, StatisticsModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.currentStreak)
      ..writeByte(1)
      ..write(obj.longestStreak)
      ..writeByte(2)
      ..write(obj.totalHoursStudied)
      ..writeByte(3)
      ..write(obj.totalPomodoros)
      ..writeByte(4)
      ..write(obj.lastStudyDate)
      ..writeByte(5)
      ..write(obj.achievements);
  }
}
