import 'package:nexus/features/progress/data/models/weekly_subject_progress.dart';

class DayPoint {
  final DateTime day;
  final int xp;

  const DayPoint({required this.day, required this.xp});
}

List<DayPoint> buildDailyTotals(List<WeeklySubjectProgress> source) {
  final today = DateTime.now();
  final start = DateTime(
    today.year,
    today.month,
    today.day,
  ).subtract(const Duration(days: 6));
  final days = List.generate(
    7,
    (index) =>
        DateTime(start.year, start.month, start.day).add(Duration(days: index)),
  );
  final totals = <DateTime, int>{for (final day in days) day: 0};

  for (final row in source) {
    final day = DateTime(
      row.dayBucket.year,
      row.dayBucket.month,
      row.dayBucket.day,
    );
    totals[day] = (totals[day] ?? 0) + row.xpEarned;
  }

  return days.map((day) => DayPoint(day: day, xp: totals[day] ?? 0)).toList();
}

Map<String, int> buildSubjectTotals(List<WeeklySubjectProgress> source) {
  final totals = <String, int>{};
  for (final row in source) {
    totals[row.subjectName] = (totals[row.subjectName] ?? 0) + row.xpEarned;
  }
  return totals;
}
