import 'package:interactive_learn/features/content/data/models/chapter.dart';
import 'package:interactive_learn/features/content/data/models/subject.dart';
import 'package:interactive_learn/features/content/data/models/subtopic.dart';
import 'package:interactive_learn/features/content/data/models/topic.dart';
import 'package:interactive_learn/features/content/services/chapter_service.dart';
import 'package:interactive_learn/features/content/services/subject_service.dart';
import 'package:interactive_learn/features/content/services/subtopic_service.dart';
import 'package:interactive_learn/features/content/services/topic_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'content_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<List<Subject>> subject(Ref ref) {
  return SubjectService.fetchSubjects();
}

@Riverpod(keepAlive: true)
FutureOr<List<Chapter>> chapter(Ref ref, int subjectId) {
  return ChapterService.fetchChapters(subjectId);
}

@Riverpod(keepAlive: true)
FutureOr<List<Topic>> topic(Ref ref, int chapterId) {
  return TopicService.fetchTopics(chapterId);
}

@Riverpod(keepAlive: true)
FutureOr<List<Subtopic>> subtopic(Ref ref, int topicId) {
  return SubtopicService.fetchSubtopics(topicId);
}
