import '../../data/datasources/achievements_catalog.dart';
import '../entities/achievement_entity.dart';
import '../../../focus/data/models/focus_session_model.dart';

class CheckAchievementsUseCase {
  List<AchievementEntity> call(
    List<FocusSessionModel> sessions,
    int currentCoins,
    int petLevel, {
    int currentStreak = 0,
  }) {
    final catalog = AchievementsCatalog.catalog;
    final Map<AchievementId, AchievementEntity> map = { for (var a in catalog) a.id: a };

    final totalPomodoros = sessions.fold<int>(0, (p, s) => p + s.cyclesCompleted);
    final totalMinutes = sessions.fold<int>(0, (p, s) => p + s.durationMinutes);
    final totalHours = totalMinutes / 60.0;

    final unlocked = <AchievementEntity>[];

    void unlock(AchievementId id) {
      unlocked.add(map[id]!.copyWith(unlocked: true, unlockedAt: DateTime.now()));
    }

    if (sessions.isNotEmpty) unlock(AchievementId.firstSession);
    if (totalHours >= 10) unlock(AchievementId.tenHours);
    if (totalPomodoros >= 100) unlock(AchievementId.hundredPomodoros);
    if (currentCoins >= 100) unlock(AchievementId.centurion);
    if (petLevel >= 5) unlock(AchievementId.petLevel5);
    if (currentStreak >= 3) unlock(AchievementId.streakThree);
    if (currentStreak >= 7) unlock(AchievementId.streakSeven);
    if (currentStreak >= 30) unlock(AchievementId.streakThirty);
    if (currentStreak >= 7) unlock(AchievementId.firstWeek);
    if (sessions.any((s) => s.completedAt.hour >= 22)) {
      unlock(AchievementId.nightOwl);
    }
    if (sessions.any((s) => s.completedAt.hour < 7)) {
      unlock(AchievementId.earlyBird);
    }

    return unlocked;
  }
}
