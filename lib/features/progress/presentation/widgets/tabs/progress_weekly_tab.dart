import 'package:flutter/material.dart';
import 'package:nexus/features/progress/data/models/weekly_subject_progress.dart';
import 'package:nexus/features/progress/presentation/widgets/charts/progress_chart_card.dart';
import 'package:nexus/features/progress/presentation/widgets/charts/progress_subject_bar_chart.dart';
import 'package:nexus/features/progress/presentation/widgets/charts/progress_subject_pie_chart.dart';
import 'package:nexus/features/progress/presentation/widgets/charts/progress_weekly_helpers.dart';
import 'package:nexus/features/progress/presentation/widgets/charts/progress_weekly_line_chart.dart';

class ProgressWeeklyTab extends StatelessWidget {
  final List<WeeklySubjectProgress> data;

  const ProgressWeeklyTab({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text(
          'No weekly progress yet. Start a lesson to see charts here.',
        ),
      );
    }

    final dailyTotals = _buildDailyTotals(data);
    final subjectTotals = _buildSubjectTotals(data);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        children: [
          ProgressChartCard(
            title: 'Weekly XP Trend',
            subtitle: 'All completed lessons in the last 7 days',
            child: SizedBox(
              height: 220,
              child: ProgressWeeklyLineChart(points: dailyTotals),
            ),
          ),
          const SizedBox(height: 14),
          ProgressChartCard(
            title: 'Subject-wise XP Split',
            subtitle: 'Where your learning energy went this week',
            child: SizedBox(
              height: 230,
              child: ProgressSubjectPieChart(subjectTotals: subjectTotals),
            ),
          ),
          const SizedBox(height: 14),
          ProgressChartCard(
            title: 'Daily Subject Volume',
            subtitle: 'Which subject got the most action each day',
            child: SizedBox(
              height: 260,
              child: ProgressSubjectBarChart(data: data),
            ),
          ),
        ],
      ),
    );
  }
    List<DayPoint> _buildDailyTotals(List<WeeklySubjectProgress> source) {
    final today = DateTime.now();
    final start = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(const Duration(days: 6));
    final days = List.generate(
      7,
      (index) => DateTime(
        start.year,
        start.month,
        start.day,
      ).add(Duration(days: index)),
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

    return days
        .map((day) => DayPoint(day: day, xp: totals[day] ?? 0))
        .toList();
  }

  Map<String, int> _buildSubjectTotals(List<WeeklySubjectProgress> source) {
    final totals = <String, int>{};
    for (final row in source) {
      totals[row.subjectName] = (totals[row.subjectName] ?? 0) + row.xpEarned;
    }
    return totals;
  }

}