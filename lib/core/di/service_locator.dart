import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:progati/data/datasources/task_local_datasource.dart';
import 'package:progati/data/models/task_model.dart';
import 'package:progati/data/repositories/task_repository_impl.dart';
import 'package:progati/domain/repositories/task_repository.dart';
import 'package:progati/domain/usecases/add_task_usecase.dart';
import 'package:progati/domain/usecases/delete_task_usecase.dart';
import 'package:progati/domain/usecases/get_tasks_usecase.dart';
import 'package:progati/domain/usecases/search_tasks_usecase.dart';
import 'package:progati/domain/usecases/toggle_task_usecase.dart';
import 'package:progati/domain/usecases/update_task_usecase.dart';
import 'package:progati/domain/usecases/clear_all_tasks_usecase.dart';
import 'package:progati/presentation/blocs/settings/settings_bloc.dart';
import 'package:progati/presentation/blocs/task/task_bloc.dart';
import 'package:progati/presentation/core/services/notification_service.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ─── Hive Box ───────────────────────────────────────────────
  final box = await Hive.openBox<TaskModel>('tasks');
  sl.registerSingleton<Box<TaskModel>>(box);

  // ─── Services ───────────────────────────────────────────────
  final notificationService = NotificationService();
  await notificationService.initialize();
  sl.registerSingleton<NotificationService>(notificationService);

  // ─── Data Sources ───────────────────────────────────────────
  sl.registerSingleton<TaskLocalDataSource>(
    TaskLocalDataSourceImpl(sl<Box<TaskModel>>()),
  );

  // ─── Repositories ───────────────────────────────────────────
  sl.registerSingleton<TaskRepository>(
    TaskRepositoryImpl(sl<TaskLocalDataSource>()),
  );

  // ─── Use Cases ──────────────────────────────────────────────
  sl.registerSingleton(GetTasksUseCase(sl<TaskRepository>()));
  sl.registerSingleton(AddTaskUseCase(sl<TaskRepository>()));
  sl.registerSingleton(UpdateTaskUseCase(sl<TaskRepository>()));
  sl.registerSingleton(DeleteTaskUseCase(sl<TaskRepository>()));
  sl.registerSingleton(ToggleTaskUseCase(sl<TaskRepository>()));
  sl.registerSingleton(ClearAllTasksUseCase(sl<TaskRepository>()));
  sl.registerSingleton(SearchTasksUseCase());

  // ─── BLoCs ──────────────────────────────────────────────────
  sl.registerFactory<TaskBloc>(() => TaskBloc(
        getTasksUseCase: sl(),
        addTaskUseCase: sl(),
        updateTaskUseCase: sl(),
        deleteTaskUseCase: sl(),
        toggleTaskUseCase: sl(),
        clearAllTasksUseCase: sl(),
        searchTasksUseCase: sl(),
        notificationService: sl(),
      ));
  sl.registerSingleton<SettingsBloc>(SettingsBloc());
}
