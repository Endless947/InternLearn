import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexus/features/progress/data/models/weekly_subject_progress.dart';

class ProgressSubjectBarChart extends StatelessWidget {
  final List<WeeklySubjectProgress> data;

  const ProgressSubjectBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final subjectNames = data.map((e) => e.subjectName).toSet().toList();
    final dayMap = <DateTime, Map<String, int>>{};

    for (final row in data) {
      final day = DateTime(
        row.dayBucket.year,
        row.dayBucket.month,
        row.dayBucket.day,
      );
      dayMap.putIfAbsent(day, () => {});
      dayMap[day]![row.subjectName] =
          (dayMap[day]![row.subjectName] ?? 0) + row.xpEarned;
    }

    final days = dayMap.keys.toList()..sort();
    final palette = [
      Colors.indigo,
      Colors.teal,
      Colors.deepOrange,
      Colors.purple,
    ];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        groupsSpace: 12,
        barTouchData: BarTouchData(enabled: true),
        gridData: FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 34,
              interval: 50,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, _) {
                final index = value.toInt();
                if (index < 0 || index >= days.length) {
                  return const SizedBox.shrink();
                }
                return Text(
                  DateFormat('E').format(days[index]),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        barGroups: [
          for (var i = 0; i < days.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                for (var j = 0; j < math.min(subjectNames.length, 3); j++)
                  BarChartRodData(
                    toY: (dayMap[days[i]]?[subjectNames[j]] ?? 0).toDouble(),
                    color: palette[j % palette.length],
                    width: 10,
                    borderRadius: BorderRadius.circular(4),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
