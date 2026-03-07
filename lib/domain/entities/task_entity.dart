import 'package:equatable/equatable.dart';

enum Priority { low, medium, high }

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime? dueDate;
  final Priority priority;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? reminderTime;

  const TaskEntity({
    required this.id,
    required this.title,
    this.description = '',
    this.dueDate,
    this.priority = Priority.medium,
    this.isCompleted = false,
    required this.createdAt,
    this.reminderTime,
  });

  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    Priority? priority,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? reminderTime,
    bool clearDueDate = false,
    bool clearReminderTime = false,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      reminderTime:
          clearReminderTime ? null : (reminderTime ?? this.reminderTime),
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        dueDate,
        priority,
        isCompleted,
        createdAt,
        reminderTime,
      ];
}
