import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/timer_state_entity.dart';
import '../../../../core/services/hive_service.dart';
import '../../../../core/services/timer_service.dart';
import '../../data/models/focus_session_model.dart';
import 'user_provider.dart';
import '../../../pet/presentation/providers/pet_provider.dart';
import '../../../statistics/presentation/providers/statistics_provider.dart';

/// Provider for timer state as a stream
final timerProvider = StreamNotifierProvider<TimerNotifier, TimerStateEntity>(() {
  return TimerNotifier();
});

/// Coins earned by the most recently completed focus cycle, surfaced once so
/// the UI can show a celebration overlay then clear it.
final lastCycleCoinsEarnedProvider = StateProvider<int?>((ref) => null);

/// New pet level reached by the most recently completed focus cycle, if any.
final petLevelUpEventProvider = StateProvider<int?>((ref) => null);

/// Notifier that wraps the TimerService
class TimerNotifier extends StreamNotifier<TimerStateEntity> {
  final _timerService = TimerService();
  late final StreamSubscription<TimerPhase> _phaseSubscription;

  @override
  Stream<TimerStateEntity> build() {
    _phaseSubscription = _timerService.phaseCompleteStream.listen((phase) {
      if (phase == TimerPhase.focus) {
        final currentCycle = _timerService.currentState.currentCycle;
        final coinsEarned = 12 + (currentCycle - 1) * 3;
        ref.read(userProvider.notifier).addCoins(coinsEarned);
        ref.read(lastCycleCoinsEarnedProvider.notifier).state = coinsEarned;

        // Apply focus reward to pet
        ref.read(petProvider.notifier).applyFocusReward().then((result) {
          if (result.levelUpOccurred) {
            final newLevel = ref.read(petProvider).value?.level;
            if (newLevel != null) {
              ref.read(petLevelUpEventProvider.notifier).state = newLevel;
            }
          }
        });

        // Persist the completed session and refresh derived statistics
        final session = FocusSessionModel(
          id: const Uuid().v4(),
          durationMinutes: _timerService.focusDurationMinutes,
          completedAt: DateTime.now(),
          cyclesCompleted: 1,
          coinsEarned: coinsEarned,
          wasInterrupted: false,
        );
        HiveService.saveFocusSession(session).then((_) {
          ref.read(statisticsProvider.notifier).refresh();
        });
      }
    });

    ref.onDispose(() {
      _phaseSubscription.cancel();
    });

    return _timerService.stateStream;
  }

  /// Start timer
  void start() => _timerService.start();

  /// Pause timer
  void pause() => _timerService.pause();

  /// Resume timer
  void resume() => _timerService.resume();

  /// Reset timer
  void reset() => _timerService.reset();

  /// Skip to next phase
  void skipPhase() => _timerService.skipPhase();

  /// Adjust the configured duration (minutes) for a phase. Only takes
  /// visible effect immediately if the timer is idle on that phase.
  void setPhaseDuration(TimerPhase phase, int minutes) =>
      _timerService.setPhaseDuration(phase, minutes);

  /// Handle app resume lifecycle event
  void onAppResumed() => _timerService.onAppResumed();

  /// Handle app pause lifecycle event
  void onAppPaused() => _timerService.onAppPaused();

  /// Get current state
  TimerStateEntity getCurrentState() => _timerService.currentState;
}
