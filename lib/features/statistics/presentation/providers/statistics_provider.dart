import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/statistics_repository_impl.dart';
import '../../../focus/data/models/focus_session_model.dart';

final statisticsProvider = StateNotifierProvider<StatisticsNotifier, AsyncValue<void>>((ref) {
  return StatisticsNotifier();
});

class StatisticsNotifier extends StateNotifier<AsyncValue<void>> {
  StatisticsNotifier() : super(const AsyncValue.data(null));

  final _repo = StatisticsRepositoryImpl();

  void recompute(List<FocusSessionModel> sessions) {
    try {
      state = const AsyncValue.loading();
      final stats = _repo.loadStatistics(sessions);
      // for now we don't push a UI model, but we could expose it later
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> recordSession(FocusSessionModel session) async {
    try {
      state = const AsyncValue.loading();
      // reload sessions from Hive and recompute then save
      final sessions = await _loadAllSessions();
      sessions.add(session);
      final stats = _repo.loadStatistics(sessions);
      await _repo.saveStatistics(stats);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<List<FocusSessionModel>> _loadAllSessions() async {
    // re-use HiveService session box
    final box = await Future.value();
    // caller will pass sessions in for now
    return [];
  }
}
