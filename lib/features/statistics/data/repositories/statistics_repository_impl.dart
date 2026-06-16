import 'package:hive/hive.dart';
import '../../domain/entities/statistics_entity.dart';
import '../../domain/entities/achievement_entity.dart';
import '../../domain/entities/weekly_stats_entity.dart';
import '../../domain/usecases/calculate_weekly_stats_usecase.dart';
import '../../../core/constants/hive_keys.dart';
import '../../../core/services/hive_service.dart';
import '../../../focus/data/models/focus_session_model.dart';
import '../models/achievement_model.dart';
import '../models/statistics_model.dart';

class StatisticsRepositoryImpl {
  late Box _statsBox;
  late Box _achBox;

  StatisticsRepositoryImpl() {
    _statsBox = HiveService.getBox(HiveKeys.statisticsBox);
    _achBox = HiveService.getBox(HiveKeys.achievementsBox);
  }

  StatisticsEntity loadStatistics(List<FocusSessionModel> sessions) {
    // Load saved stats model if exists
    final statsModel = _statsBox.get('statistics') as StatisticsModel?;
    final achievementsModels = _achBox.get('achievements') as List<dynamic>?;

    final achievements = achievementsModels != null
        ? achievementsModels.cast<AchievementModel>().map((m) => m.toEntity()).toList()
        : [];

    final weekly = CalculateWeeklyStatsUseCase().call(sessions, DateTime.now());

    if (statsModel != null) {
      return StatisticsEntity(
        currentStreak: statsModel.currentStreak,
        longestStreak: statsModel.longestStreak,
        totalHoursStudied: statsModel.totalHoursStudied,
        totalPomodoros: statsModel.totalPomodoros,
        weeklyStats: weekly,
        achievements: achievements,
        lastStudyDate: statsModel.lastStudyDate,
      );
    }

    return StatisticsEntity(
      currentStreak: 0,
      longestStreak: 0,
      totalHoursStudied: 0.0,
      totalPomodoros: 0,
      weeklyStats: weekly,
      achievements: achievements,
      lastStudyDate: null,
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
