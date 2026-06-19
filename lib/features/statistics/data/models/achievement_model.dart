import 'package:hive/hive.dart';
import '../../domain/entities/achievement_entity.dart';

part 'achievement_model.g.dart';

@HiveType(typeId: 8)
class AchievementModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String emoji;

  @HiveField(4)
  final int coinReward;

  @HiveField(5)
  final bool unlocked;

  @HiveField(6)
  final DateTime? unlockedAt;

  AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.coinReward,
    required this.unlocked,
    this.unlockedAt,
  });

  factory AchievementModel.fromEntity(AchievementEntity e) {
    return AchievementModel(
      id: e.id.index,
      title: e.title,
      description: e.description,
      emoji: e.emoji,
      coinReward: e.coinReward,
      unlocked: e.unlocked,
      unlockedAt: e.unlockedAt,
    );
  }

  AchievementEntity toEntity() {
    return AchievementEntity(
      id: AchievementId.values[id],
      title: title,
      description: description,
      emoji: emoji,
      coinReward: coinReward,
      unlocked: unlocked,
      unlockedAt: unlockedAt,
    );
  }
}
