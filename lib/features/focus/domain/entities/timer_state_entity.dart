/// Timer phase states
enum TimerPhase { focus, shortBreak, longBreak }

/// Current state of the Pomodoro timer
class TimerStateEntity {
  final TimerPhase phase;
  final int remainingSeconds;
  final int currentCycle; // 1 to 4
  final int totalCycles;
  final bool isRunning;
  final bool isPaused;
  final DateTime? sessionStartedAt;

  TimerStateEntity({
    required this.phase,
    required this.remainingSeconds,
    required this.currentCycle,
    this.totalCycles = 4,
    this.isRunning = false,
    this.isPaused = false,
    this.sessionStartedAt,
  });

  /// Check if current phase is focus
  bool get isFocusPhase => phase == TimerPhase.focus;

  /// Check if timer is idle
  bool get isIdle => !isRunning && !isPaused;

  TimerStateEntity copyWith({
    TimerPhase? phase,
    int? remainingSeconds,
    int? currentCycle,
    int? totalCycles,
    bool? isRunning,
    bool? isPaused,
    DateTime? sessionStartedAt,
  }) {
    return TimerStateEntity(
      phase: phase ?? this.phase,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      currentCycle: currentCycle ?? this.currentCycle,
      totalCycles: totalCycles ?? this.totalCycles,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      sessionStartedAt: sessionStartedAt ?? this.sessionStartedAt,
    );
  }

  /// Get phase display name
  String get phaseName {
    switch (phase) {
      case TimerPhase.focus:
        return 'FOCO';
      case TimerPhase.shortBreak:
        return 'PAUSA';
      case TimerPhase.longBreak:
        return 'PAUSA';
    }
  }

  /// Get total seconds for current phase
  int getTotalSecondsForPhase(int focusDuration, int shortBreakDuration, int longBreakDuration) {
    switch (phase) {
      case TimerPhase.focus:
        return focusDuration * 60;
      case TimerPhase.shortBreak:
        return shortBreakDuration * 60;
      case TimerPhase.longBreak:
        return longBreakDuration * 60;
    }
  }

  /// Get progress percentage (0.0 to 1.0)
  double getProgress(int totalSeconds) {
    if (totalSeconds == 0) return 0.0;
    return 1.0 - (remainingSeconds / totalSeconds);
  }
}
