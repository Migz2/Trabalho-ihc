import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/timer_state_entity.dart';
import '../../../../core/services/timer_service.dart';

/// Provider for timer state as a stream
final timerProvider = StreamNotifierProvider<TimerNotifier, TimerStateEntity>(() {
  return TimerNotifier();
});

/// Notifier that wraps the TimerService
class TimerNotifier extends StreamNotifier<TimerStateEntity> {
  final _timerService = TimerService();

  @override
  Stream<TimerStateEntity> build() {
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

  /// Get current state
  TimerStateEntity getCurrentState() => _timerService.currentState;
}
