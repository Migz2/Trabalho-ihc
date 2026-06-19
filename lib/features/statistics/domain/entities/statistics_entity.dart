import 'weekly_stats_entity.dart';
import 'achievement_entity.dart';

class StatisticsEntity {
  final int currentStreak;
  final int longestStreak;
  final double totalHoursStudied;
  final int totalPomodoros;
  final WeeklyStatsEntity weeklyStats;
  final List<AchievementEntity> achievements;
  final DateTime? lastStudyDate;

  StatisticsEntity({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalHoursStudied,
    required this.totalPomodoros,
    required this.weeklyStats,
    required this.achievements,
    required this.lastStudyDate,
  });

  StatisticsEntity copyWith({
    int? currentStreak,
    int? longestStreak,
    double? totalHoursStudied,
    int? totalPomodoros,
    WeeklyStatsEntity? weeklyStats,
    List<AchievementEntity>? achievements,
    DateTime? lastStudyDate,
  }) {
    return StatisticsEntity(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalHoursStudied: totalHoursStudied ?? this.totalHoursStudied,
      totalPomodoros: totalPomodoros ?? this.totalPomodoros,
      weeklyStats: weeklyStats ?? this.weeklyStats,
      achievements: achievements ?? this.achievements,
      lastStudyDate: lastStudyDate ?? this.lastStudyDate,
    );
  }
}
