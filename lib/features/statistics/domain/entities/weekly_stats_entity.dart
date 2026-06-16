class DayStats {
  final DateTime date;
  final double hoursStudied;
  final int pomodorosCompleted;

  DayStats({
    required this.date,
    required this.hoursStudied,
    required this.pomodorosCompleted,
  });
}

class WeeklyStatsEntity {
  final List<DayStats> days; // length == 7
  final double totalHours;
  final double previousWeekHours;
  final double growthPercentage;
  final int totalPomodoros;

  WeeklyStatsEntity({
    required this.days,
    required this.totalHours,
    required this.previousWeekHours,
    required this.growthPercentage,
    required this.totalPomodoros,
  });
}
