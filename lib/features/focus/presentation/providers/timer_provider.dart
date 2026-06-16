import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/timer_state_entity.dart';
import '../../../../core/services/timer_service.dart';
import 'user_provider.dart';

/// Provider for timer state as a stream
final timerProvider = StreamNotifierProvider<TimerNotifier, TimerStateEntity>(() {
  return TimerNotifier();
});

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

  /// Handle app resume lifecycle event
  void onAppResumed() => _timerService.onAppResumed();

  /// Handle app pause lifecycle event
  void onAppPaused() => _timerService.onAppPaused();

  /// Get current state
  TimerStateEntity getCurrentState() => _timerService.currentState;
}
