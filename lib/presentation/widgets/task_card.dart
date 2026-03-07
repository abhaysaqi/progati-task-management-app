import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/task_entity.dart';
import '../../core/theme/app_theme.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
  });

  Color _priorityColor() {
    switch (task.priority) {
      case Priority.high:
        return AppColors.priorityHigh;
      case Priority.medium:
        return AppColors.priorityMedium;
      case Priority.low:
        return AppColors.priorityLow;
    }
  }

  String _priorityLabel() {
    switch (task.priority) {
      case Priority.high:
        return 'High';
      case Priority.medium:
        return 'Medium';
      case Priority.low:
        return 'Low';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final priorityColor = _priorityColor();

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDelete();
        return false;
      },
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.priorityHigh,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_rounded, color: Colors.white, size: 28),
            SizedBox(height: 4),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: task.isCompleted
                  ? Colors.transparent
                  : priorityColor.withOpacity(0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: priorityColor.withOpacity(isDark ? 0.08 : 0.12),
                blurRadius: 16,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: (isDark ? Colors.black : Colors.white).withOpacity(0.7),
                blurRadius: 1,
                offset: const Offset(0, -1),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Priority bar
                Container(
                  width: 4,
                  height: 56,
                  decoration: BoxDecoration(
                    color: task.isCompleted
                        ? Colors.grey.withOpacity(0.3)
                        : priorityColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 14),
                // Checkbox
                GestureDetector(
                  onTap: onToggle,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 26,
                    height: 26,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color:
                          task.isCompleted ? priorityColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: task.isCompleted
                            ? priorityColor
                            : priorityColor.withOpacity(0.6),
                        width: 2,
                      ),
                      boxShadow: task.isCompleted
                          ? [
                              BoxShadow(
                                color: priorityColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: task.isCompleted
                        ? const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 16,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 14),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.isCompleted
                                    ? theme.textTheme.bodyMedium?.color
                                    : null,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Priority badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: priorityColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              _priorityLabel(),
                              style: TextStyle(
                                color: priorityColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (task.dueDate != null) ...[
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 12,
                              color: _isOverdue()
                                  ? AppColors.priorityHigh
                                  : theme.textTheme.bodyMedium?.color,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('MMM d').format(task.dueDate!),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 12,
                                color: _isOverdue()
                                    ? AppColors.priorityHigh
                                    : null,
                                fontWeight:
                                    _isOverdue() ? FontWeight.w600 : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          if (task.reminderTime != null) ...[
                            Icon(
                              Icons.notifications_rounded,
                              size: 12,
                              color: AppColors.primary.withOpacity(0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('h:mm a').format(task.reminderTime!),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isOverdue() {
    if (task.dueDate == null || task.isCompleted) return false;
    return task.dueDate!.isBefore(DateTime.now());
  }
}
