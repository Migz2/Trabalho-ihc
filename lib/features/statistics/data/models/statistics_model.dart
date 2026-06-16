import 'package:hive/hive.dart';
import 'achievement_model.dart';

part 'statistics_model.g.dart';

@HiveType(typeId: 10)
class StatisticsModel {
  @HiveField(0)
  final int currentStreak;

  @HiveField(1)
  final int longestStreak;

  @HiveField(2)
  final double totalHoursStudied;

  @HiveField(3)
  final int totalPomodoros;

  @HiveField(4)
  final DateTime? lastStudyDate;

  @HiveField(5)
  final List<AchievementModel> achievements;

  StatisticsModel({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalHoursStudied,
    required this.totalPomodoros,
    this.lastStudyDate,
    required this.achievements,
  });

  factory StatisticsModel.fromEntity({
    required int currentStreak,
    required int longestStreak,
    required double totalHoursStudied,
    required int totalPomodoros,
    DateTime? lastStudyDate,
    required List<AchievementModel> achievements,
  }) {
    return StatisticsModel(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      totalHoursStudied: totalHoursStudied,
      totalPomodoros: totalPomodoros,
      lastStudyDate: lastStudyDate,
      achievements: achievements,
    );
  }
}
