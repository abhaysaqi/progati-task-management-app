import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/task_entity.dart';
import '../blocs/task/task_bloc.dart';
import '../blocs/task/task_event.dart';
import '../blocs/task/task_state.dart';

class TaskDetailPage extends StatelessWidget {
  final String taskId;

  const TaskDetailPage({super.key, required this.taskId});

  Color _priorityColor(Priority p) {
    switch (p) {
      case Priority.high:
        return AppColors.priorityHigh;
      case Priority.medium:
        return AppColors.priorityMedium;
      case Priority.low:
        return AppColors.priorityLow;
    }
  }

  void _showDeleteConfirmation(BuildContext context, TaskEntity task) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Delete Task?'),
        content: Text(
            'Are you sure you want to delete "${task.title}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.priorityHigh),
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
              context.go(AppRoutes.home);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is! TaskLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final task = state.allTasks.where((t) => t.id == taskId).firstOrNull;
        if (task == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Task not found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go(AppRoutes.home),
                    child: const Text('Go Home'),
                  ),
                ],
              ),
            ),
          );
        }

        final pColor = _priorityColor(task.priority);

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkCard
                                : AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              size: 18, color: AppColors.primary),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () =>
                            context.push(AppRoutes.editTask, extra: task),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.edit_rounded,
                              size: 20, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => _showDeleteConfirmation(context, task),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.priorityHigh.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.delete_rounded,
                              size: 20, color: AppColors.priorityHigh),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.2),
                  const SizedBox(height: 32),
                  // Task card hero area
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          pColor.withOpacity(isDark ? 0.25 : 0.15),
                          pColor.withOpacity(isDark ? 0.1 : 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: pColor.withOpacity(0.25),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: pColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                task.priority.name.toUpperCase(),
                                style: TextStyle(
                                  color: pColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => context
                                  .read<TaskBloc>()
                                  .add(ToggleTaskEvent(task)),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: task.isCompleted
                                      ? AppColors.accentGreen.withOpacity(0.15)
                                      : Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: task.isCompleted
                                        ? AppColors.accentGreen
                                        : Colors.white.withOpacity(0.5),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      task.isCompleted
                                          ? Icons.check_circle_rounded
                                          : Icons
                                              .radio_button_unchecked_rounded,
                                      size: 16,
                                      color: task.isCompleted
                                          ? AppColors.accentGreen
                                          : pColor,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      task.isCompleted ? 'Complete' : 'Pending',
                                      style: TextStyle(
                                        color: task.isCompleted
                                            ? AppColors.accentGreen
                                            : pColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          task.title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.isCompleted
                                ? theme.textTheme.bodyMedium?.color
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
                  const SizedBox(height: 24),
                  if (task.description.isNotEmpty) ...[
                    _DetailSection(
                      title: 'Description',
                      icon: Icons.notes_rounded,
                      child: Text(
                        task.description,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  _DetailSection(
                    title: 'Details',
                    icon: Icons.info_outline_rounded,
                    child: Column(
                      children: [
                        _InfoRow(
                          label: 'Created',
                          value: DateFormat('EEE, MMM d yyyy • h:mm a')
                              .format(task.createdAt),
                        ),
                        if (task.dueDate != null) ...[
                          const Divider(height: 20),
                          _InfoRow(
                            label: 'Due Date',
                            value: DateFormat('EEE, MMM d yyyy')
                                .format(task.dueDate!),
                            valueColor:
                                task.dueDate!.isBefore(DateTime.now()) &&
                                        !task.isCompleted
                                    ? AppColors.priorityHigh
                                    : null,
                          ),
                        ],
                        if (task.reminderTime != null) ...[
                          const Divider(height: 20),
                          _InfoRow(
                            label: 'Reminder',
                            value: DateFormat('EEE, MMM d • h:mm a')
                                .format(task.reminderTime!),
                            valueColor: AppColors.primary,
                          ),
                        ],
                      ],
                    ),
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          context.read<TaskBloc>().add(ToggleTaskEvent(task)),
                      icon: Icon(
                        task.isCompleted
                            ? Icons.replay_rounded
                            : Icons.check_circle_rounded,
                      ),
                      label: Text(
                        task.isCompleted
                            ? 'Mark as Pending'
                            : 'Mark as Complete',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: task.isCompleted
                            ? AppColors.accentOrange
                            : AppColors.accentGreen,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms)
                      .slideY(begin: 0.3, curve: Curves.elasticOut),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _DetailSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500)),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
        ),
      ],
    );
  }
}
