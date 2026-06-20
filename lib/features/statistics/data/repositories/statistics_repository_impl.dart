import 'package:hive/hive.dart';
import '../../domain/entities/statistics_entity.dart';
import '../../domain/entities/achievement_entity.dart';
import '../../domain/usecases/calculate_weekly_stats_usecase.dart';
import '../../domain/usecases/calculate_streak_usecase.dart';
import '../../../../core/constants/hive_keys.dart';
import '../../../../core/services/hive_service.dart';
import '../../../focus/data/models/focus_session_model.dart';
import '../datasources/achievements_catalog.dart';
import '../models/achievement_model.dart';
import '../models/statistics_model.dart';

class StatisticsRepositoryImpl {
  late Box _statsBox;
  late Box _achBox;

  StatisticsRepositoryImpl() {
    _statsBox = HiveService.getBox(HiveKeys.statisticsBox);
    _achBox = HiveService.getBox(HiveKeys.achievementsBox);
  }

  /// Achievements catalog merged with any previously-persisted unlock state.
  List<AchievementEntity> loadAchievements() {
    final saved = _achBox.get('achievements') as List<dynamic>?;
    if (saved == null) return AchievementsCatalog.catalog;

    final savedById = {
      for (final m in saved.cast<AchievementModel>()) m.toEntity().id: m.toEntity(),
    };

    return AchievementsCatalog.catalog
        .map((a) => savedById[a.id] ?? a)
        .toList();
  }

  Future<void> saveAchievements(List<AchievementEntity> achievements) async {
    final models = achievements.map((a) => AchievementModel.fromEntity(a)).toList();
    await _achBox.put('achievements', models);
  }

  StatisticsEntity loadStatistics(List<FocusSessionModel> sessions) {
    final weekly = CalculateWeeklyStatsUseCase().call(sessions, DateTime.now());
    final streak = CalculateStreakUseCase().call(sessions, DateTime.now());
    final achievements = loadAchievements();

    final totalHours =
        sessions.fold<int>(0, (p, s) => p + s.durationMinutes) / 60.0;
    final totalPomodoros = sessions.fold<int>(0, (p, s) => p + s.cyclesCompleted);

    DateTime? lastStudyDate;
    for (final s in sessions) {
      if (lastStudyDate == null || s.completedAt.isAfter(lastStudyDate)) {
        lastStudyDate = s.completedAt;
      }
    }

    final statsModel = _statsBox.get('statistics') as StatisticsModel?;
    final longestStreak = statsModel == null
        ? streak.longestStreak
        : (streak.longestStreak > statsModel.longestStreak
            ? streak.longestStreak
            : statsModel.longestStreak);

    return StatisticsEntity(
      currentStreak: streak.currentStreak,
      longestStreak: longestStreak,
      totalHoursStudied: totalHours,
      totalPomodoros: totalPomodoros,
      weeklyStats: weekly,
      achievements: achievements,
      lastStudyDate: lastStudyDate,
    );
  }

  Future<void> saveStatistics(StatisticsEntity stats) async {
    final model = StatisticsModel.fromEntity(
      currentStreak: stats.currentStreak,
      longestStreak: stats.longestStreak,
      totalHoursStudied: stats.totalHoursStudied,
      totalPomodoros: stats.totalPomodoros,
      lastStudyDate: stats.lastStudyDate,
      achievements: stats.achievements.map((a) => AchievementModel.fromEntity(a)).toList(),
    );

    await _statsBox.put('statistics', model);
    await _achBox.put('achievements', model.achievements);
  }
}
