import 'package:hive/hive.dart';
import '../../domain/entities/timer_state_entity.dart';

part 'timer_state_model.g.dart';

/// Hive model for timer state
@HiveType(typeId: 3)
class TimerStateModel extends HiveObject {
  @HiveField(0)
  int phaseIndex; // 0=focus, 1=shortBreak, 2=longBreak

  @HiveField(1)
  int remainingSeconds;

  @HiveField(2)
  int currentCycle;

  @HiveField(3)
  int totalCycles;

  @HiveField(4)
  bool isRunning;

  @HiveField(5)
  bool isPaused;

  @HiveField(6)
  DateTime? sessionStartedAt;

  TimerStateModel({
    this.phaseIndex = 0,
    required this.remainingSeconds,
    required this.currentCycle,
    this.totalCycles = 4,
    this.isRunning = false,
    this.isPaused = false,
    this.sessionStartedAt,
  });

  /// Convert to entity
  TimerStateEntity toEntity() {
    final phases = [TimerPhase.focus, TimerPhase.shortBreak, TimerPhase.longBreak];
    return TimerStateEntity(
      phase: phases[phaseIndex.clamp(0, 2)],
      remainingSeconds: remainingSeconds,
      currentCycle: currentCycle,
      totalCycles: totalCycles,
      isRunning: isRunning,
      isPaused: isPaused,
      sessionStartedAt: sessionStartedAt,
    );
  }

  /// Create from entity
  factory TimerStateModel.fromEntity(TimerStateEntity entity) {
    final phaseIndex = {
      TimerPhase.focus: 0,
      TimerPhase.shortBreak: 1,
      TimerPhase.longBreak: 2,
    }[entity.phase]!;

    return TimerStateModel(
      phaseIndex: phaseIndex,
      remainingSeconds: entity.remainingSeconds,
      currentCycle: entity.currentCycle,
      totalCycles: entity.totalCycles,
      isRunning: entity.isRunning,
      isPaused: entity.isPaused,
      sessionStartedAt: entity.sessionStartedAt,
    );
  }

  /// Create default initial state
  factory TimerStateModel.initial() {
    return TimerStateModel(
      phaseIndex: 0,
      remainingSeconds: 25 * 60, // 25 minutes in seconds
      currentCycle: 1,
      totalCycles: 4,
      isRunning: false,
      isPaused: false,
      sessionStartedAt: null,
    );
  }

  /// Create copy with modifications
  TimerStateModel copyWith({
    int? phaseIndex,
    int? remainingSeconds,
    int? currentCycle,
    int? totalCycles,
    bool? isRunning,
    bool? isPaused,
    DateTime? sessionStartedAt,
  }) {
    return TimerStateModel(
      phaseIndex: phaseIndex ?? this.phaseIndex,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      currentCycle: currentCycle ?? this.currentCycle,
      totalCycles: totalCycles ?? this.totalCycles,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      sessionStartedAt: sessionStartedAt ?? this.sessionStartedAt,
    );
  }
}
