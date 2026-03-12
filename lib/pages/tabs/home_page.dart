import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:interactive_learn/core/models/subject.dart';
import 'package:interactive_learn/core/providers/auth_provider.dart';
import 'package:interactive_learn/core/providers/content_provider.dart';
import 'package:interactive_learn/pages/content/chapters_page.dart';
import 'package:interactive_learn/pages/content/subjects_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final subjectsAsync = ref.watch(subjectProvider);
    final displayName = user?.email?.split('@').first ?? 'Learner';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Greeting ──────────────────────────────────────────────
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  displayName[0].toUpperCase(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, $displayName!',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Keep learning, keep growing.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Subjects header ───────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subjects',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SubjectsPage()),
                ),
                child: const Text('See All'),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ── Subjects grid ─────────────────────────────────────────
          subjectsAsync.when(
            data: (subjects) => subjects.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: Text('No subjects available yet.')),
                  )
                : _SubjectGrid(subjects: subjects),
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text('Failed to load subjects: $e',
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectGrid extends StatelessWidget {
  final List<Subject> subjects;
  const _SubjectGrid({required this.subjects});

  static const List<Color> _palette = [
    Color(0xFF1565C0), // deep blue
    Color(0xFF2E7D32), // deep green
    Color(0xFFE65100), // deep orange
    Color(0xFF6A1B9A), // deep purple
    Color(0xFF00695C), // teal
    Color(0xFFC62828), // deep red
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];
        final color = _palette[index % _palette.length];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ChaptersPage(subject: subject)),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: color.withValues(alpha: 0.2),
                  child: Text(
                    subject.name[0].toUpperCase(),
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                Text(
                  subject.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subject.description != null)
                  Text(
                    subject.description!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}


