import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:interactive_learn/core/models/subject.dart';
import 'package:interactive_learn/core/providers/content_provider.dart';
import 'package:interactive_learn/pages/content/chapters_page.dart';

class SubjectsPage extends ConsumerWidget {
  const SubjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsAsync = ref.watch(subjectProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('All Subjects')),
      body: subjectsAsync.when(
        data: (subjects) {
          if (subjects.isEmpty) {
            return const Center(child: Text('No subjects found.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: subjects.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) =>
                _SubjectCard(subject: subjects[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final Subject subject;
  const _SubjectCard({required this.subject});

  static const List<Color> _palette = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.deepOrange,
  ];

  @override
  Widget build(BuildContext context) {
    final color = _palette[subject.id % _palette.length];
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Text(
            subject.name[0].toUpperCase(),
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          subject.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: subject.description != null
            ? Text(subject.description!, maxLines: 2, overflow: TextOverflow.ellipsis)
            : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ChaptersPage(subject: subject)),
        ),
      ),
    );
  }
}
