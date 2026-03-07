import 'package:equatable/equatable.dart';

import '../../../domain/entities/task_entity.dart';
import 'task_event.dart';

abstract class TaskState extends Equatable {
  const TaskState();
  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {
  const TaskInitial();
}

class TaskLoading extends TaskState {
  const TaskLoading();
}

class TaskLoaded extends TaskState {
  final List<TaskEntity> allTasks;
  final List<TaskEntity> displayedTasks;
  final String searchQuery;
  final SortOption sortOption;

  const TaskLoaded({
    required this.allTasks,
    required this.displayedTasks,
    this.searchQuery = '',
    this.sortOption = SortOption.date,
  });

  TaskLoaded copyWith({
    List<TaskEntity>? allTasks,
    List<TaskEntity>? displayedTasks,
    String? searchQuery,
    SortOption? sortOption,
  }) {
    return TaskLoaded(
      allTasks: allTasks ?? this.allTasks,
      displayedTasks: displayedTasks ?? this.displayedTasks,
      searchQuery: searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
    );
  }

  int get completedCount => allTasks.where((t) => t.isCompleted).length;
  int get pendingCount => allTasks.where((t) => !t.isCompleted).length;

  @override
  List<Object?> get props => [allTasks, displayedTasks, searchQuery, sortOption];
}

class TaskError extends TaskState {
  final String message;
  const TaskError(this.message);
  @override
  List<Object?> get props => [message];
}
