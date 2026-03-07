import 'package:equatable/equatable.dart';

import '../../../domain/entities/task_entity.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();
  @override
  List<Object?> get props => [];
}

class LoadTasksEvent extends TaskEvent {
  const LoadTasksEvent();
}

class AddTaskEvent extends TaskEvent {
  final TaskEntity task;
  const AddTaskEvent(this.task);
  @override
  List<Object?> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final TaskEntity task;
  const UpdateTaskEvent(this.task);
  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  final String id;
  const DeleteTaskEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class ToggleTaskEvent extends TaskEvent {
  final TaskEntity task;
  const ToggleTaskEvent(this.task);
  @override
  List<Object?> get props => [task];
}

class SearchTasksEvent extends TaskEvent {
  final String query;
  const SearchTasksEvent(this.query);
  @override
  List<Object?> get props => [query];
}

enum SortOption { date, priority, alphabetical }

class SortTasksEvent extends TaskEvent {
  final SortOption sortOption;
  const SortTasksEvent(this.sortOption);
  @override
  List<Object?> get props => [sortOption];
}

class ClearAllTasksEvent extends TaskEvent {
  const ClearAllTasksEvent();
  @override
  List<Object?> get props => [];
}
