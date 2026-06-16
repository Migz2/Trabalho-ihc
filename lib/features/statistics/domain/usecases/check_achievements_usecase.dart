import '../../data/datasources/achievements_catalog.dart';
import '../entities/achievement_entity.dart';
import '../../../focus/data/models/focus_session_model.dart';

class CheckAchievementsUseCase {
  List<AchievementEntity> call(List<FocusSessionModel> sessions, int currentCoins, int petLevel) {
    final catalog = AchievementsCatalog.catalog;
    final Map<AchievementId, AchievementEntity> map = { for (var a in catalog) a.id: a };

    final totalPomodoros = sessions.fold<int>(0, (p, s) => p + (s.completedPomodoros ?? 0));
    final totalMinutes = sessions.fold<int>(0, (p, s) => p + (s.focusMinutes ?? 0));
    final totalHours = totalMinutes / 60.0;

    final unlocked = <AchievementEntity>[];

    // first session
    if (sessions.isNotEmpty) {
      final a = map[AchievementId.firstSession]!;
      unlocked.add(a.copyWith(unlocked: true));
    }

    // ten hours
    if (totalHours >= 10) {
      final a = map[AchievementId.tenHours]!;
      unlocked.add(a.copyWith(unlocked: true));
    }

    // hundred pomodoros
    if (totalPomodoros >= 100) {
      final a = map[AchievementId.hundredPomodoros]!;
      unlocked.add(a.copyWith(unlocked: true));
    }

    // coins
    if (currentCoins >= 100) {
      final a = map[AchievementId.centurion]!;
      unlocked.add(a.copyWith(unlocked: true));
    }

    // pet level
    if (petLevel >= 5) {
      final a = map[AchievementId.petLevel5]!;
      unlocked.add(a.copyWith(unlocked: true));
    }

    // streaks and time-based achievements will be calculated elsewhere (streak usecase)

    return unlocked;
  }
}
