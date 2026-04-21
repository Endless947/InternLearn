import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:interactive_learn/core/landing/screens/tab_widget_tree.dart';
import 'package:interactive_learn/features/auth/presentation/screens/login_screen.dart';
import 'package:interactive_learn/features/auth/presentation/screens/signup_screen.dart';
import 'package:interactive_learn/features/content/data/models/chapter.dart';
import 'package:interactive_learn/features/content/data/models/subject.dart';
import 'package:interactive_learn/features/content/data/models/topic.dart';
import 'package:interactive_learn/features/content/presentation/screens/chapters_screen.dart';
import 'package:interactive_learn/features/content/presentation/screens/subjects_screen.dart';
import 'package:interactive_learn/features/content/presentation/screens/subtopics_screen.dart';
import 'package:interactive_learn/features/content/presentation/screens/topics_screen.dart';
import 'package:interactive_learn/features/content/presentation/slides/slide_viewer_screen.dart';
import 'package:interactive_learn/features/profile/presentation/screens/avatar_picker_screen.dart';
import 'package:interactive_learn/features/profile/presentation/screens/edit_profile_screen.dart';

part 'app_routes.g.dart';

class TopicsNavData {
  const TopicsNavData({required this.subject, required this.chapter});

  final Subject subject;
  final Chapter chapter;
}

class SubtopicsNavData {
  const SubtopicsNavData({
    required this.subject,
    required this.chapter,
    required this.topic,
  });

  final Subject subject;
  final Chapter chapter;
  final Topic topic;
}

@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TabWidgetTree();
  }
}

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginScreen();
  }
}

@TypedGoRoute<SignupRoute>(path: '/signup')
class SignupRoute extends GoRouteData with $SignupRoute {
  const SignupRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SignupScreen();
  }
}

@TypedGoRoute<SubjectsRoute>(path: '/subjects')
class SubjectsRoute extends GoRouteData with $SubjectsRoute {
  const SubjectsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SubjectsScreen();
  }
}

@TypedGoRoute<ChaptersRoute>(path: '/chapters')
class ChaptersRoute extends GoRouteData with $ChaptersRoute {
  const ChaptersRoute({required this.$extra});

  final Subject $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ChaptersPage(subject: $extra);
  }
}

@TypedGoRoute<TopicsRoute>(path: '/topics')
class TopicsRoute extends GoRouteData with $TopicsRoute {
  const TopicsRoute({required this.$extra});

  final TopicsNavData $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return TopicsScreen(subject: $extra.subject, chapter: $extra.chapter);
  }
}

@TypedGoRoute<SubtopicsRoute>(path: '/subtopics')
class SubtopicsRoute extends GoRouteData with $SubtopicsRoute {
  const SubtopicsRoute({required this.$extra});

  final SubtopicsNavData $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SubtopicsScreen(
      subject: $extra.subject,
      chapter: $extra.chapter,
      topic: $extra.topic,
    );
  }
}

@TypedGoRoute<SlideViewerRoute>(path: '/slides/:subtopicId')
class SlideViewerRoute extends GoRouteData with $SlideViewerRoute {
  const SlideViewerRoute({
    required this.subtopicId,
    required this.subtopicTitle,
  });

  final int subtopicId;
  final String subtopicTitle;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SlideViewerScreen(
      subtopicId: subtopicId,
      subtopicTitle: subtopicTitle,
    );
  }
}

@TypedGoRoute<EditProfileRoute>(path: '/profile/edit')
class EditProfileRoute extends GoRouteData with $EditProfileRoute {
  const EditProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const EditProfileScreen();
  }
}

@TypedGoRoute<AvatarPickerRoute>(path: '/profile/avatar')
class AvatarPickerRoute extends GoRouteData with $AvatarPickerRoute {
  const AvatarPickerRoute({required this.currentSeed});

  final String currentSeed;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return AvatarPickerScreen(currentSeed: currentSeed);
  }
}
