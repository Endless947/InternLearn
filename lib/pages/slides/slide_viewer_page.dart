import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:interactive_learn/core/models/slide.dart';
import 'package:interactive_learn/core/models/slide_match.dart' as model;
import 'package:interactive_learn/core/models/slide_mcq.dart';
import 'package:interactive_learn/core/providers/slide_provider.dart';
import 'package:interactive_learn/pages/slides/widgets/content_slide.dart';
import 'package:interactive_learn/pages/slides/widgets/match_slide.dart';
import 'package:interactive_learn/pages/slides/widgets/mcq_slide.dart';

// ── Sealed union: one entry per slide item sorted by order ───────────────────

sealed class _SlideEntry {
  int get order;
}

final class _ContentEntry extends _SlideEntry {
  final Slide slide;
  _ContentEntry(this.slide);
  @override
  int get order => slide.order;
}

final class _McqEntry extends _SlideEntry {
  final SlideMcq mcq;
  _McqEntry(this.mcq);
  @override
  int get order => mcq.order;
}

final class _MatchEntry extends _SlideEntry {
  final model.SlideMatch match;
  _MatchEntry(this.match);
  @override
  int get order => match.order;
}

// ── Public page ───────────────────────────────────────────────────────────────

class SlideViewerPage extends HookConsumerWidget {
  final int subtopicId;
  final String subtopicTitle;

  const SlideViewerPage({
    super.key,
    required this.subtopicId,
    required this.subtopicTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slidesAsync = ref.watch(slidesProvider(subtopicId));

    return slidesAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: Text(subtopicTitle)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: Text(subtopicTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 12),
                Text('Failed to load slides', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(e.toString(), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
      data: (data) => _SlideViewerBody(data: data, title: subtopicTitle),
    );
  }
}

// ── Viewer body (all state lives here) ───────────────────────────────────────

class _SlideViewerBody extends HookWidget {
  final SlidesForSubtopic data;
  final String title;

  const _SlideViewerBody({required this.data, required this.title});

  List<_SlideEntry> _buildEntries() {
    return <_SlideEntry>[
      ...data.slides.map(_ContentEntry.new),
      ...data.mcqSlides.map(_McqEntry.new),
      ...data.matchSlides.map(_MatchEntry.new),
    ]..sort((a, b) => a.order.compareTo(b.order));
  }

  @override
  Widget build(BuildContext context) {
    final entries = useMemoized(_buildEntries, const []);
    final pageController = usePageController();
    final pageIndex = useState(0);
    // Tracks which indices have been completed (MCQ answered, Match finished)
    final completedSet = useState(<int>{});

    if (entries.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.hourglass_empty, size: 64, color: Colors.grey),
              SizedBox(height: 12),
              Text('No slides available for this subtopic yet.'),
            ],
          ),
        ),
      );
    }

    // Content slides are always unlocked; interactive slides need completion
    bool canProceed(int i) {
      if (i >= entries.length) return false;
      if (entries[i] is _ContentEntry) return true;
      return completedSet.value.contains(i);
    }

    void goTo(int newIndex) {
      pageIndex.value = newIndex;
      pageController.animateToPage(
        newIndex,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
      );
    }

    void markComplete(int i) {
      completedSet.value = {...completedSet.value, i};
    }

    final isLast = pageIndex.value == entries.length - 1;

    Future<bool> confirmQuit() async {
      return await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Leave lesson?'),
              content: const Text('Your progress on this lesson will not be saved.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Stay'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(
                    'Leave',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ],
            ),
          ) ??
          false;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final leave = await confirmQuit();
        if (leave && context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              final leave = await confirmQuit();
              if (leave && context.mounted) Navigator.pop(context);
            },
          ),
          title: Text(title),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(10),
            child: _SegmentedProgress(
              total: entries.length,
              current: pageIndex.value,
              completed: completedSet.value,
            ),
          ),
        ),
        body: PageView.builder(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: entries.length,
          itemBuilder: (context, i) {
            final entry = entries[i];
            if (entry is _ContentEntry) {
              return ContentSlideWidget(key: ValueKey('c_$i'), slide: entry.slide);
            } else if (entry is _McqEntry) {
              return McqSlideWidget(
                key: ValueKey('mcq_$i'),
                mcq: entry.mcq,
                onCompleted: () => markComplete(i),
              );
            } else if (entry is _MatchEntry) {
              return MatchSlideWidget(
                key: ValueKey('match_$i'),
                match: entry.match,
                onCompleted: () => markComplete(i),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                // Back button
                if (pageIndex.value > 0)
                  OutlinedButton.icon(
                    onPressed: () => goTo(pageIndex.value - 1),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text('Back'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  )
                else
                  const SizedBox(width: 80),

                const Spacer(),

                // Slide counter
                Text(
                  '${pageIndex.value + 1} / ${entries.length}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),

                const Spacer(),

                // Next / Finish button
                ElevatedButton.icon(
                  onPressed: canProceed(pageIndex.value)
                      ? () {
                          if (isLast) {
                            _showCompletionDialog(context);
                          } else {
                            goTo(pageIndex.value + 1);
                          }
                        }
                      : null,
                  icon: Icon(isLast ? Icons.emoji_events : Icons.arrow_forward, size: 18),
                  label: Text(isLast ? 'Finish' : 'Next'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.emoji_events, color: Colors.amber, size: 48),
        title: const Text('Lesson Complete! 🎉'),
        content: Text(
          'You\'ve finished "$title". Keep up the great work!',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);            // close dialog
              Navigator.pop(context);        // go back to subtopics
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}

// ── Segmented progress bar ────────────────────────────────────────────────────

class _SegmentedProgress extends StatelessWidget {
  final int total;
  final int current;
  final Set<int> completed;

  const _SegmentedProgress({
    required this.total,
    required this.current,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      child: Row(
        children: List.generate(total, (i) {
          final isDone = completed.contains(i) || i < current;
          final isCurrent = i == current;
          final color = isDone
              ? Colors.white
              : isCurrent
                  ? Colors.white.withValues(alpha: 0.55)
                  : Colors.white.withValues(alpha: 0.25);

          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 5,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          );
        }),
      ),
    );
  }
}
