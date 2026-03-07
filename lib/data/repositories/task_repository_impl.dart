import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_datasource.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource dataSource;

  TaskRepositoryImpl(this.dataSource);

  @override
  Future<List<TaskEntity>> getTasks() => dataSource.getTasks();

  @override
  Future<TaskEntity?> getTaskById(String id) => dataSource.getTaskById(id);

  @override
  Future<void> addTask(TaskEntity task) => dataSource.addTask(task);

  @override
  Future<void> updateTask(TaskEntity task) => dataSource.updateTask(task);

  @override
  Future<void> deleteTask(String id) => dataSource.deleteTask(id);

  @override
  Future<void> clearAllTasks() => dataSource.clearAllTasks();
}
