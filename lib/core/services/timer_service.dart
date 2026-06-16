import 'dart:async';
import '../../features/focus/domain/entities/timer_state_entity.dart';
import '../../features/focus/data/models/timer_state_model.dart';
import '../../core/constants/hive_keys.dart';
import 'hive_service.dart';

/// Manages Pomodoro timer with reliable state persistence
class TimerService {
  static const String _tag = 'TimerService';

  // Timer and stopwatch for accurate timekeeping
  Timer? _timer;
  final Stopwatch _stopwatch = Stopwatch();

  // Durations (configurable)
  int focusDurationMinutes = 25;
  int shortBreakDurationMinutes = 5;
  int longBreakDurationMinutes = 15;

  // Current state
  late TimerStateEntity _currentState;

  // Event streams
  final _stateStreamController = StreamController<TimerStateEntity>.broadcast();
  Stream<TimerStateEntity> get stateStream async* {
    yield _currentState;
    yield* _stateStreamController.stream;
  }
  final _phaseCompleteController = StreamController<TimerPhase>.broadcast();
  Stream<TimerPhase> get phaseCompleteStream => _phaseCompleteController.stream;

  // Singleton
  static final TimerService _instance = TimerService._internal();
  factory TimerService() => _instance;
  TimerService._internal() {
    _loadStateFromHive();
  }

  /// Get current timer state
  TimerStateEntity get currentState => _currentState;

  /// Initialize timer from Hive storage
  void _loadStateFromHive() {
    try {
      final savedState = HiveService.get(
        boxName: HiveKeys.sessionBox,
        key: 'currentTimerState',
      );

      if (savedState != null && savedState is TimerStateModel) {
        _currentState = savedState.toEntity();
        print('[$_tag] Loaded timer state from Hive: ${_currentState.phase}');
      } else {
        _currentState = TimerStateEntity(
          phase: TimerPhase.focus,
          remainingSeconds: focusDurationMinutes * 60,
          currentCycle: 1,
          totalCycles: 4,
          isRunning: false,
          isPaused: false,
          sessionStartedAt: null,
        );
        _saveStateToHive();
        print('[$_tag] Created initial timer state');
      }
    } catch (e) {
      print('[$_tag] Error loading state from Hive: $e');
      _currentState = TimerStateEntity(
        phase: TimerPhase.focus,
        remainingSeconds: focusDurationMinutes * 60,
        currentCycle: 1,
        totalCycles: 4,
        isRunning: false,
        isPaused: false,
        sessionStartedAt: null,
      );
    }
  }

  /// Save current state to Hive
  void _saveStateToHive() {
    try {
      final model = TimerStateModel.fromEntity(_currentState);
      HiveService.put(
        boxName: HiveKeys.sessionBox,
        key: 'currentTimerState',
        value: model,
      );
    } catch (e) {
      print('[$_tag] Error saving state to Hive: $e');
    }
  }

  /// Emit current state to listeners
  void _emitState() {
    if (!_stateStreamController.isClosed) {
      _stateStreamController.add(_currentState);
    }
  }

  void _startPeriodicTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  /// Start timer
  void start() {
    if (_currentState.isRunning) return;

    _stopwatch.reset();
    _stopwatch.start();

    _currentState = _currentState.copyWith(
      isRunning: true,
      isPaused: false,
      sessionStartedAt: DateTime.now(),
    );

    _startPeriodicTimer();
    _saveStateToHive();
    _emitState();

    print('[$_tag] Timer started');
  }

  /// Pause timer
  void pause() {
    if (!_currentState.isRunning) return;

    _stopwatch.stop();
    _timer?.cancel();

    _currentState = _currentState.copyWith(
      isRunning: false,
      isPaused: true,
      sessionStartedAt: null,
    );

    _saveStateToHive();
    _emitState();

    print('[$_tag] Timer paused');
  }

  /// Resume paused timer
  void resume() {
    if (!_currentState.isPaused) return;

    _stopwatch.reset();
    _stopwatch.start();

    _currentState = _currentState.copyWith(
      isRunning: true,
      isPaused: false,
      sessionStartedAt: DateTime.now(),
    );

    _startPeriodicTimer();
    _saveStateToHive();
    _emitState();

    print('[$_tag] Timer resumed');
  }

