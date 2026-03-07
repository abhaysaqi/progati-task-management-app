import 'package:hive/hive.dart';

import '../../domain/entities/task_entity.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime? dueDate;

  @HiveField(4)
  final int priorityIndex;

  @HiveField(5)
  final bool isCompleted;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime? reminderTime;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    this.dueDate,
    required this.priorityIndex,
    required this.isCompleted,
    required this.createdAt,
    this.reminderTime,
  });

  factory TaskModel.fromEntity(TaskEntity entity) => TaskModel(
        id: entity.id,
        title: entity.title,
        description: entity.description,
        dueDate: entity.dueDate,
        priorityIndex: entity.priority.index,
        isCompleted: entity.isCompleted,
        createdAt: entity.createdAt,
        reminderTime: entity.reminderTime,
      );

  TaskEntity toEntity() => TaskEntity(
        id: id,
        title: title,
        description: description,
        dueDate: dueDate,
        priority: Priority.values[priorityIndex],
        isCompleted: isCompleted,
        createdAt: createdAt,
        reminderTime: reminderTime,
      );
}
