import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/task_entity.dart';
import '../../../domain/usecases/add_task_usecase.dart';
import '../../../domain/usecases/delete_task_usecase.dart';
import '../../../domain/usecases/get_tasks_usecase.dart';
import '../../../domain/usecases/search_tasks_usecase.dart';
import '../../../domain/usecases/toggle_task_usecase.dart';
import '../../../domain/usecases/update_task_usecase.dart';
import '../../../domain/usecases/clear_all_tasks_usecase.dart';
import '../../core/services/notification_service.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasksUseCase getTasksUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final ToggleTaskUseCase toggleTaskUseCase;
  final ClearAllTasksUseCase clearAllTasksUseCase;
  final SearchTasksUseCase searchTasksUseCase;
  final NotificationService notificationService;

  TaskBloc({
    required this.getTasksUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
    required this.toggleTaskUseCase,
    required this.clearAllTasksUseCase,
    required this.searchTasksUseCase,
    required this.notificationService,
  }) : super(const TaskInitial()) {
    on<LoadTasksEvent>(_onLoad);
    on<AddTaskEvent>(_onAdd);
    on<UpdateTaskEvent>(_onUpdate);
    on<DeleteTaskEvent>(_onDelete);
    on<ToggleTaskEvent>(_onToggle);
    on<ClearAllTasksEvent>(_onClearAll);
    on<SearchTasksEvent>(_onSearch);
    on<SortTasksEvent>(_onSort);
  }

  Future<void> _onLoad(LoadTasksEvent event, Emitter<TaskState> emit) async {
    emit(const TaskLoading());
    try {
      final tasks = await getTasksUseCase();
      final sorted = _sort(tasks, SortOption.date);
      emit(TaskLoaded(allTasks: sorted, displayedTasks: sorted));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onAdd(AddTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await addTaskUseCase(event.task);
      if (event.task.reminderTime != null) {
        await notificationService.scheduleReminder(event.task);
      }
      add(const LoadTasksEvent());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onUpdate(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await updateTaskUseCase(event.task);
      await notificationService.cancelReminder(event.task.id);
      if (event.task.reminderTime != null) {
        await notificationService.scheduleReminder(event.task);
      }
      add(const LoadTasksEvent());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDelete(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await deleteTaskUseCase(event.id);
      await notificationService.cancelReminder(event.id);
      add(const LoadTasksEvent());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onToggle(ToggleTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await toggleTaskUseCase(event.task);
      add(const LoadTasksEvent());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onClearAll(ClearAllTasksEvent event, Emitter<TaskState> emit) async {
    try {
      await clearAllTasksUseCase();
      await notificationService.cancelAll();
      add(const LoadTasksEvent());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  void _onSearch(SearchTasksEvent event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      final current = state as TaskLoaded;
      final searched = searchTasksUseCase(current.allTasks, event.query);
      final sorted = _sort(searched, current.sortOption);
      emit(current.copyWith(
        displayedTasks: sorted,
        searchQuery: event.query,
      ));
    }
  }

  void _onSort(SortTasksEvent event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      final current = state as TaskLoaded;
      final searched =
          searchTasksUseCase(current.allTasks, current.searchQuery);
      final sorted = _sort(searched, event.sortOption);
      emit(current.copyWith(
        displayedTasks: sorted,
        sortOption: event.sortOption,
      ));
    }
  }

  List<TaskEntity> _sort(List<TaskEntity> tasks, SortOption option) {
    final list = List<TaskEntity>.from(tasks);
    switch (option) {
      case SortOption.date:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.priority:
        list.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case SortOption.alphabetical:
        list.sort((a, b) => a.title.compareTo(b.title));
        break;
    }
    return list;
  }
}