  /// Reset timer
  void reset() {
    _timer?.cancel();
    _stopwatch.reset();

    _currentState = TimerStateEntity(
      phase: TimerPhase.focus,
      remainingSeconds: focusDurationMinutes * 60,
      currentCycle: 1,
      totalCycles: 4,
      isRunning: false,
      isPaused: false,
      sessionStartedAt: null,
    );

    _saveStateToHive();
    _emitState();

    print('[$_tag] Timer reset');
  }

  /// Skip to next phase
  void skipPhase() {
    _timer?.cancel();
    _stopwatch.reset();

    _advancePhase();

    print('[$_tag] Phase skipped');
  }

  void _completePhase() {
    final finishedPhase = _currentState.phase;

    _timer?.cancel();
    _stopwatch.reset();

    _currentState = _currentState.copyWith(
      remainingSeconds: 0,
      isRunning: false,
      isPaused: false,
      sessionStartedAt: null,
    );

    _saveStateToHive();
    _emitState();
    _phaseCompleteController.add(finishedPhase);

    _advancePhase();
  }

  /// Advance to next phase
  void _advancePhase() {
    TimerPhase nextPhase;
    int nextCycle = _currentState.currentCycle;

    if (_currentState.phase == TimerPhase.focus) {
      if (_currentState.currentCycle >= _currentState.totalCycles) {
        nextPhase = TimerPhase.longBreak;
      } else {
        nextPhase = TimerPhase.shortBreak;
      }
    } else if (_currentState.phase == TimerPhase.longBreak) {
      nextPhase = TimerPhase.focus;
      nextCycle = 1;
    } else {
      nextPhase = TimerPhase.focus;
      nextCycle = _currentState.currentCycle + 1;
    }

    final totalSeconds = _getTotalSecondsForPhase(nextPhase);

    _currentState = TimerStateEntity(
      phase: nextPhase,
      remainingSeconds: totalSeconds,
      currentCycle: nextCycle,
      totalCycles: _currentState.totalCycles,
      isRunning: false,
      isPaused: false,
      sessionStartedAt: null,
    );

    _saveStateToHive();
    _emitState();
  }

  /// Internal tick handler
  void _onTick(Timer timer) {
    final now = DateTime.now();
    final elapsedSeconds = _currentState.sessionStartedAt == null
        ? 1
        : now.difference(_currentState.sessionStartedAt!).inSeconds;

    final remaining = _currentState.remainingSeconds - elapsedSeconds;

    if (remaining <= 0) {
      _completePhase();
      return;
    }

    _currentState = _currentState.copyWith(
      remainingSeconds: remaining,
      sessionStartedAt: now,
    );

    _saveStateToHive();
    _emitState();
  }

  /// Get total seconds for a phase
  int _getTotalSecondsForPhase(TimerPhase phase) {
    switch (phase) {
      case TimerPhase.focus:
        return focusDurationMinutes * 60;
      case TimerPhase.shortBreak:
        return shortBreakDurationMinutes * 60;
      case TimerPhase.longBreak:
        return longBreakDurationMinutes * 60;
    }
  }

  /// Handle app lifecycle resume (recalculate after background)
  void onAppResumed() {
    if (!_currentState.isRunning) {
      return;
    }

    final lastTick = _currentState.sessionStartedAt;
    if (lastTick == null) {
      _currentState = _currentState.copyWith(sessionStartedAt: DateTime.now());
      _saveStateToHive();
      _emitState();
      _startPeriodicTimer();
      return;
    }

    final now = DateTime.now();
    final elapsedSeconds = now.difference(lastTick).inSeconds;

    if (elapsedSeconds <= 0) {
      _startPeriodicTimer();
      return;
    }

    final remaining = _currentState.remainingSeconds - elapsedSeconds;
    if (remaining <= 0) {
      _completePhase();
      return;
    }

    _currentState = _currentState.copyWith(
      remainingSeconds: remaining,
      sessionStartedAt: now,
    );
    _saveStateToHive();
    _emitState();
    _startPeriodicTimer();
  }

  /// Handle app lifecycle pause
  void onAppPaused() {
    if (_currentState.isRunning) {
      _stopwatch.stop();
      _saveStateToHive();
      print('[$_tag] App paused, timer preserved');
    }
  }

  /// Cleanup
  void dispose() {
    _timer?.cancel();
    _stateStreamController.close();
    _phaseCompleteController.close();
  }
}
