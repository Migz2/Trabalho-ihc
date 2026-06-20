import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/statistics_repository_impl.dart';
import '../../domain/entities/achievement_entity.dart';
import '../../domain/usecases/check_achievements_usecase.dart';
import '../../domain/entities/statistics_entity.dart';
import '../../../../core/services/hive_service.dart';
import '../../../focus/presentation/providers/user_provider.dart';
import '../../../pet/presentation/providers/pet_provider.dart';

/// Achievements newly unlocked by the most recent recompute, surfaced once
/// so the UI can show a celebration overlay then clear the list.
final newlyUnlockedAchievementsProvider =
    StateProvider<List<AchievementEntity>>((ref) => []);

final statisticsProvider =
    AsyncNotifierProvider<StatisticsNotifier, StatisticsEntity>(
  () => StatisticsNotifier(),
);

class StatisticsNotifier extends AsyncNotifier<StatisticsEntity> {
  final _repo = StatisticsRepositoryImpl();

  @override
  Future<StatisticsEntity> build() async {
    return _recompute();
  }

  Future<StatisticsEntity> _recompute() async {
    final sessions = HiveService.getAllSessions();
    var stats = _repo.loadStatistics(sessions);

    final currentCoins = ref.read(userProvider).value?.coins ?? 0;
    final petLevel = ref.read(petProvider).value?.level ?? 1;

    final newlyQualified = CheckAchievementsUseCase().call(
      sessions,
      currentCoins,
      petLevel,
      currentStreak: stats.currentStreak,
    );

    final alreadyUnlockedIds =
        stats.achievements.where((a) => a.unlocked).map((a) => a.id).toSet();
    final newlyUnlocked =
        newlyQualified.where((a) => !alreadyUnlockedIds.contains(a.id)).toList();

    if (newlyQualified.isNotEmpty) {
      final byId = {for (final a in newlyQualified) a.id: a};
      final merged = stats.achievements.map((a) => byId[a.id] ?? a).toList();
      stats = stats.copyWith(achievements: merged);
      await _repo.saveAchievements(merged);
    }

    await _repo.saveStatistics(stats);

    if (newlyUnlocked.isNotEmpty) {
      ref.read(newlyUnlockedAchievementsProvider.notifier).state = newlyUnlocked;
    }

    return stats;
  }

  /// Call after a focus session is persisted to refresh all derived stats.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_recompute);
  }
}
