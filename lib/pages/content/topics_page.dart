import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:interactive_learn/core/models/chapter.dart';
import 'package:interactive_learn/core/models/subject.dart';
import 'package:interactive_learn/core/models/topic.dart';
import 'package:interactive_learn/core/providers/content_provider.dart';
import 'package:interactive_learn/pages/content/subtopics_page.dart';

class TopicsPage extends ConsumerWidget {
  final Subject subject;
  final Chapter chapter;
  const TopicsPage({super.key, required this.subject, required this.chapter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topicsAsync = ref.watch(topicProvider(chapter.id!));
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(chapter.name),
            Text(
              subject.name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
      body: topicsAsync.when(
        data: (topics) {
          if (topics.isEmpty) {
            return const Center(child: Text('No topics found.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: topics.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) => _TopicCard(
              subject: subject,
              chapter: chapter,
              topic: topics[index],
              index: index,
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final Subject subject;
  final Chapter chapter;
  final Topic topic;
  final int index;
  const _TopicCard({
    required this.subject,
    required this.chapter,
    required this.topic,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          topic.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SubtopicsPage(
              subject: subject,
              chapter: chapter,
              topic: topic,
            ),
          ),
        ),
      ),
    );
  }
}
