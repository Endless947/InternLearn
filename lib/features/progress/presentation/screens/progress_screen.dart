import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/core/widgets/list_skeleton.dart';
import 'package:nexus/features/progress/data/riverpod/progress_provider.dart';
import 'package:nexus/features/progress/presentation/widgets/progress_skeleton.dart';
import 'package:nexus/features/progress/presentation/widgets/tabs/progress_completed_lessons_tab.dart';
import 'package:nexus/features/progress/presentation/widgets/progress_header.dart';
import 'package:nexus/features/progress/presentation/widgets/progress_level_card.dart';
import 'package:nexus/features/progress/presentation/widgets/tabs/progress_overview_tab.dart';
import 'package:nexus/features/progress/presentation/widgets/progress_summary_row.dart';
import 'package:nexus/features/progress/presentation/widgets/tabs/progress_weekly_tab.dart';

class ProgressScreen extends HookConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(progressSummaryProvider);
    final weeklyAsync = ref.watch(weeklySubjectProgressProvider);
    final lessonsAsync = ref.watch(recentCompletedLessonsProvider);

    final selectedIndex = useState(0);

    return Scaffold(
      body: SafeArea(
        child: summaryAsync.when(
          loading: () => const ProgressSkeleton(),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (summary) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: SingleChildScrollView(
                child: Column(
                  spacing: 12,
                  children: [
                    ProgressHeader(totalXp: summary.totalXp),

                    ProgressSummaryRow(summary: summary),

                    ProgressLevelCard(totalXp: summary.totalXp),

                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<int>(
                        segments: const [
                          ButtonSegment(value: 0, label: Text('Overview')),
                          ButtonSegment(value: 1, label: Text('Weekly')),
                          ButtonSegment(value: 2, label: Text('Finished')),
                        ],
                        selected: {selectedIndex.value},
                        onSelectionChanged: (value) {
                          selectedIndex.value = value.first;
                        },
                        style: ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ),

                    Builder(
                      builder: (_) {
                        switch (selectedIndex.value) {
                          case 0:
                            return ProgressOverviewTab(summary: summary);

                          case 1:
                            return weeklyAsync.when(
                              loading: () => const ListSkeleton(),
                              error: (e, _) => Center(child: Text('Error: $e')),
                              data: (weeklyData) =>
                                  ProgressWeeklyTab(data: weeklyData),
                            );

                          case 2:
                            return lessonsAsync.when(
                              loading: () => const ListSkeleton(),
                              error: (e, _) => Center(child: Text('Error: $e')),
                              data: (lessons) =>
                                  ProgressCompletedLessonsTab(lessons: lessons),
                            );

                          default:
                            return const SizedBox();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
