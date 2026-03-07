import '../repositories/task_repository.dart';

class ClearAllTasksUseCase {
  final TaskRepository repository;

  ClearAllTasksUseCase(this.repository);

  Future<void> call() async {
    return await repository.clearAllTasks();
  }
}
