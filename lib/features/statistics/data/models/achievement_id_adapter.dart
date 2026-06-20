import 'package:hive/hive.dart';
import 'package:honey/features/statistics/domain/entities/achievement_entity.dart';

class AchievementIdAdapter extends TypeAdapter<AchievementId> {
  @override
  final int typeId = 15;

  @override
  AchievementId read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AchievementId.firstSession;
      case 1:
        return AchievementId.firstWeek;
      case 2:
        return AchievementId.tenHours;
      case 3:
        return AchievementId.hundredPomodoros;
      case 4:
        return AchievementId.streakThree;
      case 5:
        return AchievementId.streakSeven;
      case 6:
        return AchievementId.streakThirty;
      case 7:
        return AchievementId.nightOwl;
      case 8:
        return AchievementId.earlyBird;
      case 9:
        return AchievementId.centurion;
      case 10:
        return AchievementId.petLevel5;
      default:
        return AchievementId.firstSession;
    }
  }

  @override
  void write(BinaryWriter writer, AchievementId obj) {
    writer.writeByte(obj.index);
  }
}
