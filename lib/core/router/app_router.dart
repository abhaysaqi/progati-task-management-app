import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/pages/add_task_page.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/settings_page.dart';
import '../../presentation/pages/task_detail_page.dart';
import '../../presentation/pages/about_page.dart';
import '../../presentation/pages/privacy_policy_page.dart';

class AppRoutes {
  static const home = '/';
  static const addTask = '/add';
  static const editTask = '/edit';
  static const taskDetail = '/task/:id';
  static const settings = '/settings';
  static const about = '/about';
  static const privacy = '/privacy';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      pageBuilder: (context, state) => _buildPage(
        state,
        const HomePage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.addTask,
      pageBuilder: (context, state) => _buildPage(
        state,
        const AddTaskPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.editTask,
      pageBuilder: (context, state) {
        final task = state.extra;
        return _buildPage(state, AddTaskPage(existingTask: task as dynamic));
      },
    ),
    GoRoute(
      path: AppRoutes.taskDetail,
      pageBuilder: (context, state) {
        final taskId = state.pathParameters['id']!;
        return _buildPage(state, TaskDetailPage(taskId: taskId));
      },
    ),
    GoRoute(
      path: AppRoutes.settings,
      pageBuilder: (context, state) => _buildPage(
        state,
        const SettingsPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.about,
      pageBuilder: (context, state) => _buildPage(
        state,
        const AboutPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.privacy,
      pageBuilder: (context, state) => _buildPage(
        state,
        const PrivacyPolicyPage(),
      ),
    ),
  ],
);

CustomTransitionPage _buildPage(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(begin: const Offset(0, 0.08), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeOut));
      return FadeTransition(
        opacity: animation.drive(CurveTween(curve: Curves.easeOut)),
        child: SlideTransition(
          position: animation.drive(tween),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 280),
  );
}
