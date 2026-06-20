import '../../../focus/data/models/focus_session_model.dart';

class StreakResult {
  final int currentStreak;
  final int longestStreak;

  const StreakResult({required this.currentStreak, required this.longestStreak});
}

class CalculateStreakUseCase {
  /// A day "counts" if at least one focus session was completed on it.
  StreakResult call(List<FocusSessionModel> sessions, DateTime referenceDate) {
    if (sessions.isEmpty) {
      return const StreakResult(currentStreak: 0, longestStreak: 0);
    }

    final studyDays = sessions
        .map((s) => DateTime(s.completedAt.year, s.completedAt.month, s.completedAt.day))
        .toSet()
        .toList()
      ..sort();

    // Longest streak: scan sorted unique days for consecutive runs.
    var longest = 1;
    var run = 1;
    for (var i = 1; i < studyDays.length; i++) {
      final diff = studyDays[i].difference(studyDays[i - 1]).inDays;
      if (diff == 1) {
        run += 1;
      } else if (diff > 1) {
        run = 1;
      }
      if (run > longest) longest = run;
    }

    // Current streak: consecutive days ending today or yesterday.
    final today = DateTime(referenceDate.year, referenceDate.month, referenceDate.day);
    final studySet = studyDays.toSet();
    var cursor = today;
    if (!studySet.contains(today)) {
      cursor = today.subtract(const Duration(days: 1));
      if (!studySet.contains(cursor)) {
        return StreakResult(currentStreak: 0, longestStreak: longest);
      }
    }

    var current = 0;
    while (studySet.contains(cursor)) {
      current += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return StreakResult(currentStreak: current, longestStreak: longest);
  }
}
