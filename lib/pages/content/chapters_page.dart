import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:interactive_learn/core/models/chapter.dart';
import 'package:interactive_learn/core/models/subject.dart';
import 'package:interactive_learn/core/providers/content_provider.dart';
import 'package:interactive_learn/pages/content/topics_page.dart';

class ChaptersPage extends ConsumerWidget {
  final Subject subject;
  const ChaptersPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chaptersAsync = ref.watch(chapterProvider(subject.id));
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subject.name),
            Text(
              'Chapters',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
      body: chaptersAsync.when(
        data: (chapters) {
          if (chapters.isEmpty) {
            return const Center(child: Text('No chapters found.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: chapters.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) => _ChapterCard(
              subject: subject,
              chapter: chapters[index],
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

class _ChapterCard extends StatelessWidget {
  final Subject subject;
  final Chapter chapter;
  final int index;
  const _ChapterCard({
    required this.subject,
    required this.chapter,
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
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            chapter.chapterNumber,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        title: Text(
          chapter.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('Chapter ${chapter.chapterNumber}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TopicsPage(subject: subject, chapter: chapter),
          ),
        ),
      ),
    );
  }
}
