import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProgressSubjectPieChart extends StatelessWidget {
  final Map<String, int> subjectTotals;

  const ProgressSubjectPieChart({super.key, required this.subjectTotals});

  @override
  Widget build(BuildContext context) {
    final entries = subjectTotals.entries.toList();
    if (entries.isEmpty) {
      return const Center(child: Text('No subject data yet.'));
    }

    final colors = [
      Colors.indigo,
      Colors.teal,
      Colors.deepOrange,
      Colors.purple,
      Colors.green,
      Colors.amber,
    ];

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: [
                for (var i = 0; i < entries.length; i++)
                  PieChartSectionData(
                    value: entries[i].value.toDouble(),
                    color: colors[i % colors.length],
                    title: entries[i].value > 0 ? '${entries[i].value}' : '',
                    radius: 62,
                    titleStyle: const TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < entries.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: colors[i % colors.length],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          entries[i].key,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
