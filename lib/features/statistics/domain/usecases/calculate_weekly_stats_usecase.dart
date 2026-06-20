import '../../../focus/data/models/focus_session_model.dart';
import '../entities/weekly_stats_entity.dart';

class CalculateWeeklyStatsUseCase {
  WeeklyStatsEntity call(List<FocusSessionModel> sessions, DateTime referenceDate) {
    final start = DateTime(referenceDate.year, referenceDate.month, referenceDate.day).subtract(Duration(days: referenceDate.weekday - 1));
    final days = List.generate(7, (i) => DateTime(start.year, start.month, start.day + i));

    final dayStats = days.map((d) {
      final daySessions = sessions.where((s) {
        final sd = s.completedAt;
        return sd.year == d.year && sd.month == d.month && sd.day == d.day;
      }).toList();
      final totalMinutes = daySessions.fold<int>(0, (p, s) => p + s.durationMinutes);
      return DayStats(date: d, hoursStudied: totalMinutes / 60.0, pomodorosCompleted: daySessions.fold<int>(0, (p, s) => p + s.cyclesCompleted));
    }).toList();

    final totalHours = dayStats.fold<double>(0.0, (p, d) => p + d.hoursStudied);
    // previous week calculation
    final prevStart = start.subtract(Duration(days: 7));
    final prevDays = List.generate(7, (i) => DateTime(prevStart.year, prevStart.month, prevStart.day + i));
    final prevTotalHours = prevDays.fold<double>(0.0, (p, d) {
      final daySessions = sessions.where((s) {
        final sd = s.completedAt;
        return sd.year == d.year && sd.month == d.month && sd.day == d.day;
      }).toList();
      final totalMinutes = daySessions.fold<int>(0, (pp, s) => pp + s.durationMinutes);
      return p + totalMinutes / 60.0;
    });

    final growth = prevTotalHours == 0 ? 100.0 : ((totalHours - prevTotalHours) / prevTotalHours) * 100.0;
    final totalPomodoros = dayStats.fold<int>(0, (p, d) => p + d.pomodorosCompleted);

    return WeeklyStatsEntity(
      days: dayStats,
      totalHours: totalHours,
      previousWeekHours: prevTotalHours,
      growthPercentage: growth,
      totalPomodoros: totalPomodoros,
    );
  }
}
