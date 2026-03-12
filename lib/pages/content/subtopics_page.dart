import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:interactive_learn/core/models/chapter.dart';
import 'package:interactive_learn/core/models/subject.dart';
import 'package:interactive_learn/core/models/subtopic.dart';
import 'package:interactive_learn/core/models/topic.dart';
import 'package:interactive_learn/core/providers/content_provider.dart';
import 'package:interactive_learn/pages/slides/slide_viewer_page.dart';

class SubtopicsPage extends ConsumerWidget {
  final Subject subject;
  final Chapter chapter;
  final Topic topic;
  const SubtopicsPage({
    super.key,
    required this.subject,
    required this.chapter,
    required this.topic,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtopicsAsync = ref.watch(subtopicProvider(topic.id));
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(topic.title),
            Text(
              '${subject.name} › ${chapter.name}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
      body: subtopicsAsync.when(
        data: (subtopics) {
          if (subtopics.isEmpty) {
            return const Center(child: Text('No subtopics found.'));
          }
          // Sort by order if available
          final sorted = [...subtopics]
            ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sorted.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) =>
                _SubtopicCard(subtopic: sorted[index], index: index),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _SubtopicCard extends StatelessWidget {
  final Subtopic subtopic;
  final int index;
  const _SubtopicCard({required this.subtopic, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onTertiaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          subtopic.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.play_circle_outline,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                'Start',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SlideViewerPage(
                subtopicId: subtopic.id,
                subtopicTitle: subtopic.title,
              ),
            ),
          );
        },
      ),
    );
  }
}
